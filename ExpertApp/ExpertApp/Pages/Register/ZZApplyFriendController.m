//
//  ZZApplyFriendController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZApplyFriendController.h"

@interface ZZApplyFriendController (){
    UITextField *textfield;
    ZZUserInfo *loginUser;
}

@end

@implementation ZZApplyFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"朋友验证" forState:UIControlStateNormal];
    [self.menuLeftButton setImage:nil forState:UIControlStateNormal];
    [self.menuRightButton setImage:nil forState:UIControlStateNormal];
    [self.menuLeftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.menuRightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, 77)];
    [view setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    [self.view addSubview:view];
    
    UIView *tipView = [self createTips:@"你需要发送验证申请，等对方通过"];
    UIImageView *tipIcon = [tipView viewWithTag:1];
    [tipIcon setImage:[UIImage imageNamed:@"prompt"]];
    
    [view addSubview:tipView];
    
    UIView *bgWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 37, ScreenWidth, 40)];
    [bgWhite setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:bgWhite];
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 4, ScreenWidth-30, 32)];
    [textfield setFont:ListDetailFont];
    [textfield setTextColor:UIColorFromRGB(TextDarkColor)];
    
    [textfield setText:[NSString stringWithFormat:@"我是%@~",convertToString(loginUser.userName)]];
    
    [bgWhite addSubview:textfield];
}

-(void) buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [super buttonClick:sender];
    }
    
    if(sender.tag == RIGHT_BUTTON){
        // 关注
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_toUserId) forKey:@"toUserId"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"forUserId"];
        [dict setObject:convertToString(textfield.text) forKey:@"context"];
        [ZZRequsetInterface post:API_followUserDoctor param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [self.view makeToast:@"关注成功!"];
            if(_ZZApplyFriendResultBlock){
                _ZZApplyFriendResultBlock(1);
            }
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
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
