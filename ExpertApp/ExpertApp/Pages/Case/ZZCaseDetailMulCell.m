//
//  ZZCaseDetailMulCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseDetailMulCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZCaseDetailMulCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_labTag setFont:ListDetailFont];
    [_labTag setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    
    [_labDesc setFont:ListDetailFont];
    [_labDesc setTextColor:UIColorFromRGB(TextBlackColor)];
    
    
    [_imgFile setBackgroundColor:[UIColor clearColor]];
    _imgFile.layer.borderWidth = 1.0f;
    _imgFile.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    [_imgFile setContentMode:UIViewContentModeScaleAspectFit];
}


-(void)dataToView:(NSDictionary *)item{
    [_labTag setText:@""];
    _labDesc.hidden = YES;
    _imgFile.hidden = YES;
    CGFloat height = _labDesc.frame.origin.y;
    if(item){
        [_labTag setText:item[@"dictDesc"]];
        
        int type = [item[@"dictType"] intValue];
        NSString *value = convertToString(item[@"dictValue"]);
        
        if(type == ZZEditControlTypeButton){
            _labDesc.hidden = YES;
            _imgFile.hidden = NO;
            [_imgFile sd_setImageWithURL:[NSURL URLWithString:convertToString(value)]];
            height = height + 60 + 15;
        }else{
            _labDesc.hidden = NO;
            [_labDesc setText:value];
            CGSize size = [self autoHeightOfLabel:_labDesc with:_labDesc.frame.size.width];
            height = height + size.height + 15;
        }
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, height)];
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
