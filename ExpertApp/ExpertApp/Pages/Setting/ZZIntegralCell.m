//
//  ZZIntegralCell.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/10.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import "ZZIntegralCell.h"

@implementation ZZIntegralCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labName setFont:ListTitleFont];
    [_labTime setFont:ListDetailFont];
    
    [_labName setTextColor:UIColorFromRGB(TextDarkColor)];
    [_labTime setTextColor:UIColorFromRGB(TextLightDarkColor)];
    
    
    [_labIntegral setText:@"xxx积分"];
    [_labIntegral setTextColor:UIColorFromRGB(BgTitleColor)];
    [_labIntegral setFont:FontSeventeen];
    
}


-(void)dataToView:(NSDictionary *) item{
    [_labName setText:convertToString(item[@"title"])];
//    [_labTime setText:dateTransformString(FormateTime, [NSDate date])];
    [_labTime setText:convertToString(item[@"create_time"])];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@积分",convertToString(item[@"source"])]];
    [string addAttribute:NSFontAttributeName value:FontSeventeen range:NSMakeRange(0, string.length - 2)];
    [string addAttribute:NSFontAttributeName value:ListDetailFont range:NSMakeRange(string.length - 2, 2)];
    _labIntegral.attributedText = string;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
