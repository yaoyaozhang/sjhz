//
//  ZZOperaterView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/5/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,ZZOperaterType) {
    ZZOperaterTypeCollect     = 1, // 收藏
    ZZOperaterTypeShare  = 2,      // 分享
    ZZOperaterTypeComment = 3,     // 评论
};



@interface ZZOperaterView : UIView

/**
 *  必须在selectIndex之前设置
 */
@property (nonatomic, strong) id operatorModel;

/**
 *  创建对象方法
 */
- (instancetype)initWithShareType:(UIViewController *) vc;

- (void)show;

@end
