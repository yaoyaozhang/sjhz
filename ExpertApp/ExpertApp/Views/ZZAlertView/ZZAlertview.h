//
//  ZCAlertview.h
//  ExpertApp
//
//  Created by lizhihui on 15/10/9.
//  Copyright (c) 2015年 com.Expert.chat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZCAlertviewDelegate <NSObject>
@optional // 可选择性实现的方法
- (void)pushloginVC;

@end
@interface ZZAlertview : UIView
@property (nonatomic,strong) UIButton *cancelbtn;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIImageView *lineimage;
@property (nonatomic,strong) UIImageView *lineimageview;
@property (nonatomic,strong) UILabel *messagelable;

- (void) setActionClickBlock:(void (^)(NSInteger tag)) ItemClickblock;

- (instancetype)initWithTitle:(NSString *) title cancel:(NSString *) cancel comfirm:(NSString *) text;


- (void)show;




@end
