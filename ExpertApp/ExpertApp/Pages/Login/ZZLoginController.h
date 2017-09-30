//
//  ZZLoginController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZLoginController : BaseController

@property (weak, nonatomic) IBOutlet UITextField *fieldPhone;

@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnFindPwd;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UIView *vBorder1;
@property (weak, nonatomic) IBOutlet UIView *vBorder2;


@property (weak, nonatomic) IBOutlet UIImageView *vLine1;
@property (weak, nonatomic) IBOutlet UIImageView *vLine2;


@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@property (weak, nonatomic) IBOutlet UIView *viewOtherLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnWeiXin;
@property (weak, nonatomic) IBOutlet UIButton *btnSina;
@property (weak, nonatomic) IBOutlet UIButton *btnTencent;

-(IBAction)buttonClick:(UIButton *)sender;

@end
