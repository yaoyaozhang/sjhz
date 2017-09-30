//
//  ZCLibUncaughtExceptionHandler.h
//  ExpertKit
//
//  Created by zhangxy on 2017/2/28.
//  Copyright © 2017年 zhichi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCLibUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;


+(void) expressUncaughtExceptionHandler:(NSException *)exception;

@end
