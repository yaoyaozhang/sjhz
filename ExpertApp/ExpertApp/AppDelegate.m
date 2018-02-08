//
//  AppDelegate.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "AppDelegate.h"
#import <UMMobClick/MobClick.h>
#import "RDVTabBarController.h"
#import "ZZGuideController.h"
#import "ZZLoginController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>
#import "WXApiManager.h"
#import "SVWebViewController.h"
#import "ZZChapterDetailController.h"
#import "ZZPatientSymptomController.h"
#import "ZZDoctorDetailController.h"
#import "ASQController.h"
#import "ZZChoosePatientController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

#import <AlipaySDK/AlipaySDK.h>

#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (void)switchRootViewController
{
//    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
//    NSString *lastVersion = [ZZCoreTools getValueFromNSUserDefaultsByKey:key];
//
//    // 当前软件的版本号（从Info.plist中获得）
//    NSString *currentVersion = [ZZCoreTools getAppBuildVersion];
    
    // 版本号相同：这次打开和上次打开的是同一个版本
//    if ([currentVersion isEqualToString:lastVersion]) {
        if(![[ZZDataCache getInstance] isLogin]){
            ZZLoginController * login = [[ZZLoginController alloc] initWithNibName:@"ZZLoginController" bundle:nil];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:login];
            nav.navigationBarHidden=YES;
            self.window.rootViewController = nav;
        }
//    } else {
//        // 将当前的版本号存进沙盒
//        [ZZCoreTools syncNSUserDeafaultsByKey:key withValue:currentVersion];
//        
//        // 这次打开的版本和上一次不一样，显示新特性
//        self.window.rootViewController = [[ZZGuideController alloc] init];
//    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UMConfigInstance.appKey = @"59683778c62dca2b2700045e";
    UMConfigInstance.channelId = @"App store";
    
    [MobClick startWithConfigure:UMConfigInstance];
    // 关闭日志上传
//    [MobClick setCrashReportEnabled:NO];
    
    
    // 第三方配置
    [[UMSocialManager defaultManager] openLog:YES];
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMConfigInstance.appKey];
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"f80324002b3951d1af087967"
                          channel:@"APP store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    
    
    [self switchRootViewController];
    
    
    [self launchImageView];
    
    return YES;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }else{
            if([url.absoluteString hasPrefix:@"wx759030b1505761bf://pay/"]){
                return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
            }
            if([url.absoluteString hasPrefix:@"wx759030b1505761bf://platformId"]){
                return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
                
            }
        }
    }
    return result;
}

