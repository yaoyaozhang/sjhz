//
//  ZZBaseAlertView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/16.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZZAlertViewBlock)(NSInteger buttonTag,NSString *text);

@interface ZZBaseAlertView : UIView

@property (nonatomic, copy) ZZAlertViewBlock block;
@property (nonatomic, copy) UIView *subContentView;

- (instancetype)initWithTitle:(NSString *) title message:(NSString *) message cancel:(NSString *) cancel comfirm:(NSString *) text;


-(void)layoutConentView;


- (void)show;

- (void)dismiss;


@end
