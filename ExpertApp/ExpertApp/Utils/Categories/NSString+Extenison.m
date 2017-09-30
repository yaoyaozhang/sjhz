//
//  NSString+Extenison.m
//  CustomAlertViewDemo
//
//  Created by lizhihui on 15/11/9.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import "NSString+Extenison.h"

@implementation NSString (Extenison)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = font;
        CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(maxW, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
    
}
@end
