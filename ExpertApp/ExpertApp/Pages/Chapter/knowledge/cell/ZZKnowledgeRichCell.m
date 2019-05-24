//
//  ZZKnowledgeRichCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeRichCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZKnowledgeRichCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_labTime setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labTitle setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labAuthor setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labAuthor setFont:ListDetailFont];
    [_labTitle setFont:ListTitleFont];
    [_labTime setFont:ListDetailFont];
    [_lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
}

-(void)dataToItem:(ZZKnowledgeTopicModel *)model{
    [_imgFaceBackground sd_setImageWithURL:[NSURL URLWithString:model.classUrl]];
    [_labAuthor setText:convertToString(model.adaptUser)];
    [_labTime setText:dateTransformDateString(FormateTime, model.startTime)];
    [_labTitle setText:model.className];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
