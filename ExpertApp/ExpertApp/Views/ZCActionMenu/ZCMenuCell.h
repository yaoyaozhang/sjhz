//
//  ZCMenuCell.h
//  ExpertApp
//
//  Created by zhangxy on 16/5/18.
//  Copyright © 2016年 com.Expert.chat.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCMenuItem.h"

#define ItemHeight 40.0f

@interface ZCMenuCell : UITableViewCell

// 显示时间
@property (nonatomic,strong) UILabel                 *titleLabel;

// 头像
@property (nonatomic,strong) UIImageView             *iconView;


-(void) InitDataToView:(ZCMenuItem *) item;

@end
