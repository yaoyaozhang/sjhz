//
//  ZZChapterCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterModel.h"

typedef NS_ENUM(NSInteger,ZZChapterCellClickTag) {
    ZZChapterCellClickTagSend    = 1,
    ZZChapterCellClickTagComment = 2,
    ZZChapterCellClickTagCollect = 3
};

@interface ZZChapterCell : UITableViewCell



@property (nonatomic, strong) ZZChapterModel *chapterModel;
/** 轮播点击事件 */
@property (nonatomic, copy) void(^cycleImageClickBlock)(NSInteger idx);


@property (nonatomic, copy) void(^onItemClickBlock)(ZZChapterCellClickTag tag);


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


+ (NSString *)cellReuseID:(ZZChapterModel *)newsModel;
+ (CGFloat)cellForHeight:(ZZChapterModel *)newsModel;


@end
