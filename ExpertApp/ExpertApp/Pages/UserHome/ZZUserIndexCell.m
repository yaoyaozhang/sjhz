//
//  ZZUserIndexCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZUserIndexCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZUserIndexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = 25.0f;
    _imgAvatar.layer.borderWidth = 1.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    
    _imgFace.layer.borderWidth = 1.0f;
    _imgFace.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    
    [_labName setFont:ListTitleFont];
    [_labName setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_labKes setFont:ListDetailFont];
    [_labKes setTextColor:UIColorFromRGB(TextSizeSixColor)];
    
    [_labHospital setFont:ListDetailFont];
    [_labHospital setTextColor:UIColorFromRGB(TextSizeSixColor)];
    
    [_labTime setFont:ListDetailFont];
    [_labTime setTextColor:UIColorFromRGB(TextSizeSixColor)];
    
    
    [_labChapter setFont:ListDetailFont];
    [_labChapter setTextColor:UIColorFromRGB(TextSizeThreeColor)];
    
    
    [_btnSend setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [_btnSend.titleLabel setFont:ListTimeFont];
    [_btnSend setTitleColor:UIColorFromRGB(TextSizeSixColor) forState:UIControlStateNormal];
    
    [_btnCollect setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [_btnCollect.titleLabel setFont:ListTimeFont];
    [_btnCollect setTitleColor:UIColorFromRGB(TextSizeSixColor) forState:UIControlStateNormal];
    
    [_btnComment setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [_btnComment.titleLabel setFont:ListTimeFont];
    [_btnComment setTitleColor:UIColorFromRGB(TextSizeSixColor) forState:UIControlStateNormal];
}

-(void)dataToCellView:(ZZUserHomeModel *)model{
    if(model){
        _tempModel = model;
        
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(model.imageUrl)]];
        [_labName setText:convertToString(model.docName)];
        [_labKes setText:convertToString(model.departmentName)];
        [_labHospital setText:convertToString(model.hospital)];
        [_labChapter setText:convertToString(model.title)];
        [_labTime setText:convertToString(model.createTime)];
        
        [_imgFace sd_setImageWithURL:[NSURL URLWithString:convertToString(model.picture)]];
        
        
        [_btnComment setTitle:convertIntToString(model.chickedNum) forState:UIControlStateNormal];
        [_btnCollect setTitle:convertIntToString(model.chickLikeNum) forState:UIControlStateNormal];
    }
}

-(IBAction)buttonClick:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onUserIndexCellClick:model:)]){
        [self.delegate onUserIndexCellClick:btn.tag model:self.tempModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
