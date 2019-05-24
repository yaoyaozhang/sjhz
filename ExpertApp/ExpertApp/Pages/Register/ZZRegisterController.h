//
//  ZZRegisterController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZRegisterController : BaseController

@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSendCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdConfim;


@property (weak, nonatomic) IBOutlet UIView *hideView;

@property (weak, nonatomic) IBOutlet UITextField *txtYJDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UITextField *txtInviteCode;


@property (weak, nonatomic) IBOutlet UIButton *btnLink;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;


@property (weak, nonatomic) IBOutlet UITextField *txtYJOtherName;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet UIView *vBorder1;
@property (weak, nonatomic) IBOutlet UIView *vBorder2;
@property (weak, nonatomic) IBOutlet UIView *vBorder3;
@property (weak, nonatomic) IBOutlet UIView *vBorder4;
@property (weak, nonatomic) IBOutlet UIView *vBorder5;


@property (weak, nonatomic) IBOutlet UIImageView *vLine1;

@property (weak, nonatomic) IBOutlet UIImageView *vLine2;
@property (weak, nonatomic) IBOutlet UIImageView *vLine3;
@property (weak, nonatomic) IBOutlet UIImageView *vLine4;

@property (weak, nonatomic) IBOutlet UIImageView *vLine5;


@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;


@property (weak, nonatomic) IBOutlet UILabel *lblLable1;
@property (weak, nonatomic) IBOutlet UILabel *lblLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lblLabel3;




@property (weak, nonatomic) IBOutlet UIButton *btnDoctor;

@property (weak, nonatomic) IBOutlet UIButton *btnYJ;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckXY;



@end
