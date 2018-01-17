//
//  ZZBaseAlertView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/16.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseAlertView.h"

@interface ZZBaseAlertView(){
    CGFloat cWidth;
}

@property(nonatomic,strong) UIView *bView;
@property (nonatomic, copy) UIView *contentView;

@end

@implementation ZZBaseAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel comfirm:(NSString *)text{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = UIColorFromRGBAlpha(TextBlackColor, 0.7);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
//        [self addGestureRecognizer:tap];
        
    
        cWidth = ScreenWidth - 60;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-180/2, cWidth, 180)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 5.0f;
        _contentView.layer.masksToBounds = YES;
        [self addSubview:_contentView];
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setImage:[UIImage imageNamed:@"prompt"] forState:0];
        [titleButton setTitle:title forState:0];
        [titleButton setTitleColor:UIColorFromRGB(TextDarkColor) forState:0];
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [titleButton setFrame:CGRectMake(0, 15, cWidth, 30)];
        [_contentView addSubview:titleButton];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 55, cWidth - 10, 1.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [_contentView addSubview:lineView];
        
        
        _subContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, cWidth, 40)];
        _subContentView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:_subContentView];
        
        
        _bView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, cWidth, 60)];
        [_bView setBackgroundColor:UIColor.clearColor];
        [_bView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [_contentView addSubview:_bView];
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(10, 10, (cWidth-30)/2, 35)];
        [btn1 setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
        [btn1.titleLabel setFont:ListTitleFont];
        [btn1 setTitle:text forState:0];
        [btn1 setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        btn1.layer.cornerRadius = 5.0f;
        btn1.layer.masksToBounds = YES;
        btn1.tag = 1;
        [btn1 addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bView addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake(20+(cWidth-30)/2, 10, (cWidth-30)/2, 35)];
        [btn2 setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        [btn2.titleLabel setFont:ListTitleFont];
        [btn2 setTitle:cancel forState:0];
        [btn2 setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        btn2.layer.cornerRadius = 5.0f;
        btn2.layer.masksToBounds = YES;
        btn2.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
        btn2.layer.borderWidth = 1.0f;
        btn2.tag = -1;
        [btn2 addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bView addSubview:btn2];
    }

    return self;
}

-(void)layoutConentView{
    CGFloat h = CGRectGetMaxY(_subContentView.frame) + 30;
    [_bView setFrame:CGRectMake(0, h , cWidth, 60)];
    [_contentView setFrame:CGRectMake(30, ScreenHeight/2-(h+60)/2, cWidth, h + 60)];
}

-(IBAction)onButtonClick:(UIButton *)sender{
    if(sender.tag >= 0){
        if(_block){
            _block(sender.tag,@"");
        }
    }
    
    [self dismiss];
}
//
//-(UIButton *)createShareButton{
//    UIButton *btn = ({
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn1 setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
//        [btn1.titleLabel setFont:ListTitleFont];
//        [btn1 setBackgroundColor:UIColorFromRGB(BgTitleColor)];
//        btn1.layer.cornerRadius = 5.0f;
//        btn1.layer.masksToBounds = YES;
//        [btn1 addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn1;
//    });
//
//    return btn;
//}

- (void)show{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)dismiss{// 消失
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
