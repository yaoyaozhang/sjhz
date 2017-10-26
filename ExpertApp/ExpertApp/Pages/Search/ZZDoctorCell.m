//
//  ZZDoctorCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorCell.h"

@implementation ZZDoctorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labelName setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labelNameZhiWei setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labelHosptial setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    [_labelSC setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelNameZhiWei setTextAlignment:NSTextAlignmentLeft];
    [_labelHosptial setTextAlignment:NSTextAlignmentLeft];
    [_labelSC setTextAlignment:NSTextAlignmentLeft];
    
    [_labelName setFont:ListTitleFont];
    [_labelNameZhiWei setFont:ListDetailFont];
    [_labelHosptial setFont:ListDetailFont];
    [_labelSC setFont:ListDetailFont];
    
    [_viewLabels setBackgroundColor:[UIColor clearColor]];
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = 40.0f;
    _imgAvatar.layer.borderWidth = 1.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    [_viewLabels setBackgroundColor:[UIColor clearColor]];
    
    
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
    [_viewLabels.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(_cellType == 0){
        _btnControl.hidden = YES;
    }else{
        _btnControl.hidden = NO;
        if(_cellType == ZZDoctorCellTypeDel){
            [_btnControl setImage:[UIImage imageNamed:@"choosecase_delete"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"choosecase_delete"] forState:UIControlStateSelected];
        }
        if(_cellType == ZZDoctorCellTypeStar){
            [_btnControl setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"increased"] forState:UIControlStateSelected];
        }
        if(_cellType == ZZDoctorCellTypeCheck){
            [_btnControl setImage:[UIImage imageNamed:@"btn_cannotselected"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
        }
        
    }
    
    if(model){
        _tempModel = model;
        
        [_labelName setText:model.userName];
        CGSize ns = [self autoWidthOfLabel:_labelName with:22];
        CGRect f = _labelNameZhiWei.frame;
        f.origin.x = _labelName.frame.origin.x + ns.width + 10;
        f.size.width = ScreenWidth - f.origin.x - 15;
        [_labelNameZhiWei setFrame:f];
        
        [_labelNameZhiWei setText:model.departmentName];
        [_labelHosptial setText:model.hospital];
        
        if(_cellType == ZZDoctorCellTypeStar){
            
            if(model.state >= 1){
                _btnControl.selected = YES;
            }else{
                _btnControl.selected = NO;
            }
        }
        if(_cellType == ZZDoctorCellTypeCheck){
            if(model.isChecked == 1){
                _btnControl.selected = YES;
            }else{
                _btnControl.selected = NO;
            }
        }
        
        
        
                
        if(model.accomplished){
            [_labelSC setText:[NSString stringWithFormat:@"擅长:%@",model.accomplished]];
        }else{
            [_labelSC setText:[NSString stringWithFormat:@"擅长:--"]];
        }
        if(model.titleName){
            _viewLabels.hidden = NO;
            NSArray *arr = [model.titleName componentsSeparatedByString:@","];
            CGFloat xx = 0;
            for(NSString *itemText in arr){
                xx = [self createLabel:itemText x:xx];
            }
        }else{
            _viewLabels.hidden = YES;
        }
    }
}

-(CGFloat )createLabel:(NSString *) text x:(CGFloat) xx{
    UILabel  *lab = [[UILabel alloc] initWithFrame:CGRectMake(xx, 0, 0, 15)];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius  = 2.0f;
    [lab setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [lab setTextColor:UIColorFromRGB(TextWhiteColor)];
    [lab setFont:ListElevenFont];
    [lab setText:text];
    
    CGSize s = [self autoWidthOfLabel:lab with:15];
    [lab setFrame:CGRectMake(xx, 0, s.width + 10, 15)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [_viewLabels addSubview:lab];
    
    return xx + s.width + 15;
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
