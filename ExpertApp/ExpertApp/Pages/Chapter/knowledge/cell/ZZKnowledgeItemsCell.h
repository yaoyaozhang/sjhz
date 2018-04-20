//
//  ZZKnowledgeItemsCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTJListModel.h"

@protocol ZZKnowledgeItemsCellDelegate<NSObject>

// type 1 播放, 2查看更多
-(void)onItemClick:(id) model type:(int ) type;

@end

@interface ZZKnowledgeItemsCell : UITableViewCell

@property (strong, nonatomic) id<ZZKnowledgeItemsCellDelegate> delegate;

@property (strong, nonatomic) ZZTJListModel *tempModel;


@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labAuthor;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

@property (weak, nonatomic) IBOutlet UIView *viewsItem;


-(void)dataToItem:(ZZTJListModel *) model;

@end
