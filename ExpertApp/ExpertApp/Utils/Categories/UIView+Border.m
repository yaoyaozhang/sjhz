//
//  UIView+UIView_Border.m
//  Tutu
//
//  Created by gaoyong on 14/10/30.
//  Copyright (c) 2014年 zxy. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CGFloat pixelAdjustOffset = 0;
    if ((int)(borderWidth * [UIScreen mainScreen].scale + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }

    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(-pixelAdjustOffset, 0, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

-(void)addTopBorderWithColor:(UIColor *)color andWidth:(CGFloat)borderWidth andViewWidth:(CGFloat)viewWidth{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    CGFloat pixelAdjustOffset = 0;
    if ((int)(borderWidth * [UIScreen mainScreen].scale + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    border.frame = CGRectMake(0, -pixelAdjustOffset, viewWidth, borderWidth);
    [self.layer addSublayer:border];
}

- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    border.name=@"border";
    [self.layer addSublayer:border];
}
- (void)addBottomBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth andViewWidth:(CGFloat)viewWidth{
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    
    border.frame = CGRectMake(0, self.frame.size.height - borderWidth, viewWidth, borderWidth);
    border.name=@"border";
    [self.layer addSublayer:border];
}
- (void)addLeftBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}

- (void)addRightBorderWithColor:(UIColor *)color andWidth:(CGFloat) borderWidth {
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    
    border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
    [self.layer addSublayer:border];
}
@end
