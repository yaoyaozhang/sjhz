//
//  ZZSymptomDetailCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/10.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZCaseDetailBaseCell.h"

@interface ZZSymptomDetailCell : ZZCaseDetailBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView2;

@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UIView *viewWts;

@end
