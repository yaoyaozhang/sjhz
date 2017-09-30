//
//  ZCActionMenu.h
//  ExpertApp
//
//  Created by zhangxy on 16/5/18.
//  Copyright © 2016年 com.Expert.chat.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMenuItem.h"


@protocol ZCActionMenuDelegate <NSObject>

-(void) onActionMenuItem:(ZCMenuItem *) item;

@end

@interface ZCActionMenu : UIView

/**
 *  代理
 */
@property (nonatomic, weak  ) id <ZCActionMenuDelegate> delegate;
@property (nonatomic, assign) int                       selectIndex;


/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<ZCActionMenuDelegate>)delegate arr:(NSArray *) array;

- (void) setActionClickBlock:(void (^)(ZCMenuItem *item)) ItemClickblock;

- (void)show;

- (void)dissmisMenu;

- (BOOL) isShowing;

@end
