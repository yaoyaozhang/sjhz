//
//  ZZCreateCaseBaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCreateCaseBaseCell.h"

@implementation ZZCreateCaseBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)dataToView:(NSDictionary *)item{
    self.tempDict = item;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
