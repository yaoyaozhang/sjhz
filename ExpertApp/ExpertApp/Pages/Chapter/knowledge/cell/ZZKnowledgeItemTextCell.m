//
//  ZZKnowledgeItemTextCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeItemTextCell.h"

@implementation ZZKnowledgeItemTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imgIcon setBackgroundColor:UIColor.clearColor];
    [_imgIcon setContentMode:UIViewContentModeCenter];
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_labTitle setFont:ListTitleFont];
    [_labTime setFont:ListDetailFont];
    
    [_labTitle setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labTime setTextColor:UIColorFromRGB(TextLightDarkColor)];
}

-(void)dataToView:(ZZChapterModel *)item{
    if(item!=nil){
        [_imgIcon setImage:[UIImage imageNamed:@"icon_list_video"]];
        [_labTitle setText:item.title];
        [_labTime setText:[NSString stringWithFormat:@"%@ %d",item.createTime,item.nid]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
