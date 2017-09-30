//
//  ZZCommentCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterCommentModel.h"

@protocol ZZChapterCommentCellDelegate <NSObject>

-(void)onCommentCellClick:(id)obj;

@end

@interface ZZCommentCell : UITableViewCell

@property(nonatomic,strong)id<ZZChapterCommentCellDelegate> delegate;
@property(nonatomic,strong) ZZChapterCommentModel *tempModel;

@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labText;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UIView *viewsReply;

@property (weak, nonatomic) IBOutlet UIButton *btnComment;


-(void)dataToView:(ZZChapterCommentModel *) model;;

@end
