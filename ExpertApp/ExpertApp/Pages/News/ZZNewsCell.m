//
//  ZZNewsCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNewsCell.h"

@interface ZZNewsCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgDot;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;


@end


@implementation ZZNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgDot.layer.cornerRadius = 2.5f;
    _imgDot.layer.masksToBounds = YES;
    [_imgDot setBackgroundColor:UIColorFromRGB(BgRedColor)];
    
    [_labelText setFont:ListDetailFont];
    [_labelText setTextColor:UIColorFromRGB(TextBlackColor)];
    _labelText.numberOfLines = 0;
    
    [_labelTime setFont:ListTimeFont];
    [_labelTime setTextColor:UIColorFromRGB(TextLightDarkColor)];
    
}


-(void)dataToView:(NSIndexPath *) indexPath model:(ZZNewsModel *)model{
    [_labelText setText:model.context];
    [_labelTime setText:intervalSinceNow(model.createTime)];
    if(model.state == 1){
        _imgDot.hidden = YES;
    }else{
        _imgDot.hidden = NO;
    }
    
    [self autoHeightOfLabel:_labelText with:ScreenWidth - 25-95];
    CGRect f = _labelText.frame;
    [self setFrame:CGRectMake(0, 0,ScreenWidth, f.size.height + 30)];
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
