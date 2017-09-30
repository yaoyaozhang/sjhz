//
//  ZZChapterUserCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterModel.h"
typedef NS_ENUM(NSInteger,ZZChapterCellClickTag) {
    ZZChapterCellClickTagSend    = 1,
    ZZChapterCellClickTagComment = 2,
    ZZChapterCellClickTagCollect = 3
};

@interface ZZChapterUserCell : UITableViewCell


@property (nonatomic, strong) ZZChapterModel *chapterModel;


@property (nonatomic, copy) void(^onItemClickBlock)(ZZChapterCellClickTag tag);


/** 左图右字的单个图片，三图中的第一个图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


// 摘要
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end
