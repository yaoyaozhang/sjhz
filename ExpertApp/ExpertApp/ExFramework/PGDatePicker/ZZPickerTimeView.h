//
//  ZZPickerTimeView.h
//  deerkids
//
//  Created by zhangxy on 2017/11/3.
//  Copyright © 2017年 wangzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZPickerTimeView : UIView

/**
 *  创建对象方法
 */
- (instancetype)initWithShareType:(void (^)(NSString *resultTime))resultBlock;

- (void)show;

@end
