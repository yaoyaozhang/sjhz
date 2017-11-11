//
//  ZZDiscussCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDiscussCell.h"
#import  <SDWebImage/UIImageView+WebCache.h>

@implementation ZZDiscussCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgAvatar.layer.cornerRadius = 25.0f;
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.borderColor   = UIColorFromRGB(BgLineColor).CGColor;
    _imgAvatar.layer.borderWidth   = 1.0f;
    
    [_labName setFont:ListDetailFont];
    [_labName setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_labMessage setFont:ListDetailFont];
    [_labMessage setTextColor:UIColorFromRGB(TextSizeSixColor)];
    _labMessage.numberOfLines = 0;
}



-(void)dataToView:(ZZCaseTalkModel *) item{

    CGFloat h = _labMessage.frame.origin.y;
    if(item){
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(item.imgUrl)]];
        [_labName setText:item.docName];
        [_labMessage setText:item.context];
        
        [_labTime setText:intervalSinceNow(item.createTime)];
        
        CGSize s = [self autoHeightOfLabel:_labMessage with:_labMessage.frame.size.width];
        if(s.height < 21){
            s.height = 21;
        }
        
        h = h + s.height + 10;
    }else{
        h = h + 21 + 10;
    }
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, h)];
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
    CGSize maximumLabelSize = CGSizeMake(width,FLT_MAX);
    
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