#pragma mark - 微信支付回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[UMSocialManager defaultManager] handleOpenURL:url];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
    }else{
        if([url.absoluteString hasPrefix:@"wx759030b1505761bf://pay/"]){
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        if([url.absoluteString hasPrefix:@"wx759030b1505761bf://platformId"]){
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
            
        }
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }else{
        if([url.absoluteString hasPrefix:@"wx759030b1505761bf://pay/"]){
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
        if([url.absoluteString hasPrefix:@"wx759030b1505761bf://platformId"]){
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
            
        }
    }
    [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"获取成功: %@", deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    [self parseNotice:userInfo];
    /**
     {
    "_j_business" = 1;
    "_j_msgid" = 2038183454;
    "_j_uid" = 11875969077;
    aps =     {
        alert = "\U6709\U4eba\U5173\U6ce8\U4f60\U5566";
        badge = 3;
        sound = "sound.caf";
    };
    "iosNotification extras key" = "{\"action\":\"17\",\"type\":\"2\"}";
}
*/
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    [self parseNotice:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    UMSocialImageWarterMarkConfig *config = [UMSocialImageWarterMarkConfig defaultImageWarterMarkConfig];
    config.warterMarkImage = [UIImage imageNamed:@"Icon120"];
    UMSocialWarterMarkConfig *umconfig = [UMSocialWarterMarkConfig defaultWarterMarkConfig];
    [umconfig setUserDefinedImageWarterMarkConfig:config];
    [UMSocialGlobal shareInstance].warterMarkConfig = umconfig;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx759030b1505761bf" appSecret:@"fc0893677caba198cedc08af67b63662" redirectURL:nil];
//    [WXApi registerApp:@"wx759030b1505761bf"];
    
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106245555"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2165005490"  appSecret:@"c194941e9807c6fc0d1a097ac3af5eef" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:nil];
}


-(void)launchImageView{
    // 在window上放一个imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"Startpage"];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setBackgroundColor:UIColor.whiteColor];
    [self.window addSubview:imageView];
    
    // 执行动画
    [UIView animateWithDuration:1 animations:^{
        // 两秒内图片变大为原来的1.3倍
        imageView.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        // 动画结束，移除imageView，呈现主界面
        [imageView removeFromSuperview];
    }];
}

#pragma mark - 获取Oss信息
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//定义type=1的时候，就取action的字符串干活
-(void)parseNotice:(NSDictionary *) userInfo{
    NSString *actionStr = [userInfo objectForKey:@"iosNotification extras key"];
    NSDictionary *dict = [self dictionaryWithJsonString:actionStr];
    if([dict[@"type"] intValue] == 1){
        [self openNewPage:dict[@"action"]];
    }
}

-(void)openNewPage:(NSString *) action{
    if(![[ZZDataCache getInstance] isLogin]){
        return;
    }
    UIViewController *rootVC = [self getCurVC];
    if(is_null(action) || is_null(rootVC)){
        return;
    }
    if(![rootVC isKindOfClass:[UIViewController class]]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openNewPage:action];
        });
        return;
    }
    if([action hasPrefix:@"http"]){
        SVWebViewController *vc = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:action]];
        [rootVC.navigationController pushViewController:vc animated:YES];
    }else if([action hasPrefix:@"sjhz://news"]){
        ZZChapterDetailController *vc = [[ZZChapterDetailController alloc] init];
        ZZChapterModel *model = [ZZChapterModel new];
        model.nid = [[action stringByReplacingOccurrencesOfString:@"sjhz://news?id=" withString:@""] intValue];
        vc.model = model;
        [rootVC.navigationController pushViewController:vc animated:YES];
    }else if([action hasPrefix:@"sjhz://case"]){
        // 如果是医生，刷新医生首页，如果是用户，跳转到会诊详情
        if([ZZDataCache getInstance].getLoginUser.isDoctor){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZNoticeInviteDoctorSucess" object:nil];
        }else{
            
           
            ZZPatientSymptomController *vc = [[ZZPatientSymptomController alloc] init];
            ZZHZEngity *model = [ZZHZEngity new];
            action = [action stringByReplacingOccurrencesOfString:@"sjhz://case?" withString:@""];
            NSArray *arr = [action componentsSeparatedByString:@"&"];
            for (NSString *item in arr) {
                NSArray *items = [item componentsSeparatedByString:@"="];
                if(items.count == 2){
                    if([@"caseId" isEqual:items[0]]){
                        model.caseId = [items[1] intValue];
                    }
                    if([@"state" isEqual:items[0]]){
                        model.state =[items[1] intValue];
                    }
                }
            }
            vc.entity = model;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }
    }else if([action hasPrefix:@"sjhz://doctor"]){
        int docId = [[action stringByReplacingOccurrencesOfString:@"sjhz://doctor?userId=" withString:@""] intValue];
        // 如果是医生，刷新医生首页，如果是用户，跳转到会诊详情
        if([ZZDataCache getInstance].getLoginUser.userId == docId ){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZNoticeInviteDoctorSucess" object:nil];
        }else{
            // sjhz:///doctor?userI1d=17
            ZZDoctorDetailController *vc = [[ZZDoctorDetailController alloc] init];
            vc.docId = docId;
    //        vc.model = model;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }
    }
    else if([action hasPrefix:@"sjhz://liangbiao"]){
        // sjhz:///doctor?userI1d=17
        ASQController *vc = [[ASQController alloc] init];
        ZZQSListModel *model = [ZZQSListModel new];
        action = [action stringByReplacingOccurrencesOfString:@"sjhz://liangbiao?" withString:@""];
        NSArray *arr = [action componentsSeparatedByString:@"&"];
        for (NSString *item in arr) {
            NSArray *items = [item componentsSeparatedByString:@"="];
            if(items.count == 2){
                if([@"lbId" isEqual:items[0]]){
                    model.wenjuanId = [items[1] intValue];
                }
                if([@"type" isEqual:items[0]]){
                    model.type =[items[1] intValue];
                }
            }
        }
        vc.model = model;
        vc.type = ASQTYPELB;
        [rootVC.navigationController pushViewController:vc animated:YES];
    }else if([action hasPrefix:@"sjhz://wenjuan"]){
        // sjhz:///doctor?userI1d=17
        ASQController *vc = [[ASQController alloc] init];
        ZZQSListModel *model = [ZZQSListModel new];
        action = [action stringByReplacingOccurrencesOfString:@"sjhz://wenjuan?" withString:@""];
        NSArray *arr = [action componentsSeparatedByString:@"&"];
        for (NSString *item in arr) {
            NSArray *items = [item componentsSeparatedByString:@"="];
            if(items.count == 2){
                if([@"wjId" isEqual:items[0]]){
                    model.wenjuanId = [items[1] intValue];
                }
                if([@"type" isEqual:items[0]]){
                    model.type =[items[1] intValue];
                }
            }
        }
        vc.model = model;
        vc.type = ASQTYPEWJ;
        [rootVC.navigationController pushViewController:vc animated:YES];
    }else if([action hasPrefix:@"sjhz://wenzhen?docId"]){
        ZZChoosePatientController *vc = [[ZZChoosePatientController alloc] init];
        vc.doctorId  = [action stringByReplacingOccurrencesOfString:@"sjhz://wenzhen?docId=" withString:@""];
        [rootVC.navigationController pushViewController:vc animated:YES];
    }
}

-(UIViewController *)getCurVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}


////////////////////////////
//

@end
