//
//  ZZRemarkLabelCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRemarkLabelCell.h"
#import "UIView+Border.h"

@implementation ZZRemarkLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _checkLabel.layer.borderColor=UIColorFromRGB(BgTitleColor).CGColor;
    _checkLabel.layer.borderWidth = 1.0f;
    _checkLabel.layer.masksToBounds = YES;
    _checkLabel.layer.cornerRadius = 4.0f;
    
    [_checkLabel setTextColor:UIColorFromRGB(BgTitleColor)];
    [_checkLabel setFont:ListTitleFont];
    [_checkLabel setTextAlignment:NSTextAlignmentCenter];
}

-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    CGFloat xw = (ScreenWidth - 30 - 40)/5;
    CGFloat y = 44;
    if(![@"" isEqual:convertToString(item[@"value"])]){
        [_checkLabel setFrame:CGRectMake(15, 44 + 8, xw, 28)];
        [_checkLabel setText:convertToString(item[@"value"])];
        _checkLabel.hidden = NO;
        y = 88;
    }else{
        _checkLabel.hidden = YES;
    }
    [_viewLabels setFrame:CGRectMake(0, y, ScreenWidth, 44)];
    [_viewLabels addTopBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:1.0f];
    
    [_viewLabels.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *titles = @[@"朋友",@"同事",@"亲人",@"家庭",@"陌生人"];
    for (int i=1; i<=5; i++) {
        [self createItemButton:titles[i-1] index:i xw:xw];
    }
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + 44 + 7)];
    
}

-(void)createItemButton:(NSString *)text index:(int) i xw:(CGFloat) w{
    int x = 15 + w*(i-1) + (i-1)*10;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor=UIColorFromRGB(BgLineColor).CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4.0f;
    [btn setTitleColor:UIColorFromRGB(TextDarkColor) forState:UIControlStateNormal]; 
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(x, 8, w, 28)];
    
    [btn addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [_viewLabels addSubview:btn];
    
}

-(void)onItemClick:(UIButton *) btn{
    if(self.delegate){
        [self.delegate onCellClick:btn.titleLabel.text type:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
