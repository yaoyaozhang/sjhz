//
//  ViewController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ViewController.h"
#import "RDVTabBarItem.h"

#import "ZZLoginController.h"
#import "ZZChapterListController.h"
#import "ZZSettingController.h"
#import "ZZUserHomeController.h"
#import "ZZNewsController.h"
#import "ZZRequsetInterface.h"

#import "ZZUserHomeController.h"
#import "UserIndexController.h"

#import "ZZKnowledgeSegmentController.h"

#import "ZZKnowledgeHomeController.h"
#import "ZZDoctorHomeController.h"

#import "ExpertApp-Swift.h"



@interface ViewController ()<RDVTabBarControllerDelegate>{
     NSInteger selectedTabBarIiemTag;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customizeTabBarForController:self];
    self.delegate = self;
    

    // 重新登录，重置数据
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:convertToString([ZCLocalStore getLocalParamter:KEY_LOGIN_USERNAME]) forKey:@"userName"];
    [dict setObject:convertToString([ZCLocalStore getLocalParamter:KEY_LOGIN_USERPWD]) forKey:@"passWord"];
    
    
    if(convertToString(dict[@"passWord"]).length == 0 || [convertToString([ZCLocalStore getLocalParamter:KEY_LOGIN_OUTBYSELF]) intValue] == 0){
        return;
    }
    
    [ZZRequsetInterface post:API_Login param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        
        if(dict[@"retData"]){
            // 清理数据
            [[ZZDataCache getInstance] loginOut];
            
            [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:nil];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    
    NSArray *tabBarItemImages = @[@"tab_treatment", @"tab_knowledge",@"tab_news",@"tab_mine"];
    NSArray *tabBarItemTitles = @[@"慧诊", @"知识",@"消息",@"我的"];
    
    ZZUserInfo *loginUser = [[ZZDataCache getInstance] getLoginUser];
    // Do any additional setup after loading the view, typically from a nib.
//    UserIndexController *homeView=[[UserIndexController alloc]init];
    ZZUserHomeController *homeView = [[ZZUserHomeController alloc] init];
    
    ZZDoctorHomeController *docView = [[ZZDoctorHomeController alloc] init];
    
//    ZZChapterListController *regView=[[ZZChapterListController alloc]init];
//    ZZKnowledgeHomeController *knowledge = [[ZZKnowledgeHomeController alloc] init];
    ZZKnowledgeSegmentController *knowledge = [[ZZKnowledgeSegmentController alloc] init];
    
    ZZNewsController *newView=[[ZZNewsController alloc] init];
    
    ZZSettingController *settingView=[[ZZSettingController alloc]init];
    
    if(loginUser && loginUser.isDoctor == 1){
        
        tabBarItemImages = @[@"tab_knowledge",@"tab_treatment", @"tab_news",@"tab_mine"];
        tabBarItemTitles = @[@"知识",@"慧诊",@"消息",@"我的"];
//        self.viewControllers = @[docView,newView,settingView];
        self.viewControllers = @[knowledge,docView,newView,settingView];
    }else{
        
        self.viewControllers = @[homeView,knowledge,newView,settingView];
    }
    
    NSInteger index = 0;
    for (RDVTabBarItem *tabberItem in [[tabBarController tabBar] items]) {
        
        tabberItem.title = tabBarItemTitles[index];
        
        tabberItem.tag = 100+index;
        
        //修改tabberItem的title颜色
        [tabberItem setSelectedTitleAttributes:@{NSFontAttributeName: ListTimeFont,
                                           NSForegroundColorAttributeName:UIColorFromRGB(BgTitleColor)}];
//        [tabberItem setUnselectedTitleAttributes:@{NSFontAttributeName:ListTimeFont,NSForegroundColorAttributeName: UIColorFromRGB(TextPlaceHolderColor)}];
        [tabberItem setUnselectedTitleAttributes:@{NSFontAttributeName:ListTimeFont,NSForegroundColorAttributeName: UIColorFromRGB(TextLightDarkColor)}];
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        //设置tabberItem的选中和未选中图片
        [tabberItem setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
//        if(index==0){
//            tabberItem.badgeValue = @"1";
//        }
        
        index++;
    }
}

#pragma mark - 防止tabbar双击
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if(selectedTabBarIiemTag == viewController.rdv_tabBarItem.tag){
        return NO;
        
    }else {
        
        selectedTabBarIiemTag = viewController.rdv_tabBarItem.tag;
//        viewController.rdv_tabBarItem.badgeValue = @"";
        return YES;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
