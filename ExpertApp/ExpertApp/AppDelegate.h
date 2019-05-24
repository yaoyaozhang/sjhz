//
//  AppDelegate.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (assign, nonatomic) BOOL allowRotation;
@property (strong, nonatomic) UIWindow *window;

-(void)openNewPage:(NSString *) action;

-(UIViewController *)getCurVC;
@end

