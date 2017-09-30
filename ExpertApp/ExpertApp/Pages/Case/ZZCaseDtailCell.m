//
//  ZZCaseDtailCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseDtailCell.h"

@implementation ZZCaseDtailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labTag setFont:ListDetailFont];
    [_labTag setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    
    [_labValue setFont:ListDetailFont];
    [_labValue setTextColor:UIColorFromRGB(TextBlackColor)];
    _labValue.layer.cornerRadius = 4.0f;
    _labValue.layer.masksToBounds = YES;
    
    
    [_labUnit setFont:ListDetailFont];
    [_labUnit setTextColor:UIColorFromRGB(TextBlackColor)];
}

-(void)dataToView:(NSDictionary *)item{
    [_labUnit setText:@""];
    if(item){
        [_labTag setText:item[@"dictDesc"]];
        
        int type = [item[@"dictType"] intValue];
        NSString *value = convertToString(item[@"dictValue"]);
        if(type == ZZEditControlTypeSex){
            [_labValue setText:([value intValue]==1?@"男":@"女")];
        }else if(type == ZZEditControlTypeDoubleTextField){
            NSArray *values = [value componentsSeparatedByString:@","];
            if(values.count > 1){
                [_labValue setText:[NSString stringWithFormat:@"%@  ————  %@",values[0],values[1]]];
            }
        }else{
            [_labValue setText:convertToString(value)];
        }
        
        if(type == ZZEditControlTypeChoose){
            [_labValue setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
            [_labValue setTextAlignment:NSTextAlignmentCenter];
        }else{
            
            [_labValue setBackgroundColor:[UIColor clearColor]];
            [_labValue setTextAlignment:NSTextAlignmentLeft];
        }
        
        if([item[@"valueType"] intValue] == 2 || [@"lungTime" isEqual:item[@"dictName"]]){
            _labUnit.hidden = NO;
            [_labUnit setText:item[@"placeholder"]];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
