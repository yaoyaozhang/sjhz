//
//  ZZAddPicCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/8.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZCreateCaseBaseCell.h"
#import "UIButtonUpDown.h"

@interface ZZAddPicCell : ZZCreateCaseBaseCell

@property (assign, nonatomic) BOOL isDetail;

@property (weak, nonatomic) IBOutlet UIImageView *imgRequired;
@property (weak, nonatomic) IBOutlet UILabel *labTagName;
@property (weak, nonatomic) IBOutlet UIScrollView *addScrollView;

@end
