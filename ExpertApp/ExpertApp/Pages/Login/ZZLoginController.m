//
//  ZZLoginController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZLoginController.h"
#import "ZZRegisterController.h"
#import "ZZFindPwdController.h"
#import "JPUSHService.h"
#import "ZZUserInfo.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ZZLoginController ()

@end

@implementation ZZLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    [_viewOtherLogin setBackgroundColor:[UIColor clearColor]];
    
    [_vLine1 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine2 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    _vBorder1.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    _vBorder2.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    _vBorder1.layer.borderWidth = 1.0f;
    _vBorder2.layer.borderWidth = 1.0f;
    _vBorder1.layer.cornerRadius = 4.0f;
    _vBorder2.layer.cornerRadius = 4.0f;
    _vBorder1.layer.masksToBounds = YES;
    _vBorder2.layer.masksToBounds = YES;
    
    [_vBorder1 setBackgroundColor:[UIColor clearColor]];
    [_vBorder2 setBackgroundColor:[UIColor clearColor]];
    
    _btnLogin.layer.cornerRadius  = 4.0f;
    _btnLogin.layer.masksToBounds = YES;
    [_btnLogin setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [_btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnLogin.titleLabel setFont:ListDetailFont];
    [_btnRegister.titleLabel setFont:ListDetailFont];
    [_btnFindPwd.titleLabel setFont:ListDetailFont];
    
    [_btnRegister setTitleColor:UIColorFromRGB(TextSizeNineColor) forState:UIControlStateNormal];
    [_btnFindPwd setTitleColor:UIColorFromRGB(TextSizeNineColor) forState:UIControlStateNormal];
    
    [self setButtonLocation:_btnWeiXin];
    [self setButtonLocation:_btnSina];
    [self setButtonLocation:_btnTencent];
    
    if(ScreenHeight<=500){
        [_viewOtherLogin setFrame:CGRectMake(0, ScreenHeight-110, ScreenWidth, 90)];
    }
    
    _viewOtherLogin.hidden = YES;
    _btnRegister.hidden = YES;
    if([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] && [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]){
        _viewOtherLogin.hidden = NO;
        
        _btnRegister.hidden = NO;
    }
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    
    _fieldPhone.text = convertToString([ZCLocalStore getLocalParamter:KEY_LOGIN_USERNAME]);
    _fieldPassword.text = convertToString([ZCLocalStore getLocalParamter:KEY_LOGIN_USERPWD]);
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"http://www.sanjiahuizhen.com" forKey:ZCKEY_APIHOST];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(ScreenWidth-64, StatusBarHeight, 64, 44)];
//    [btn setTitle:@"测试" forState:0];
//    [btn addTarget:self action:@selector(changeHost:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    NSString *apiHost = [[NSUserDefaults standardUserDefaults] objectForKey:ZCKEY_APIHOST];
//
//    if(convertToString(apiHost) > 0 && [@"http://219.142.225.98:8123" isEqual:convertToString(apiHost)]){
//        [btn setTitle:@"线上" forState:0];
//    }else{
//        [btn setTitle:@"测试" forState:0];
//    }
}

-(void)changeHost:(UIButton *) btn{
    NSString *apiHost = [[NSUserDefaults standardUserDefaults] objectForKey:ZCKEY_APIHOST];
    
    if(convertToString(apiHost) > 0 && [@"http://219.142.225.98:8123" isEqual:convertToString(apiHost)]){
        [[NSUserDefaults standardUserDefaults] setObject:@"http://www.sanjiahuizhen.com" forKey:ZCKEY_APIHOST];
        [btn setTitle:@"测试" forState:0];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"http://219.142.225.98:8123" forKey:ZCKEY_APIHOST];
        [btn setTitle:@"线上" forState:0];
    }
}

-(void) setButtonLocation:(UIButton * ) btnLeft{
    [btnLeft.titleLabel setFont:ListDetailFont];
    [btnLeft setTitleColor:UIColorFromRGB(TextSizeNineColor) forState:UIControlStateNormal];
    //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
    btnLeft.titleEdgeInsets = UIEdgeInsetsMake(btnLeft.imageView.frame.size.height,  -btnLeft.imageView.frame.size.width, 0, 0);
    
    //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
    btnLeft.imageEdgeInsets = UIEdgeInsetsMake(-btnLeft.titleLabel.bounds.size.height-10, 0, 0, -btnLeft.titleLabel.bounds.size.width);
}

// 隐藏键盘
-(void)hiddenKeyboard:(id)sender
{
    [_fieldPhone resignFirstResponder];
    [_fieldPassword resignFirstResponder];
}

