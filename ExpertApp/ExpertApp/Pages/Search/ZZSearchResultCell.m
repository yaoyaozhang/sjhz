//
//  ZZSearchResultCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/15.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSearchResultCell.h"


NSString *const kZCCollectionViewCellID = @"ZCCollectionViewCell";

@implementation ZZSearchResultCell

-(void)prepareForReuse{
    [super prepareForReuse];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}


-(void)setupViews{
    if (_labTitle) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat SpaceX = 10;
    _labTitle = [[UILabel alloc]init];
    [_labTitle setTextColor:UIColorFromRGB(TextDarkColor)];
    [_labTitle setFont:ListTitleFont];
    _labTitle.numberOfLines = 1;
    [_labTitle setTextAlignment:NSTextAlignmentCenter];
    [_labTitle setFrame:CGRectMake( SpaceX, 10, (ScreenWidth - 5)/2- SpaceX * 2, 25)];
    [self.contentView addSubview:_labTitle];
    
    
    _labDesc = [[UILabel alloc]init];
    [_labDesc setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labDesc setFont:ListTitleFont];
    _labDesc.numberOfLines = 0;
    [_labDesc setFrame:CGRectMake( SpaceX, 40, (ScreenWidth - 5)/2-SpaceX * 2, 30)];
    [self.contentView addSubview:_labDesc];
    
    
//    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_btnSend setBackgroundColor:UIColorFromRGB(BgTitleColor)];
//    _btnSend.layer.cornerRadius = 4.0f;
//    _btnSend.layer.masksToBounds = YES;
//    [_btnSend setTitle:@"去看看" forState:0];
//    [_btnSend setTitleColor:UIColorFromRGB(TextWhiteColor) forState:0];
//    [_btnSend.titleLabel setFont:ListTitleFont];
//    [_btnSend setFrame:CGRectMake(30, 125, (ScreenWidth - 5)/2-60 , 35)];
//    [self.contentView addSubview:_btnSend];
    
    _labLook = [[UILabel alloc] init];
    [_labLook setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    _labLook.layer.cornerRadius = 4.0f;
    _labLook.layer.masksToBounds = YES;
    [_labLook setText:@"去看看"];
    [_labLook setTextColor:UIColorFromRGB(TextWhiteColor)];
    [_labLook setFont:ListTitleFont];
    [_labLook setTextAlignment:NSTextAlignmentCenter];
    [_labLook setFrame:CGRectMake(30, 125, (ScreenWidth - 5)/2-60 , 35)];
    [self.contentView addSubview:_labLook];
    
    [_btnSend addTarget:self action:@selector(onClickLook:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Public Method

- (void)configureCellWithPostURL:(LemmaModel *)model{
    
    [_labTitle setText:convertToString(model.lemmaTitle)];// [NSString stringWithFormat:@"我是标题%@",item[@"row"]]
    [_labDesc setText:convertToString(model.lemmaDesc)];// [NSString stringWithFormat:@"我是描述%@",item[@"desc"]]
    
    [self autoWidthOfLabel:_labDesc with:_labDesc.frame.size.width];
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
    CGSize maximumLabelSize = CGSizeMake(height,FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    if(expectedLabelSize.height > 80){
        expectedLabelSize.height = 80;
    }
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}


-(void)onClickLook:(UIButton *) btn{
    
}

@end
