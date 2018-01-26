//
//  ZZSymptomAlertView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/25.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomAlertView.h"
#import "ZZSymptomModel.h"

@implementation ZZSymptomAlertView

-(instancetype)initWithTitle:(NSString *)title dict:(NSDictionary *)item cancel:(NSString *)cancel comfirm:(NSString *)text{
    self = [super initWithTitle:title message:@"" cancel:cancel comfirm:text];
    if(self){
        
        CGFloat w = super.subContentView.frame.size.width;
        
        
        NSMutableArray *arr = item[@"dictValue"];
        
        
        CGFloat y = 0;
        if(!is_null(arr) && arr.count>0){
            for (ZZSymptomWTModel *model in arr) {
                UILabel *labQ = [self crateItemWith];
                UILabel *labV = [self crateItemWith];
                [labQ setText:convertToString(model.quesName)];
                [labQ setTextColor:UIColorFromRGB(TextDarkColor)];
                [labV setText:convertToString(model.answer)];
                [labV setTextColor:UIColorFromRGB(TextLightDarkColor)];
                
                
                CGSize s1 = [self autoHeightOfLabel:labQ with:w];
                
                CGSize s2 = [self autoHeightOfLabel:labV with:w];
                
                y = y + s1.height + 5 + s2.height + 5;
            }
        }
        
        CGRect sf = super.subContentView.frame;
        sf.size.height = y + 10;
        super.subContentView.frame = sf;
        
        [super layoutConentView];
        
        
    }
    return self;
}



-(UILabel *)crateItemWith{
    UILabel *tempLabel = ({
        UILabel *lab = [UILabel new];
        [lab setTextColor:UIColorFromRGB(TextDarkColor)];
        [lab setFont:ListDetailFont];
        lab.numberOfLines = 0;
        [lab setTextAlignment:NSTextAlignmentLeft];
        lab;
    });
    [super.subContentView addSubview:tempLabel];
    return tempLabel;
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
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
