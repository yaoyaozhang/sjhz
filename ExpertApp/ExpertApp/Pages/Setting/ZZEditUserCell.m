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
    _imgInto.hidden =  YES;
    _labelName.text = dict[@"text"];
    
    
    if(code == 1){
        _imgAvatar.hidden = NO;
        _btnBD.hidden  = YES;
        _labelDesc.hidden = YES;
        tf.origin.y = (80-44)/2;
        _labelName.frame = tf;
        
        if(![loginUser.imageUrl hasPrefix:@"http"]){
            [_imgAvatar setImage:[UIImage imageWithContentsOfFile:loginUser.imageUrl]];
        }else{
            [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:loginUser.imageUrl]];
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
    
    if(code > 3){
        _imgAvatar.hidden = YES;
        _labelDesc.hidden = YES;
        _btnBD.hidden  = YES;
        _imgInto.hidden = NO;
        
        tf.origin.y = 0;
        _labelName.frame = tf;
        
      
        
        _labelDesc.text = loginUser.phone;
        
        
        if(code == 7){
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_labelName.text];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(BgTitleColor) range:NSMakeRange(_labelName.text.length - loginUser.invtCode.length  - 2 ,loginUser.invtCode.length + 2)];
            _labelName.attributedText = str;
        }
        
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
