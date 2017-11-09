//
//  ZZSQBaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSQBaseCell.h"

@implementation ZZSQBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _labTitle=[[UILabel alloc] init];
    [_labTitle setTextAlignment:NSTextAlignmentCenter];
    [_labTitle setFont:ListTitleFont];
    [_labTitle setTextColor:TextBlackColor];
    [_labTitle setTextAlignment:NSTextAlignmentLeft];
    [_labTitle setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_labTitle];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _labTitle=[[UILabel alloc] init];
        [_labTitle setTextAlignment:NSTextAlignmentCenter];
        [_labTitle setFont:ListTitleFont];
        [_labTitle setTextColor:TextBlackColor];
        [_labTitle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labTitle];
    }
    return self;
}

-(void)dataToView:(NSDictionary *)item{
    if(item){
        [_labTitle setFrame:CGRectMake(15, 8, ScreenWidth - 30, 0)];
        [_labTitle setText:convertToString(item[@"name"])];
        [self autoHeightOfLabel:_labTitle with:ScreenWidth - 30];
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



/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )height{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(height,FLT_MAX);
    
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