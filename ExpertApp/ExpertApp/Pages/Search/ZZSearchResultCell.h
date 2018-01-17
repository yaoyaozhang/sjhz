//
//  ZZSearchResultCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/15.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LemmaModel.h"


FOUNDATION_EXPORT NSString *const kZCCollectionViewCellID;

@interface ZZSearchResultCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *labTitle; //标题
@property (strong, nonatomic) UILabel *labDesc; // 要素内容

@property (strong, nonatomic) UIButton * btnSend;
@property (strong, nonatomic) UILabel * labLook;

- (void)configureCellWithPostURL:(LemmaModel *)model;

@end
