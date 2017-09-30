//
//  ZCAlertview.m
//  ExpertApp
//
//  Created by lizhihui on 15/10/9.
//  Copyright (c) 2015年 com.Expert.chat. All rights reserved.
//

#import "ZZAlertview.h"


@implementation ZZAlertview
{
    UIView *upLayerView;
    // 链接点击
    void (^PageItemClickBlock) (NSInteger tag);
}

- (instancetype)initWithTitle:(NSString *)title cancel:(NSString *)cancel comfirm:(NSString *)text{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        CGFloat width = 275;
        CGFloat height = 145;
        self.frame=CGRectMake(0, 0, width, height);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        self.messagelable = [[UILabel alloc]initWithFrame:CGRectMake(65, 40, 140, 40)];
        self.messagelable.textAlignment = NSTextAlignmentCenter;
        self.messagelable.text = title;
        [self addSubview:_messagelable];
        //
        self.lineimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, width, 0.5)];
        [ZZCoreTools setLineOffset:LineHorizontal withView:_lineimageview];
        self.lineimageview.backgroundColor = UIColorFromRGB(BgTitleColor);
        [self addSubview:_lineimageview];
        self.lineimage = [[UIImageView alloc]initWithFrame:CGRectMake(137, 100, 0.5, 45)];
        [ZZCoreTools setLineOffset:LineVertical withView:_lineimage];
        self.lineimage.backgroundColor = UIColorFromRGB(BgTitleColor);
        [self addSubview:_lineimage];
        // button
        self.cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelbtn.frame = CGRectMake(138, 100, 137, 50);
        self.cancelbtn.tag = 1;
        [self.cancelbtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.cancelbtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        self.cancelbtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelbtn setTitle:text forState:UIControlStateNormal];
        [self addSubview:_cancelbtn];
        // btn
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0, 100, 137, 50);
        [self.btn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.btn setTitle:cancel forState:UIControlStateNormal];
        [self addSubview:_btn];
        
    }
    return self;
}

- (void)show{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame = window.frame;
        UIView *overlayView = [[UIView alloc]initWithFrame:windowFrame];
        overlayView.backgroundColor = [UIColor clearColor];
        upLayerView = [[UIView alloc] initWithFrame:windowFrame];
        upLayerView.backgroundColor = [UIColor blackColor];
        upLayerView.alpha = 0.0;
        [overlayView addSubview:upLayerView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [upLayerView addGestureRecognizer:tap];
        [window addSubview:overlayView];
        self.center = window.center;
        self.alpha = 0;
        [overlayView addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            upLayerView.alpha = 0.3;
            self.alpha = 1;
        }];
    }
}
- (void)dismiss{// 消失
    [UIView animateWithDuration:0.3 animations:^{
        upLayerView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
    
}

-(void)setActionClickBlock:(void (^)(NSInteger))ItemClickblock{
    PageItemClickBlock = ItemClickblock;
}

- (void)changeAction:(UIButton *) btn{
    if(PageItemClickBlock){
        PageItemClickBlock(btn.tag);
    }
    
    [self dismiss];
}
// dismiss
- (void)tap{
    [self dismiss];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
