//
//  UIView+Extension.h
//  ExpertApp
//
//  Created by 张新耀 on 15/9/1.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/** UIView的最大X值 */
@property (assign, nonatomic) CGFloat maxX;
/** UIView的最大Y值 */
@property (assign, nonatomic) CGFloat maxY;


/**
 *  创建UITableView
 *
 *  @param delegate table代理   不能为nil
 *
 *  @return UITableView
 */
-(UITableView *)createTableView:(id) delegate;

/**
 *  创建UITableView
 *
 *  @param delegate       table代理   不能为nil
 *  @param cellIdentifier xib名称，用于注册cell，如SettingCell.xib，传入SettingCell
 *
 *  @return UITableView
 */
-(UITableView *)createTableView:(id) delegate cell:(NSString *)cellIdentifier;

/**
 *  创建UITableView
 *
 *  @param delegate       table代理
 *  @param cellIdentifier xib名称，用于注册cell，如SettingCell.xib，传入SettingCell
 *  @param y              table的起始Y
 *  @param height         table的高度
 *
 *  @return UITableView
 */
-(UITableView *)createTableView:(id) delegate cell:(NSString *)cellIdentifier formY:(CGFloat) y withHeight:(CGFloat) height;

@end
