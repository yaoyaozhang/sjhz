//
//  ZZChannelCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterTVC.h"
#import "ZZChannelModel.h"

@interface ZZChannelCell : UICollectionViewCell

@property (nonatomic, strong) ZZChapterTVC *newsTVC;
@property (nonatomic, copy  ) NSString  *urlString;

@end