-(IBAction)buttonClick:(UIButton *)sender{
    [self hiddenKeyboard:nil];
    if(sender.tag == _btnRegister.tag){        
        ZZRegisterController *registerVC = [[ZZRegisterController alloc] init];
        [self openNav:registerVC sound:nil];
    }
    
    if(sender.tag == _btnLogin.tag){
        NSString *uname = convertToString(_fieldPhone.text);
        NSString *pwd = convertToString(_fieldPassword.text);
        if([@"" isEqual:uname]){
            [self.view makeToast:@"登录名不能为空!"];
            return;
        }
        if([@"" isEqual:pwd]){
            [self.view makeToast:@"密码不能为空!" ];
            return;
        }
        
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:uname forKey:@"userName"];
        [dict setObject:pwd forKey:@"passWord"];
        
        
        
        [ZZRequsetInterface post:API_Login param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if(dict[@"retData"]){
                [SVProgressHUD dismiss];
                // 清理数据
                [[ZZDataCache getInstance] loginOut];
                
                [ZCLocalStore addObject:uname forKey:KEY_LOGIN_USERNAME];
                [ZCLocalStore addObject:pwd forKey:KEY_LOGIN_USERPWD];
                
                [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:self.view];
            }
            
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];

       
    }
    
    //找回密码
    if(sender.tag == _btnFindPwd.tag){
        NSLog(@"找回密码");
        ZZFindPwdController *findVC = [[ZZFindPwdController alloc] init];
        [self openNav:findVC sound:nil];
    }
    
    if(sender.tag == _btnWeiXin.tag){
        NSLog(@"微信登录");
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
            
            NSLog(@"%@",result);
            if(!error){
                UMSocialUserInfoResponse *response = result;
                
                [self checkUserRegister:response];
                
            }
        }];
        
    }
    if(sender.tag == _btnSina.tag){
        NSLog(@"新浪微博登录");
        
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
            NSLog(@"%@",result);
            if(!error){
                UMSocialUserInfoResponse *response = result;
                
                [self checkUserRegister:response];
            }
        }];
    }
    if(sender.tag == _btnTencent.tag){
        NSLog(@"QQ登录");
        [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:self completion:^(id result, NSError *error) {
            NSLog(@"%@",result);
            if(!error){
                UMSocialUserInfoResponse *response = result;
                
                [self checkUserRegister:response];
            }
        }];
    }
    
}

-(void)checkUserRegister:(UMSocialUserInfoResponse *)response{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    [userInfo setObject:convertToString(response.uid) forKey:@"userId"];
    [userInfo setObject:convertToString(@"") forKey:@"phone"];
    [userInfo setObject:convertToString(response.name) forKey:@"userName"];
    [userInfo setObject:@"123456" forKey:@"passWord"];
    [userInfo setObject:convertToString(response.iconurl) forKey:@"imageUrl"];
    if(response.platformType == UMSocialPlatformType_WechatSession){
        [userInfo setObject:convertToString(response.openid) forKey:@"thirdId"];
    }else{
        [userInfo setObject:convertToString(response.uid) forKey:@"thirdId"];
    }
    
    [userInfo setObject:convertToString(@"0") forKey:@"isYj"];
    [userInfo setObject:convertToString(@"0") forKey:@"isDoctor"];
    
    
    [self findUserByThirdId:userInfo];
}

// 根据用户名查询用户是否存在
-(void)findUserByThirdId:(NSMutableDictionary *) userInfo{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:convertToString(userInfo[@"thirdId"]) forKey:@"third"];
    
    [ZZRequsetInterface post:API_FindUserByThirdId param:dict timeOut:0 start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSMutableDictionary *retData = dict[@"retData"];
        if(retData && retData.count>0){
            [SVProgressHUD dismiss];
            // 清理数据
            [[ZZDataCache getInstance] loginOut];
            [ZCLocalStore removeObjectforKey:KEY_LOGIN_USERPWD];
            
            [[ZZDataCache getInstance] saveLoginUserInfo:retData view:self.view];
        }else{
            [self registerThirdUser:userInfo];
        }
        
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
}

// 不存在用户注册用户到系统
-(void)registerThirdUser:(NSMutableDictionary *) infoDict{
    
    [ZZRequsetInterface post:API_Register param:infoDict timeOut:0 start:^{
        
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSMutableDictionary *retData = dict[@"retData"];
        if(retData && retData.count>0){
            // 清理数据
            [[ZZDataCache getInstance] loginOut];
            [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:self.view];
        }else{
            [self.view makeToast:@"登录失败!"];
        }
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
//        [[ZZDataCache getInstance] saveLoginUserInfo:infoDict view:self.view];
    } progress:^(CGFloat progress) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
