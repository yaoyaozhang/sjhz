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

-(void)dataToItem:(ZZChapterModel *)model{
    [_imgFaceBackground sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    [_labAuthor setText:convertToString(model.author)];
    [_labTime setText:model.createTime];
    [_labTitle setText:model.title];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
