//
//  ZZFindPwdController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/17.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZFindPwdController.h"

#import "UIButton+countDown.h"

@interface ZZFindPwdController (){
    CGFloat keyboardheight;
}

@end

@implementation ZZFindPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBorderStyle:_vBorder1];
    [self setBorderStyle:_vBorder2];
    [self setBorderStyle:_vBorder3];
    [self setBorderStyle:_vBorder4];
    
    [_vLine1 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine2 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine3 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine4 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_btnSendCode setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnSendCode setTitle:@"发送" forState:UIControlStateNormal];
    
    [_btnCommit setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    keyboardheight = 0.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //使用NSNotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    if([ZZDataCache getInstance].isLogin){
        [self.labTitle setText:@"绑定手机号"];
    }else{
        [self.labTitle setText:@"找回密码"];
    }
    
    
    CGRect f = _btnBack.frame;
    CGRect tf = _labTitle.frame;
    
    f.origin.y = StatusBarHeight;
    tf.origin.y = StatusBarHeight;
    
    _btnBack.frame = f;
    _labTitle.frame = tf;
    
}

-(IBAction)onButtonClick:(UIButton *) btn{
    [self downKeyBoard:nil];
    if(btn.tag == _btnBack.tag){
        [SVProgressHUD dismiss];
        
        [self goBack:nil];
    }else if(btn.tag == _btnSendCode.tag){
        NSString *tel = convertToString(_txtPhone.text);
        if([@"" isEqual:tel]){
            [self.view makeToast:@"请输入手机号!"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:tel forKey:@"mobile"];
        
        [ZZRequsetInterface post:API_SendSms param:dict timeOut:0 start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            
             [_btnSendCode startWithTime:60 title:@"重新发送" countDownTitle:@"S" mainColor:UIColorFromRGB(BgTitleColor) countColor:UIColorFromRGB(TextPlaceHolderColor)];
            // {"retCode":"0","retData":"8426","retMsg":"suc"}
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }else if(btn.tag == _btnCommit.tag){
        NSString *tel = convertToString(_txtPhone.text);
        if([@"" isEqual:tel]){
            [self.view makeToast:@"请输入手机号!"];
            return;
        }
        NSString *pwd = convertToString(_txtPwd.text);
        NSString *cpwd = convertToString(_txtPwdConfim.text);
        if([@"" isEqual:pwd]){
            [self.view makeToast:@"密码不能为空!"];
            return;
        }
        
        if(![pwd isEqual:cpwd]){
            [self.view makeToast:@"两次密码不一致!"];
            return;
        }
        NSString *code = convertToString(_txtCode.text);
        if([@"" isEqual:code]){
            [self.view makeToast:@"验证码不能为空!"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:tel forKey:@"mobile"];
        [dict setObject:pwd forKey:@"newPwd"];
        [dict setObject:convertToString(_txtCode.text) forKey:@"verCode"];
        
        NSString *api = API_UpdatePwd;
        if([ZZDataCache getInstance].isLogin){
            ZZUserInfo *login = [self getLoginUser];
            [dict setObject:convertIntToString(login.userId) forKey:@"userId"];
            [dict setObject:convertToString(login.thirdId) forKey:@"thirdId"];
            api=API_bindPhone;
        }
        
        [ZZRequsetInterface post:api param:dict timeOut:0 start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [SVProgressHUD showSuccessWithStatus:@"设置成功!"];
            if([ZZDataCache getInstance].isLogin){
                // 清理数据
                [[ZZDataCache getInstance] loginOut];
                
                [ZCLocalStore addObject:dict[@"retData"] forKey:KEY_LOGIN_USERINFO];
                
                [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:self.view];
            }
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
    
}


#pragma mark --键盘处理
- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    keyboardheight = keyboardSize.height;
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        //do something
        
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    //do something
    [UIView animateWithDuration:0.25
                     animations:^{
                         keyboardheight = 0;
                     }completion:^(BOOL finished){
                         
                     }];
}
// 隐藏键盘
-(void)downKeyBoard:(id)sender{
    [_txtPwd resignFirstResponder];
    [_txtCode resignFirstResponder];
    [_txtPwdConfim resignFirstResponder];
    [_txtPhone resignFirstResponder];
}


-(void)setBorderStyle:(UIView *) vBorder{
    vBorder.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    vBorder.layer.borderWidth = 1.0f;
    vBorder.layer.cornerRadius = 4.0f;
    vBorder.layer.masksToBounds = YES;
    [vBorder setBackgroundColor:[UIColor clearColor]];
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
