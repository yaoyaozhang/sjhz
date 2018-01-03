//
//  ZZSymptomCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomCell.h"

@implementation ZZSymptomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_nameLabel setNumberOfLines:0];
    [_nameLabel setFont:ListTitleFont];
    [_nameLabel setTextColor:UIColorFromRGB(TextDarkColor)];
    
    
    [self zzSymptomView];
}

- (ZZSymptomView *)zzSymptomView
{
    if (!_symptomView) {
        _symptomView = [[ZZSymptomView alloc] initZZSymptomView];
        
        [self.contentView addSubview:_symptomView];
    }
    return _symptomView;
}


-(void)dataToView:(NSString *)title data:(NSMutableArray *)arr{
    CGFloat y = 10;
    if(convertToString(title).length == 0){
        _nameLabel.hidden = NO;
    }else{
        [_nameLabel setText:convertToString(title)];
        
        [self autoWidthOfLabel:_nameLabel with:ScreenWidth-20];
        CGRect tf = _nameLabel.frame;
        y = y + tf.size.height + 10;
    }
    
    [_symptomView setItemValues:arr block:^(ZCSymptomAction action, NSString *text, id obj) {
        
    }];
    
    CGRect sf = _symptomView.frame;
    sf.origin.y = y;
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + sf.size.height + 10)];
    
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
