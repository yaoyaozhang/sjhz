//
//  ZZRegisterController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRegisterController.h"
#import "SVWebViewController.h"
#import "ZZPerfectInfoController.h"

#import "UIButton+countDown.h"

@interface ZZRegisterController (){
    CGFloat keyboardheight;
}

@end

@implementation ZZRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBorderStyle:_vBorder1];
    [self setBorderStyle:_vBorder2];
    [self setBorderStyle:_vBorder3];
    [self setBorderStyle:_vBorder4];
    [self setBorderStyle:_txtYJDesc];
    [self setBorderStyle:_txtYJOtherName];
    [self setBorderStyle:_txtName];
    
    [_vLine1 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine2 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine3 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_vLine4 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_btnSendCode setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnDoctor setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnYJ setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnLink setTitleColor:UIColorFromRGB(TextSizeNineColor) forState:UIControlStateNormal];
    [_btnRegister setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [_btnSendCode setTitle:@"发送" forState:UIControlStateNormal];
    
    [_lblLable1 setTextColor:UIColorFromRGB(TextSizeNineColor)];
    [_lblLabel2 setTextColor:UIColorFromRGB(TextSizeNineColor)];
    [_lblLabel3 setTextColor:UIColorFromRGB(TextSizeNineColor)];
    
    [_hideView setBackgroundColor:[UIColor clearColor]];
    [_bottomView setBackgroundColor:[UIColor clearColor]];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    
    _btnYJ.selected = NO;
    [self setBootomLocation];
    
    _btnCheckXY.selected = YES;
    
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
        [self setBootomLocation];
    }];
}
//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    //do something
    [UIView animateWithDuration:0.25
                     animations:^{
                         keyboardheight = 0;
                         [self setBootomLocation];
                     }completion:^(BOOL finished){
                         
                     }];
}
// 隐藏键盘
-(void)downKeyBoard:(id)sender{
    [_txtName resignFirstResponder];
    [_txtYJOtherName resignFirstResponder];
    [_txtYJDesc resignFirstResponder];
    [_txtPwd resignFirstResponder];
    [_txtCode resignFirstResponder];
    [_txtPwdConfim resignFirstResponder];
    [_txtPhone resignFirstResponder];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        
        return YES;
        
    }
    
    return NO;
}

-(void)setBorderStyle:(UIView *) vBorder{
    vBorder.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    vBorder.layer.borderWidth = 1.0f;
    vBorder.layer.cornerRadius = 4.0f;
    vBorder.layer.masksToBounds = YES;
    [vBorder setBackgroundColor:[UIColor clearColor]];
}


-(IBAction)onButtonClick:(UIButton *) btn{
    [self downKeyBoard:nil];
    if(btn.tag == _btnBack.tag){
        [SVProgressHUD dismiss];
        [self goBack:nil];
    }else if(btn.tag == _btnCheckXY.tag){
        _btnCheckXY.selected = !_btnCheckXY.selected;
    }else if(btn.tag == _btnDoctor.tag){
        _btnDoctor.selected = !_btnDoctor.selected;
    }else if(btn.tag == _btnYJ.tag){
        _btnYJ.selected = !_btnYJ.selected;
        
        [self setBootomLocation];
    }else if(btn.tag == _btnSendCode.tag){
        NSString *tel = convertToString(_txtPhone.text);
        if([@"" isEqual:tel]){
            [self.view makeToast:@"请输入手机号!"];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:tel forKey:@"mobile"];
        
        [ZZRequsetInterface post:API_SendSms param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            
            // {"retCode":"0","retData":"8426","retMsg":"suc"}
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
            [_btnSendCode startWithTime:60 title:@"重新发送" countDownTitle:@"S" mainColor:UIColorFromRGB(BgTitleColor) countColor:UIColorFromRGB(TextPlaceHolderColor)];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }else if(btn.tag == _btnLink.tag){
        SVWebViewController *vc = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        [self openNav:vc sound:nil];
    }else if(btn.tag == _btnRegister.tag){
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
        [dict setObject:convertIntToString(_btnYJ.selected?1:0) forKey:@"isYj"];
        [dict setObject:convertIntToString(_btnDoctor.selected?1:0) forKey:@"isDoctor"];
        
        [dict setObject:tel forKey:@"mobile"];
        [dict setObject:pwd forKey:@"passWord"];
        [dict setObject:code forKey:@"verCode"];
        [dict setObject:convertToString(@"") forKey:@"thirdId"];
        [dict setObject:tel forKey:@"userName"];
        if(_btnYJ.selected){
            [dict setObject:convertToString(_txtYJDesc.text) forKey:@"yjBackGround"];
            [dict setObject:convertToString(_txtName.text) forKey:@"name"];
            [dict setObject:convertToString(_txtYJOtherName.text) forKey:@"witness"];
        }
        
        
        if(_btnDoctor.selected){
            ZZPerfectInfoController *vc = [[ZZPerfectInfoController alloc] init];
            vc.params = dict;
            [self openNav:vc sound:nil];
            return;
        }
        

        [ZZRequsetInterface post:API_Register param:dict timeOut:0 start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            // 清理数据
            [[ZZDataCache getInstance] loginOut];
            
            [ZCLocalStore addObject:dict[@"mobile"] forKey:KEY_LOGIN_USERNAME];
            [ZCLocalStore addObject:dict[@"passWord"] forKey:KEY_LOGIN_USERPWD];
            
            [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:self.view];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
    
}


-(void)setBootomLocation{
    _hideView.hidden = !_btnYJ.selected;
    CGRect f = _bottomView.frame;
    if(_btnYJ.selected){
        f.origin.y = _hideView.frame.origin.y + _hideView.frame.size.height + 30;
    }else{
        f.origin.y = _btnYJ.frame.origin.y + _btnYJ.frame.size.height + 30;
    }
    _bottomView.frame = f;
    CGSize contentSize = CGSizeMake(ScreenWidth, f.size.height + f.origin.y);
    if(contentSize.height <= ScreenHeight){
        contentSize.height = ScreenHeight;
    }
    
    contentSize.height = contentSize.height + keyboardheight;
    
    [_contentScrollView setContentSize:contentSize];
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
