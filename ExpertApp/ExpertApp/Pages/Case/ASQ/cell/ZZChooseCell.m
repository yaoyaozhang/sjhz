//
//  ZZChooseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChooseCell.h"

@implementation ZZChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    CGRect topF = self.labTitle.frame;
    CGFloat y =  topF.origin.y + topF.size.height + 10;
    
    
    [_chooseViews setFrame:CGRectMake(15, y,ScreenWidth, 0)];
//    int type = [item[@"cid"] intValue];
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + 28 +15)];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
