//
//  UIButton+Extension.m
//  ExpertApp
//
//  Created by 张新耀 on 15/10/12.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import "UIButton+Extension.h"

#import <objc/runtime.h>


@implementation UIButton(Extension)


-(id)objectValue{
    
    return objc_getAssociatedObject(self, @selector(objectValue));
}

-(void)setObjectValue:(id)objectValue{
    objc_setAssociatedObject(self, @selector(objectValue), objectValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
