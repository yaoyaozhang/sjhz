//
//  ZZAcountTypeCell.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZAcountTypeCell.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation ZZAcountTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [_btnPay addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnPay setBackgroundColor:UIColorFromRGB(0xf9901d)];
    _btnPay.layer.cornerRadius = 2.0f;
    _btnPay.layer.masksToBounds = YES;
    [_btnPay setTitle:@"充值" forState:0];
    [_btnPay setTitleColor:UIColorFromRGB(TextWhiteColor) forState:0];
    
    [_imgTag setImage:[UIImage imageNamed:@"zzicon_jf_zfb"]];
    [_labName setTextColor:UIColorFromRGB(TextDarkColor)];
    [_labTips setTextColor:UIColorFromRGB(0xf9901e)];
    [_labCurIntegral setFont:ListDetailFont];
    [_labCurIntegral setTextColor:UIColorFromRGB(TextLightDarkColor)];
    
    [_labName setText:@"余额支付"];
    [_labTips setText:@"余额不足，请充值"];
}


-(void)dataToView:(NSDictionary *) item{
    [_labCurIntegral setText:[NSString stringWithFormat:@"(当前%@积分)",item[@"sorce"]]];
    
    if([item[@"can"] intValue] == 0){
        [_imgCheck setImage:[UIImage imageNamed:@"zzicon_jf_uncheck"]];
        
        [_imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
        _imgLine.hidden = NO;
        
        [self setFrame:CGRectMake(0, 0, ScreenWidth, 105)];
    }else if([item[@"can"] intValue] == 2){
        // 积分足够
        [self setFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _imgLine.hidden = YES;
        [_imgCheck setImage:[UIImage imageNamed:@"zzicon_jf_greencheck"]];
    }
    
    // 不要支付
    if([ZZDataCache getInstance].getCheckStatusUser){
        
        _btnPay.hidden = YES;
        _labName.hidden = YES;
        _labTips.hidden = YES;
        
        self.frame = CGRectMake(0, 0, ScreenWidth, 44);
    }
}


-(void)pageClick:(UIButton *) sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCellItemClick:)]){
        [self.delegate onCellItemClick:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
