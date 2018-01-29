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
    [_bgView2 setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    // Initialization code
    [_labName setFont:ListDetailFont];
    [_labName setTextColor:UIColorFromRGB(TextDarkColor)];
    [_labTitle setFont:ListDetailFont];
    [_labTitle setTextColor:UIColorFromRGB(TextDarkColor)];
    _labTitle.numberOfLines = 0;
    [_viewWts setBackgroundColor:UIColor.clearColor];
    _viewWts.layer.cornerRadius = 3.0f;
    _viewWts.layer.masksToBounds = YES;
    _bgView2.layer.cornerRadius = 3.0f;
    _bgView2.layer.masksToBounds = YES;
}


-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    [_labName setText:@"患者症状"];
    
    
    [_labTitle setText:item[@"placeholder"]];
    [_labTitle setFrame:CGRectMake(20, 55, ScreenWidth-40, 0)];
    CGSize ns = [self autoHeightOfLabel:_labTitle with:ScreenWidth - 40];
    
    [_labTitle setFrame:CGRectMake(20, 55, ScreenWidth-40, ns.height)];
    [_bgView2 setFrame:CGRectMake(10, 50 , ScreenWidth - 20, ns.height + 10)];
    
    [_viewWts setFrame:CGRectMake(10, 50 + ns.height + 15, ScreenWidth - 20, 0)];
    [_viewWts setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [_viewWts.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *arr = item[@"dictValue"];
    
    
    CGFloat y = 5;
    if(!is_null(arr) && arr.count>0){
        CGFloat iw = _viewWts.frame.size.width - 20;
        CGFloat ix = 10;
        for (ZZSymptomWTModel *model in arr) {
            UILabel *labQ = [self crateItemWith];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",convertToString(model.quesName),convertToString(model.answer)]];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(TextLightDarkColor) range:NSMakeRange(convertToString(model.quesName).length + 1,convertToString(model.answer).length)];
            
//            [labQ setText:convertToString(model.quesName)];
            [labQ setTextColor:UIColorFromRGB(TextDarkColor)];
            labQ.attributedText = str;
            
            CGRect f1 = CGRectMake(ix, y, iw,0);
            labQ.frame = f1;
            CGSize s = [self autoHeightOfLabel:labQ with:f1.size.width];
            
            
//            UILabel *labV = [self crateItemWith];
//            [labV setText:convertToString(model.answer)];
//            [labV setTextColor:UIColorFromRGB(TextLightDarkColor)];
//
//            CGRect f2 = CGRectMake(ix, y + s.height + 5, iw,0);
//            labV.frame = f2;
//            CGSize s2 = [self autoHeightOfLabel:labV with:f1.size.width];
            
            y = y + s.height + 5;
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
