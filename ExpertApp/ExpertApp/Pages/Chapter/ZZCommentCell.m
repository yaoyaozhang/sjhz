//
//  ZZCommentCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCommentCell.h"

@implementation ZZCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [_viewsReply setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    _viewsReply.hidden = YES;
    
    _imgAvatar.layer.cornerRadius = 20.0f;
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    _imgAvatar.layer.borderWidth = .75f;
    
    [_labName setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labName setFont:FontFiftent];
    
    
    [_labText setTextColor:UIColorFromRGB(TextSizeSixColor)];
    [_labText setFont:ListDetailFont];
    _labText.numberOfLines = 0;
    
    [_labTime setFont:ListTimeFont];
    [_labTime setTextColor:UIColorFromRGB(TextSizeNineColor)];
    
    [_btnComment setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnComment.titleLabel setFont:ListDetailFont];
    [_btnComment addTarget:self action:@selector(clickComment:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)clickComment:(UIButton *)btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCommentCellClick:)]){
        [self.delegate onCommentCellClick:self.tempModel];
    }
}

-(void)dataToView:(ZZChapterCommentModel *)model{
    _viewsReply.hidden = YES;
    _tempModel = model;
    [_labName setText:convertToString(model.name)];
    [_labText setText:convertToString(model.content)];
    [self autoWidthOfLabel:_labText with:_labText.frame.size.width];
    CGRect f = _labText.frame;
    CGRect tf = _labTime.frame;
    tf.origin.y = f.origin.y + f.size.height + 6;
    [_labTime setFrame:tf];
    
    CGFloat h = tf.origin.y + tf.size.height;
    if(model.child!=nil && model.child.count>0 && model.deptCid == 0){
        _viewsReply.hidden = NO;
        [_viewsReply.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGRect vf = _viewsReply.frame;
        vf.origin.y = h + 10;
        
        
        CGFloat fy = 0;
        CGFloat fw = ScreenWidth - 92;
        int i = 0;
        for (ZZChapterCommentModel *item in model.child) {
            if(item.cid==0){
                continue;
            }
            fy = [self createReplyLabel:[NSString stringWithFormat:@"%@%@",convertToString(item.name),convertToString(item.content)] fy:fy fw:fw model:item];
            
            if(i<model.child.count-1){
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, fy + 10, fw - 20, 1.f)];
                [lineView setBackgroundColor:UIColorFromRGB(0xE7E7E7)];
                [_viewsReply addSubview:lineView];
                fy = fy + 11;
            }
            i ++ ;
        }
        vf.size.height = fy + 10;
        [_viewsReply setFrame:vf];
        
        h = h + fy + 20;
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, h + 25)];
}


-(CGFloat )createReplyLabel:(NSString *) text fy:(CGFloat )y fw:(CGFloat ) w model:(ZZChapterCommentModel *) model{
    w = w - 20;
    //label  需要操作的Label
    //font   该字符的字号
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange stringRange = NSMakeRange(0, convertToString(model.name).length); //该字符串的位置
    [noteString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(TextBlackColor) range:stringRange];
    
    
    UILabel *labReply = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 10, w, 0)];
    labReply.numberOfLines = 0;
    [labReply setFont:ListDetailFont];
    [labReply setTextColor:UIColorFromRGB(TextSizeSixColor)];
    [labReply setAttributedText:noteString];
    CGSize s = [self autoWidthOfLabel:labReply with:w];
    [_viewsReply addSubview:labReply];
    return y + s.height + 10;
    
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
