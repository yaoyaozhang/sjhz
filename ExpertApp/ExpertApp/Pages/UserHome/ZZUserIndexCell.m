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
        
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(model.docInfo.imageUrl)]];
        [_labName setText:convertToString(model.docInfo.docName)];
        CGRect f  = _labName.frame;
        CGSize s = [self autoWidthOfLabel:_labName with:f.size.height];
        CGRect ksF = _labKes.frame;
        ksF.origin.x = f.origin.x + s.width + 5;
        _labKes.frame = ksF;
        
        [_labKes setText:convertToString(model.docInfo.departmentName)];
        [_labHospital setText:convertToString(model.docInfo.hospital)];
        
        
            [_labChapter setText:convertToString(model.chpater.title)];
            [_labTime setText:intervalSinceNow(model.chpater.createTime)];
        
        [_imgFace sd_setImageWithURL:[NSURL URLWithString:convertToString(model.chpater.picture)]];
        
        self.imgVideoOrMp3.hidden = NO;
        if(model.chpater.showVideo == 1){
            [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_sound"]];
        }else if(model.chpater.showVideo == 2){
            [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_video"]];
        }else{
            self.imgVideoOrMp3.hidden = YES;
        }
        
        if(model.chpater.commentNum>0){
            [_btnComment setTitle:convertIntToString(model.chpater.commentNum) forState:UIControlStateNormal];
        }
        if(model.chpater.collect){
            [self.btnCollect setImage:[UIImage imageNamed:@"btn_alreadycollected"] forState:UIControlStateNormal];
        }else{
            [self.btnCollect setImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
        }

    }
}

-(IBAction)buttonClick:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onUserIndexCellClick:model:)]){
        [self.delegate onUserIndexCellClick:btn.tag model:self.tempModel];
    }
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )height{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX,height);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
