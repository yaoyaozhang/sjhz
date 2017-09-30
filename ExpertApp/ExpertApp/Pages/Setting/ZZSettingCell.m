//
//  ZZSettingCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSettingCell.h"

@implementation ZZSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imgTag setContentMode:UIViewContentModeScaleAspectFit];
    [_labelTitle setFont:FontFiftent];
    [_labelTitle setTextColor:UIColorFromRGB(TextDarkColor)];
}

-(void)dataToView:(NSDictionary *)dict{
    CGRect lf = _labelTitle.frame;
    if([@"" isEqual:convertToString(dict[@"icon"])]){
        _imgTag.hidden = YES;
        lf.origin.x = 16;
    }else {
        lf.origin.x = 46;
    }
    _labelTitle.frame = lf;
    [_imgTag setImage:[UIImage imageNamed:dict[@"icon"]]];
    [_labelTitle setText:dict[@"text"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
