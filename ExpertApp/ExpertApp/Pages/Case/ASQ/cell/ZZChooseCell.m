//
//  ZZChooseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChooseCell.h"
#import "MyButton.h"

@implementation ZZChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    CGRect topF = self.labTitle.frame;
    CGFloat y =  topF.origin.y + topF.size.height + 10;
    
    
    [_chooseViews setFrame:CGRectMake(15, y,ScreenWidth, 0)];
    [_chooseViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    int type = [item[@"cid"] intValue];
    
    CGFloat h = 0;
    for (int i=0; i<10; i++) {
        h = h + [self createItemButton:@"" tag:i y:h sel:YES];
    }
    [_chooseViews setFrame:CGRectMake(0, y, ScreenWidth, h)];
    
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + h + 10 +15)];
}

-(CGFloat)createItemButton:(NSString *)text tag:(int) tag y:(CGFloat) y sel:(BOOL) isSelected{
    UIView *view = [UIView new];
    UILabel *lab = [UILabel new];
    [lab setFrame:CGRectMake(10, 10, ScreenWidth - 100, 24)];
    [lab setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    [lab setText:text];
    [lab setNumberOfLines:0];
    CGSize s = [self autoHeightOfLabel:lab with:ScreenWidth - 100];
    if(s.height<24){
        s.height = 24;
    }
    [view addSubview:lab];
    
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    [btn setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [btn setFrame:CGRectMake(ScreenWidth - 100, (s.height+20 - 24)/2, 90, 24)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    btn.selected = isSelected;
    [view setFrame:CGRectMake(0, y, ScreenWidth, s.height + 20)];
    [_chooseViews addSubview:view];
    return s.height + 20;
}


-(void)btnOnClick:(UIButton *) btn{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
