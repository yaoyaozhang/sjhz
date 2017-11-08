//
//  ZZRemarkCaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRemarkCaseCell.h"
#import "MyButton.h"

@implementation ZZRemarkCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    
    
    [_caseViews setFrame:CGRectMake(0, 44, ScreenWidth, 0)];
    
    [_caseViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat y = 44;
    _caseViews.hidden = YES;
    if(_cases && _cases.count > 0){
        CGFloat iy = 0;
        for (NSDictionary *item in _cases) {
            [self createItemButton:item y:iy];
            iy = iy + 40 + 10;
        }
        _caseViews.hidden = NO;
        [_caseViews setFrame:CGRectMake(0, 44, ScreenWidth, iy)];
        y = y + iy;
        
    }
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y)];
    
}

-(void)createItemButton:(NSDictionary *)item y:(CGFloat) y{
    NSString *text = @"";
    text = [text stringByAppendingFormat:@"%@ (%@%@岁)",convertToString(item[@"name"]),[item[@"sex"] intValue]==1?@"男":@"女",convertToString(item[@"age"])];
    if([item[@"type"] intValue] == 2){
        text = [text stringByAppendingString:@"运动康复病例"];
    }else{
       text = [text stringByAppendingString:@"普通病例"];
    }
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderColor=UIColorFromRGB(BgTitleColor).CGColor;
    btn.layer.borderWidth = 1.0f;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 4.0f;
    btn.objTag = item;
    [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(15, y, ScreenWidth - 30, 40)];
    [btn addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [_caseViews addSubview:btn];
    
}

-(void)onItemClick:(MyButton *) btn{
    if(self.delegate){
        [self.delegate onCellClick:btn.objTag type:2];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
