//
//  ZZSymptomCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomCell.h"
@interface ZZSymptomCell()<ZZSymptomViewDelegate>{
    
}
@end

@implementation ZZSymptomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_nameLabel setNumberOfLines:0];
    [_nameLabel setFont:ListTitleFont];
    [_nameLabel setTextColor:UIColorFromRGB(TextDarkColor)];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        [_bgView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        [self.contentView addSubview:_bgView];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 21)];
        [_nameLabel setNumberOfLines:0];
        [_nameLabel setFont:ListTitleFont];
        [_nameLabel setTextColor:UIColorFromRGB(TextDarkColor)];
        
        [self.contentView addSubview:_nameLabel];
        
        
        
        _symptomView = [[ZZSymptomView alloc] initZZSymptomView];
        _symptomView.delegate = self;
        [self.contentView addSubview:_symptomView];
        
    }
    return self;
}



-(void)dataToView:(NSString *)title data:(NSMutableDictionary *)data{
    CGFloat y = 10;
    if(convertToString(title).length == 0){
        _nameLabel.hidden = YES;
        _bgView.hidden = YES;
    }else{
        _nameLabel.hidden = NO;
        _bgView.hidden = NO;
        [_nameLabel setText:convertToString(title)];
        
        
        [self autoWidthOfLabel:_nameLabel with:ScreenWidth-20];
        CGRect tf = _nameLabel.frame;
        y = tf.origin.y + tf.size.height + 10;
        
        [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, y)];
    }
    
    [_symptomView setItemValues:data block:nil];
    
//    __block ZZSymptomCell *safeSelf = self;
//    [_symptomView setItemValues:arr block:^(ZCSymptomAction action, int index, id obj) {
//        if(safeSelf.delegate){
//            [safeSelf.delegate onItemClick:obj type:action index:index];
//        }
//    }];

    CGRect sf = _symptomView.frame;
    sf.origin.y = y;
    [_symptomView setFrame:sf];
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + sf.size.height + 10)];
    
}

-(void)onItemClick:(id)model type:(int)type index:(int)index{
    if(self.delegate){
        [self.delegate onItemClick:model type:type index:index];
    }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
