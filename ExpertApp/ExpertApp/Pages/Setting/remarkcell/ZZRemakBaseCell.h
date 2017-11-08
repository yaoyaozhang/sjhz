//
//  ZZRemakBaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZRemarkCellDelegate

// 1 表签（文本） 2病例（NSDictionary） 3 备注
-(void)onCellClick:(id) obj type:(int) type;

@end

@interface ZZRemakBaseCell : UITableViewCell

@property(nonatomic,strong) id<ZZRemarkCellDelegate> delegate;

@property (strong, nonatomic) UILabel *labTitle;

@property(nonatomic,strong) ZZUserInfo *user;

-(void)dataToView:(NSDictionary *) item;

@end
