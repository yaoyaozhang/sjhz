//
//  CommonToolsDefine.h
//  ExpertApp
//
//  Created by 张新耀 on 15/8/25.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import <UIKit/UIKit.h>
// 理想线宽
#define LINE_WIDTH                  1
// 实际应该显示的线宽
#define SINGLE_LINE_WIDTH           floor((LINE_WIDTH / [UIScreen mainScreen].scale)*100) / 100

//偏移的宽度
#define SINGLE_LINE_ADJUST_OFFSET   floor(((LINE_WIDTH / [UIScreen mainScreen].scale) / 2)*100) / 100


// UTF8 字符串
#define UTF8Data(str) [str dataUsingEncoding:NSUTF8StringEncoding]


// 常用属性
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define iOS7                                ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)? NO:YES)
#define NS_Bundle                           [NSBundle mainBundle]

#define IntToString(x)                      [NSString stringWithFormat:@"%d",x]
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER                 [NSNotificationCenter defaultCenter]

// iPhoneX
#define ZC_iPhoneX (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)


#define NavBarHeight                        (ZC_iPhoneX ? 88.f : (iOS7 ? 64.0 : 44.0))//(iOS7 ? 64.0 : 44.0)

#define StatusBarHeight                     (ZC_iPhoneX ? 44.0 : (iOS7 ? 20.0 : 0.0))//(iOS7 ? 20.0 : 0.0)

#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define ScreenScale                          (ScreenWidth / 320.f)
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define TabBarHeight                        49.0f


// 格式化字符串
#define FormatString(string, args...)       [NSString stringWithFormat:string, args]



// 多语言支持
// #define ZCLocalString(key) NSLocalizedStringFromTable(key, @"ZCAppLocalizable", nil)
