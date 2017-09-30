//
//  ZCTextPlaceholderView.m
//  ExpertApp
//
//  Created by lizhihui on 2016/11/22.
//  Copyright © 2016年 com.Expert.chat.app. All rights reserved.
//

#import "ZCTextPlaceholderView.h"

@implementation ZCTextPlaceholderView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
    }
}



- (void)textDidChange{
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text{
    // 设置属性一定要重写父类的方法
    [super setText:text];
    // setNeedsDisplay会在下一个消息循环时刻（RunLoop），调用drawRect:
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
}


/**
 *  重绘
 *
 */
- (void)drawRect:(CGRect)rect{
    
    if (self.hasText) return;
    
    // 配置文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor : [UIColor grayColor];
    
    
    //设置占位文字的边界
    CGFloat x = 2;
    CGFloat y = 8;
    CGFloat w = rect.size.width - x*2;
    CGFloat h = rect.size.height - y*2;
    CGRect placehodelCgrect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placehodelCgrect withAttributes:attrs];
}


- (void)dealloc{
    // 销毁
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
