//
//  ZZCaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseCell.h"

@implementation ZZCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_delBtn addTarget:self action:@selector(delButton:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseBtn addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_chooseBtn setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [_chooseBtn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    
    [_nameLabel setFont:ListTitleFont];
    [_nameLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_ageLabel setFont:ListDetailFont];
    [_ageLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_caseLabel setFont:ListDetailFont];
    [_caseLabel setTextColor:UIColorFromRGB(TextBlackColor)];
}



-(void)dataToView:(NSDictionary *)item{
    if(item){
        
        [_nameLabel setText:convertToString(item[@"caseName"])];
        [_ageLabel setText:[NSString stringWithFormat:@"%@岁%@",convertToString(item[@"age"]),[item[@"sex"] intValue]==1?@"男":@"女"]];
        if([item[@"type"] intValue] == 2){
            [_caseLabel setText:@"运动治疗技术病例"];
        }else{
            [_caseLabel setText:@"普通病例"];
        }
        
        if(_isChecked){
            _chooseBtn.selected = YES;
        }else{
            _chooseBtn.selected = NO;
        }
        
        
//        "caseId": 1,
//        "age": 18,
//        "caseName": "康复病例1",
//        "createTime": "2017-09-18 18:16:49",
//        "type": "2"
    }
}


-(void)patientToView:(ZZPatientModel *) model{
    if(model){
        
        [_nameLabel setText:convertToString(model.name)];
        [_ageLabel setText:[NSString stringWithFormat:@"%@ %@",model.sexName,model.birth]];
        [_caseLabel setText:@""];
        _caseLabel.hidden = YES;
        
        [self autoWidthOfLabel:_nameLabel with:21];
        CGRect nf = _nameLabel.frame;
        CGRect af = _ageLabel.frame;
        af.origin.x = nf.origin.x + nf.size.width + 5;
        _ageLabel.frame = af;
        
        if(_isChecked){
            _chooseBtn.selected = YES;
        }else{
            _chooseBtn.selected = NO;
        }
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
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, height);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}

-(void)delButton:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCaseCellItemOnClick:index:)]){
        [self.delegate onCaseCellItemOnClick:2 index:_curIndexPath];
    }
}

-(void)chooseButton:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCaseCellItemOnClick:index:)]){
        [self.delegate onCaseCellItemOnClick:1 index:_curIndexPath];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
