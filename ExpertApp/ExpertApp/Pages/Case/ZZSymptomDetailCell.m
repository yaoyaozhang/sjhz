//
//  ZZSymptomDetailCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/10.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomDetailCell.h"
#import "ZZSymptomModel.h"

@implementation ZZSymptomDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_bgView setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    // Initialization code
    [_labName setFont:ListDetailFont];
    [_labName setTextColor:UIColorFromRGB(TextDarkColor)];
    [_viewWts setBackgroundColor:UIColor.clearColor];
}


-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    [_labName setText:item[@"placeholder"]];
    CGSize ns = [self autoHeightOfLabel:_labName with:ScreenWidth - 20];
    if(ns.height > 21){
        [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, 9 + ns.height + 9)];
    }
    [_viewWts setFrame:CGRectMake(10, _bgView.frame.size.height + 10, ScreenWidth - 20, 0)];
    [_viewWts.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *arr = item[@"dictValue"];
    
    
    CGFloat y = 0;
    if(!is_null(arr) && arr.count>0){
        for (ZZSymptomWTModel *model in arr) {
            UILabel *labQ = [self crateItemWith];
            UILabel *labV = [self crateItemWith];
            [labQ setText:convertToString(model.quesName)];
            [labQ setTextColor:UIColorFromRGB(TextDarkColor)];
            [labV setText:convertToString(model.answer)];
//            if(convertToString(model.answer).length == 0 ){
//                [labV setText:convertToString(model.quesOptions)];
//            }
            [labV setTextColor:UIColorFromRGB(TextLightDarkColor)];
            
            CGRect f1 = CGRectMake(0, y, _viewWts.frame.size.width,0);
            labQ.frame = f1;
            CGSize s = [self autoHeightOfLabel:labQ with:f1.size.width];
            
            
            CGRect f2 = CGRectMake(0, y + s.height + 5, _viewWts.frame.size.width,0);
            labV.frame = f2;
            CGSize s2 = [self autoHeightOfLabel:labV with:f1.size.width];
            
            y = y + s.height + 5 + s2.height + 5;
        }
        CGRect f = _viewWts.frame;
        f.size.height = y;
        [_viewWts setFrame:f];
    }
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, _viewWts.frame.size.height + _viewWts.frame.origin.y + 10)];
}


-(UILabel *)crateItemWith{
    UILabel *tempLabel = ({
        UILabel *lab = [UILabel new];
        [lab setTextColor:UIColorFromRGB(TextDarkColor)];
        [lab setFont:ListDetailFont];
        lab.numberOfLines = 0;
        [lab setTextAlignment:NSTextAlignmentLeft];
        lab;
    });
    [_viewWts addSubview:tempLabel];
    return tempLabel;
}



/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width{
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
