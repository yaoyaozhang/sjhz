//
//  ZZVoiceTools.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/24.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZChapterModel.h"

@interface ZZVoiceTools : UIView

/**
 *  必须在selectIndex之前设置
 */
@property (nonatomic, strong) ZZChapterModel *model;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) int curIndex;


+(instancetype)shareVoiceTools;

@property (nonatomic, strong)  void(^onDissmisBlock) ();
@property (nonatomic,strong)  UIViewController *viewController;


/**
 显示沈阳

 @param type 1 简单模式，2全屏模式
 @param f1 简单的坐标
 @param f2 全屏坐标
 */
- (void)show:(int ) type sFrame:(CGRect )f1 fullFrame:(CGRect) f2;

- (void)show:(int) type;

- (void)stopPlayer;

- (void)hideAllView;

@end
