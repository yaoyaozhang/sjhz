//
//  ZZRewardController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRewardController.h"
#import "UIButtonUpDown.h"
#import "ZZPayHandler.h"
#import "ZZUserHomeModel.h"
#import "ZZChapterModel.h"
#import "ZZHZEngity.h"

@interface ZZRewardController (){
    UIButton *checkNum;
}

@end

@implementation ZZRewardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:@"送心意" forState:UIControlStateNormal];
    
    CGFloat y = NavBarHeight;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-35, y+25, 70, 70)];
    imgView.layer.cornerRadius = 35.0f;
    imgView.layer.masksToBounds = YES;
    imgView.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    imgView.layer.borderWidth = 1.0f;
    [self.view addSubview:imgView];
    
    y = NavBarHeight + 95;
    
    NSString *author = @"";
    if(_type == ZZRewardTypeDoctor){
        ZZUserHomeModel *model = _rewardModel;
        author = model.docName;
    }
    if(_type == ZZRewardTypeChapter){
        ZZChapterModel *model = _rewardModel;
        author = model.author;
    }
    if(_type == ZZRewardTypeHZ){
        ZZHZEngity *model = _rewardModel;
        author = model.docName;
    }
    [self createLabel:author y:y];
    
    y = NavBarHeight + 131;
    
    UILabel *rLabel = [self createLabel:@"谢谢大夫的辛苦付出" y:y];
    [rLabel setTextColor:UIColorFromRGB(0xD12E45)];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, NavBarHeight + 171, ScreenWidth - 30, 2)];
    [lineView setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    [self.view addSubview:lineView];
    
    y = NavBarHeight + 188;
    [self createLabel:@"请选择答谢金额" y:y];
    
    [self createButtonItems];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"微信支付" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(15,NavBarHeight + 342 , ScreenWidth/2-20, 40)];
    [btn.titleLabel setFont:ListDetailFont];
    [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pay_wechat"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"pay_wechat"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 111;
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(ScreenWidth/2+5,NavBarHeight + 342 , ScreenWidth/2-20, 40)];
    [btn2.titleLabel setFont:ListDetailFont];
    [btn2 setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"pay_alipay"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"pay_alipay"] forState:UIControlStateHighlighted];
    [btn2 setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    btn2.layer.cornerRadius = 4.0f;
    btn2.layer.masksToBounds = YES;
    btn2.layer.borderWidth = 1.0f;
    btn2.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    [btn2 addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 222;
    [self.view addSubview:btn2];
    
    
}

-(void)checkButtonClick:(UIButton *) btn{
    // 0 完成， 1-5价格
    if(btn.tag > 5){
        if(checkNum == nil){
            return;
        }
        
        NSString *num = checkNum.titleLabel.text;
        if(checkNum.tag < 5){
            num = [num stringByReplacingOccurrencesOfString:@"元" withString:@""];
        }
        
        NSString *desc = @"";
        int receivedId = 0;
        if(_type == ZZRewardTypeDoctor){
            ZZUserHomeModel *model = _rewardModel;
            desc = [NSString stringWithFormat:@"打赏%@医生",model.docName];
            receivedId = model.userId;
        }
        if(_type == ZZRewardTypeChapter){
            ZZChapterModel *model = _rewardModel;
            desc = [NSString stringWithFormat:@"打赏%@的文章：%@",model.author,model.title];
            receivedId = model.userId;
        }
        if(_type == ZZRewardTypeHZ){
            ZZHZEngity *model = _rewardModel;
            desc = [NSString stringWithFormat:@"打赏%@医生会诊：%@",model.docName,model.caseName];
            receivedId = model.caseId;
        }
        
        if(btn.tag == 111){
            // 微信
            [ZZPayHandler startJumppay:receivedId payType:ZZPayTypeWX type:_type otherId:@"111" desc:desc prict:[num floatValue] result:^(int code, NSString *msg) {
                [self.view makeToast:msg];
            }];
        }else{
            // 支付宝
            [ZZPayHandler startJumppay:receivedId payType:ZZPayTypeZFB type:_type otherId:@"111" desc:desc prict:[num floatValue] result:^(int code, NSString *msg) {
                [self.view makeToast:msg];
            }];
        }
    }else if(btn.tag < 5){
        
        if(checkNum!=nil){
            [checkNum setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
        checkNum = btn;
    } else if(btn.tag==5){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入金额" preferredStyle:UIAlertControllerStyleAlert];
        
        //增加取消按钮；
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        
        
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //获取第1个输入框；
            UITextField *userNameTextField = alertController.textFields.firstObject;
            NSString *num = userNameTextField.text;
            if(validateNumber(num)){
                [btn setTitle:userNameTextField.text forState:UIControlStateNormal];
                if(checkNum!=nil){
                    [checkNum setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
                }
                
                [btn setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
                checkNum = btn;
                
            }else{
                [self.view makeToast:@"请输入数字"];
                
                [self presentViewController:alertController animated:true completion:nil];
            }
            
        }]];
        
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"打赏金额";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            
        }];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

-(UILabel *)createLabel:(NSString *) text y:(CGFloat )y{
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 22)];
    [labText setText:text];
    [labText setFont:ListTitleFont];
    [labText setTextAlignment:NSTextAlignmentCenter];
    [labText setBackgroundColor:[UIColor clearColor]];
    [labText setTextColor:UIColorFromRGB(TextBlackColor)];
    [self.view addSubview:labText];
    return labText;
}

-(void)createButtonItems{
    CGFloat x = 30;
    CGFloat xw = (ScreenWidth - 60-40)/5;
    CGFloat y = NavBarHeight + 237;
    NSArray *titles = @[@"5元",@"10元",@"15元",@"30元",@"更多"];
    for (int i=0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(x, y, xw, xw)];
        btn.layer.cornerRadius = xw/2;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1.0f;
        [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        btn.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
        [btn addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [self.view addSubview:btn];

        x  = x + xw + 10;
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
