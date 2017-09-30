//
//  UIColor+HexColor.m
//  ExpertSDK
//
//  Created by 张新耀 on 15/8/11.
//  Copyright (c) 2015年 Expert. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor(HexColor)

+ (UIColor *)getColor:(NSString *)hexColor
{
    if(hexColor!=nil && hexColor.length>6){
        hexColor=[hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

@end
