//
//  ZZCaseDetailBaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseDetailBaseCell.h"

@implementation ZZCaseDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)dataToView:(NSDictionary *) item
{
    self.tempDict = item;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
