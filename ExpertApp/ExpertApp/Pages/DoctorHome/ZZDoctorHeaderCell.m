//
//  ZZDoctorHeaderCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorHeaderCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZDoctorHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_viewZhic setBackgroundColor:[UIColor clearColor]];
    
    _imgHeader.layer.cornerRadius = 50.0f;
    _imgHeader.layer.masksToBounds = YES;
    [_imgHeader setContentMode:UIViewContentModeScaleAspectFit];
    _imgHeader.layer.borderColor = UIColorFromRGB(BgListSectionColor).CGColor;
    _imgHeader.layer.borderWidth = 1.0f;
    
    [_labDesc setFont:ListDetailFont];
    [_labHospital setFont:ListDetailFont];
    [_labKes setFont:ListDetailFont];
    [_labFansChapterS setFont:ListDetailFont];
    [_labName setFont:TitleFont];
    
    
    [_labFansChapterS setTextColor:UIColorFromRGB(TextWhiteColor)];
    [_labName setTextColor:UIColorFromRGB(TextWhiteColor)];
    [_labKes setTextColor:UIColorFromRGB(TextWhiteColor)];
    [_labHospital setTextColor:UIColorFromRGB(TextWhiteColor)];
    [_labDesc setTextColor:UIColorFromRGB(TextWhiteColor)];
    _labKes.numberOfLines = 0;
    
}

-(void)dataToView:(ZZUserInfo *)model{
    [_viewZhic.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(model && model.userId>0){
        [_imgHeader sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"docheader"]];
        [_labName setText:convertToString(model.docName)];
        [_labFansChapterS setText:[NSString stringWithFormat:@"粉丝:%d",model.fansNumber]];
        _labFansChapterS.hidden = YES;
        [_labKes setText:convertToString(model.departmentName)];
        [_labHospital setText:convertToString(model.hospital)];
        [_labDesc setText:convertToString(model.accomplished)];
        
        CGSize size = [self autoWidthOfLabel:_labName with:_labName.frame.size.height];
        CGRect f = _viewZhic.frame;
        f.origin.x = _labName.frame.origin.x + size.width + 5;
        [_viewZhic setFrame:f];
        
        if(model.dclabel && model.dclabel.length>0){
            NSArray *arr = [model.dclabel componentsSeparatedByString:@","];
            CGFloat xx = 0;
            int i= 0;
            for(NSString *itemText in arr){
                xx = [self createLabel:itemText x:xx];
                i = i + 1;
                if(i>=3){
                    break;
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(CGFloat )createLabel:(NSString *) text x:(CGFloat) xx{
    UILabel  *lab = [[UILabel alloc] initWithFrame:CGRectMake(xx, 0, 0, 15)];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius  = 2.0f;
    [lab setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [lab setTextColor:UIColorFromRGB(BgTitleColor)];
    [lab setFont:ListElevenFont];
    [lab setText:text];
    
    CGSize s = [self autoWidthOfLabel:lab with:15];
    [lab setFrame:CGRectMake(xx, 0, s.width + 10, 15)];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [_viewZhic addSubview:lab];
    
    return xx + s.width + 15;
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


@end
