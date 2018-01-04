//
//  ZZSymptomWTCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomWTCell.h"
#import "UIView+Border.h"
#import "MyButton.h"

#import "UIImage+ImageWithColor.h"

@implementation ZZSymptomWTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _nameLabe.numberOfLines = 0;
    [_nameLabe setFont:ListTitleFont];
    
    [self.contentView addTopBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:1.0f];
}


-(void)dataToView:(ZZSymptomWTModel *)model check:(NSMutableDictionary *)checkItem{
    _tempModel = model;
    [_nameLabe setText:model.quesName];
    
    CGSize s = [self autoWidthOfLabel:_nameLabe with:_pwidth - 20];
    
    _chooseView.userInteractionEnabled = YES;
    [_chooseView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat x = 0;
    CGFloat y = 10;
    for (NSString *item in model.quesOptionArr) {
//        if(convertToString(item).length == 0){
//            continue;
//        }
        NSString *values = checkItem[convertIntToString(model.symptomWtId)];
        BOOL isCheck = NO;
        if(convertToString(values).length > 0 && [values rangeOfString:[NSString stringWithFormat:@"%@;",item]].location !=NSNotFound){
            isCheck = YES;
        }
        MyButton *ibtn= [self createItemButton:x y:y withText:item check:isCheck];
        CGRect ibtnF = ibtn.frame;
        if(ibtnF.origin.x + ibtnF.size.width > _pwidth){
            ibtnF.origin.y = ibtnF.origin.y + 50;
            ibtnF.origin.x = 0;
            [ibtn setFrame:ibtnF];
            
            y = y + 50;
            x = ibtnF.size.width+10;
        }else{
            x = x + (ibtnF.size.width+10);
            if(_pwidth - x  < 20){
                y = y + 50;
                x = 0;
            }
        }
    }
    if(x > 0){
        y = y + 50;
    }
    
    [_chooseView setFrame:CGRectMake(10, 10+s.height+10, _pwidth - 20, y)];
    [self setFrame:CGRectMake(0, 0, _pwidth - 20, y+10+s.height+20)];
}

-(MyButton * )createItemButton:(CGFloat ) x y:(CGFloat) y withText:(NSString * ) text check:(BOOL) isselected{
    CGFloat width = (_pwidth-10)/3;
    
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    btn.objTag = text;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.0f;
    [btn setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgSystemColor)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgSelectedColor)] forState:UIControlStateSelected];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:0];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.titleLabel setFont:ListDetailFont];
    btn.userInteractionEnabled = YES;
    btn.selected = isselected;
    [btn addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat w = [self checkWidth:text];
    if(w > width){
        width = width * 2;
    }
    
    [btn setFrame:CGRectMake(x, y, width - 10, 40)];
    
    [_chooseView addSubview:btn];
    
    return btn;
}

-(void)onItemClick:(MyButton *) btn{
    btn.selected = !btn.selected;
    if(self.delegate){
        [self.delegate onItemClick:_tempModel text:btn.objTag check:btn.selected];
    }
}


-(CGFloat )checkWidth:(NSString *)text{
    _tempLabel = ({
        UILabel *lab = [UILabel new];
        [lab setTextColor:UIColor.whiteColor];
        [lab setFont:ListTitleFont];
        lab.numberOfLines = 1;
        [lab setTextAlignment:NSTextAlignmentCenter];
        lab;
    });
    
    [_tempLabel setText:text];
    CGSize s = [self autoWidthOfLabel:_tempLabel height:40];
    return s.width;
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

- (CGSize )autoWidthOfLabel:(UILabel *)label height:(CGFloat )height{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, height);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    return expectedLabelSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
