//
//  ZZNickController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNickController.h"
#import "UIView+Border.h"

@interface ZZNickController (){
    ZZUserInfo *loginUser;
    
    UITextField *textfield;
}

@end

@implementation ZZNickController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"修改昵称" forState:UIControlStateNormal];
    if(_type == ZZUserEidtTypeSC){
        [self.menuTitleButton setTitle:@"修改擅长" forState:UIControlStateNormal];
    }
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self.menuRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.menuRightButton setImage:nil forState:UIControlStateNormal];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, NavBarHeight + 10, ScreenWidth, 44)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView addBottomBorderWithColor:UIColorFromRGB(BgListSectionColor) andWidth:1.0f];
    [bgView addTopBorderWithColor:UIColorFromRGB(BgListSectionColor) andWidth:1.0f];
    [self.view addSubview:bgView];
    
    
    textfield = [[UITextField alloc] initWithFrame:CGRectMake(15, 6, ScreenWidth-30, 32)];
    [textfield setFont:ListDetailFont];
    [textfield setTextColor:UIColorFromRGB(TextDarkColor)];
    if(_type == ZZUserEidtTypeNick){
        
        [textfield setText:convertToString(loginUser.name)];
    }else if(_type == ZZUserEidtTypeSC){
        
        [textfield setText:convertToString(loginUser.accomplished)];
    }
    [bgView addSubview:textfield];
    
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        NSString *name = convertToString(textfield.text);
        if([@"" isEqual:name]){
            if(_type == ZZUserEidtTypeNick){
                [self.view makeToast:@"昵称不能为空!"];
            }
            if(_type == ZZUserEidtTypeSC){
                [self.view makeToast:@"您还没有填写擅长信息!"];
            }
            return;
        }
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(_type == ZZUserEidtTypeNick){
            [dict setObject:convertToString(name) forKey:@"name"];
        }
        
        if(_type == ZZUserEidtTypeSC){
            [dict setObject:convertToString(name) forKey:@"accomplished"];
            [dict setObject:convertToString(loginUser.userName) forKey:@"name"];
        }
        
        [dict setObject:convertToString(loginUser.thirdId) forKey:@"thirdId"];
        [dict setObject:convertIntToString(loginUser.isYj) forKey:@"isYj"];
        [dict setObject:convertToString(loginUser.witness) forKey:@"witness"];
        [dict setObject:convertToString(loginUser.yjBackGround) forKey:@"yjBackGround"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
        [ZZRequsetInterface post:API_UpdateUserInfo param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if(_type == ZZUserEidtTypeSC){
                
                loginUser.accomplished = name;
            }
            if(_type == ZZUserEidtTypeNick){
                
                loginUser.name = name;
            }
            
            [[ZZDataCache getInstance] changeUserInfo:loginUser];
            
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
