//
//  ZZEditUserCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZEditUserCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZEditUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgAvatar.layer.cornerRadius = 25.0f;
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.borderWidth = 2.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    
    
    [_btnBD addTarget:self action:@selector(editBound:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initToDictView:(NSDictionary *)dict info:(ZZUserInfo *) loginUser{
    int code = [dict[@"code"] intValue];
    CGRect tf = _labelName.frame;
    _labelName.text = dict[@"text"];
    if(code == 1){
        _imgAvatar.hidden = NO;
        _btnBD.hidden  = YES;
        _labelDesc.hidden = YES;
        tf.origin.y = (80-44)/2;
        _labelName.frame = tf;
        
        if(![loginUser.userImageUrl hasPrefix:@"http"]){
            [_imgAvatar setImage:[UIImage imageWithContentsOfFile:loginUser.userImageUrl]];
        }else{
            [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:loginUser.userImageUrl]];
        }
    }
    if(code == 2){
        _imgAvatar.hidden = YES;
        _btnBD.hidden  = YES;
        _labelDesc.hidden = NO;
        tf.origin.y = 0;
        _labelName.frame = tf;
        _labelDesc.text = loginUser.name;
        [_labelDesc setTextColor:UIColorFromRGB(TextSizeNineColor)];
    }
    
    if(code == 3){
        _imgAvatar.hidden = YES;
        _labelDesc.hidden = NO;
        _btnBD.hidden  = YES;
        
        tf.origin.y = 0;
        _labelName.frame = tf;
        
        _labelDesc.text = loginUser.phone;
        
        if([@"" isEqual:convertToString(loginUser.phone)]){
            _btnBD.hidden  = NO;
            _labelDesc.hidden = YES;
        }
        
    }
}

-(void)editBound:(UIButton *) sender{
    if(_delegate && [_delegate respondsToSelector:@selector(onEditCellClick:)]){
        [_delegate onEditCellClick:@"bound"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
