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
    
    [_ageLabel setFont:ListTitleFont];
    [_ageLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_caseLabel setFont:ListTitleFont];
    [_caseLabel setTextColor:UIColorFromRGB(TextBlackColor)];
}



-(void)dataToView:(NSDictionary *)item{
    if(item){
        
        [_nameLabel setText:convertToString(item[@"caseName"])];
        [_ageLabel setText:[NSString stringWithFormat:@"%@岁%@",convertToString(item[@"age"]),[item[@"sex"] intValue]==1?@"男":@"女"]];
        if([item[@"type"] intValue] == 2){
            [_caseLabel setText:@"运动康复病例"];
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
