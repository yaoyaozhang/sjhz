//
//  ZZAcountInfoCell.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZAcountInfoCell.h"

@implementation ZZAcountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.width/2;
    _imgAvatar.layer.masksToBounds = YES;
    _labTitle.numberOfLines = 2;
    [_imgAvatar setImage:[UIImage imageNamed:@"docheader"]];
    
    [_labTitle setTextColor:UIColorFromRGB(TextDarkColor)];
    [_labTitle setFont:ListTitleFont];
    
    [_labDesc setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labDesc setFont:ListDetailFont];
}


-(void)dataToView:(NSDictionary *) item{
//    [_labTitle setText:@"徐博士-我是b标题惺惺惜惺惺我是b标题惺惺惜惺惺我是b标题惺惺惜惺惺"];
    [_labTitle sizeToFit];
    [_labDesc setText:[NSString stringWithFormat:@"%@积分",item[@"xfei"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
