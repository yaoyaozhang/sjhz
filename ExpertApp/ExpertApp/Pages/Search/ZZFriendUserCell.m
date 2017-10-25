//
//  ZZFriendUserCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZFriendUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation ZZFriendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labelName setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labelHosptial setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelHosptial setTextAlignment:NSTextAlignmentLeft];
    
    [_labelName setFont:ListTitleFont];
    [_labelHosptial setFont:ListDetailFont];
    
    
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = 30.0f;
    _imgAvatar.layer.borderWidth = 1.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    
    [_btnControl.titleLabel setFont:ListDetailFont];
    [_btnControl setBackgroundColor:[UIColor clearColor]];
    [_btnControl addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)itemOnClick:(UIButton *) sender{
    if(_tempModel){
        if(self.delegate && [self.delegate respondsToSelector:@selector(onDoctorCellClick:model:)]){
            [self.delegate onDoctorCellClick:_cellType model:_tempModel];
        }
    }
}

-(void)dataToView:(ZZUserInfo *)model{
   
    
    
    if(model){
        _tempModel = model;
        
        _btnControl.hidden = NO;
        int status = model.state;
        CGRect bf = _btnControl.frame;
        if(status == 1){
            
            [_btnControl setTitle:@"接受" forState:UIControlStateNormal];
            [_btnControl setImage:nil forState:UIControlStateNormal];
            [_btnControl setImage:nil forState:UIControlStateSelected];
            [_btnControl setBackgroundColor:[UIColor whiteColor]];
            _btnControl.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
            _btnControl.layer.borderWidth = 1.0f;
            _btnControl.layer.cornerRadius = 4.0f;
            _btnControl.layer.masksToBounds = YES;
            bf.size.height = 26.0f;
            bf.origin.y = (90-26)/2;
            [_btnControl setFrame:bf];
        }
        
        
        if(status == 2){
            _btnControl.layer.borderColor = [UIColor clearColor].CGColor;
            [_btnControl setTitle:@"已关注" forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_havefollow"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_havefollow"] forState:UIControlStateSelected];
            bf.size.height = 50.0f;
            bf.origin.y = (90-50)/2;
            [_btnControl setFrame:bf];
        }
        
        if(status == 3){
            _btnControl.layer.borderColor = [UIColor clearColor].CGColor;
            [_btnControl setTitle:@"互相关注" forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_mutualfollow"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_mutualfollow"] forState:UIControlStateSelected];
            bf.size.height = 50.0f;
            bf.origin.y = (90-50)/2;
            [_btnControl setFrame:bf];
        }
        
        _tempModel = model;
        
        [_labelName setText:model.userName];
        if([[ZZDataCache getInstance] getLoginUser].isDoctor){
            [_labelHosptial setText:model.context];
        }else{
            [_labelHosptial setText:convertToString(model.hospital)];
        }
        
        
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(model.imageUrl)]];
        
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
