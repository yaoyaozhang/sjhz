//
//  ZZQSListCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/15.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZQSListCell.h"

@implementation ZZQSListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_labTitle setTextAlignment:NSTextAlignmentLeft];
    [_labTitle setFont:ListTitleFont];
    [_labTitle setTextColor:UIColorFromRGB(BgTitleColor)];
    [_labTitle setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
