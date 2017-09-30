//
//  ZZFindPwdController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/17.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZFindPwdController : BaseController


@property (weak, nonatomic) IBOutlet UILabel *labTitle;


@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdConfim;

@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIView *vBorder1;
@property (weak, nonatomic) IBOutlet UIView *vBorder2;
@property (weak, nonatomic) IBOutlet UIView *vBorder3;
@property (weak, nonatomic) IBOutlet UIView *vBorder4;

@property (weak, nonatomic) IBOutlet UIImageView *vLine1;
@property (weak, nonatomic) IBOutlet UIImageView *vLine2;
@property (weak, nonatomic) IBOutlet UIImageView *vLine3;
@property (weak, nonatomic) IBOutlet UIImageView *vLine4;

@end
