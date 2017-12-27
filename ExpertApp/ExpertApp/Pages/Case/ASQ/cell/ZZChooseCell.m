//
//  ZZChooseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChooseCell.h"
#import "MyButton.h"
#import "UIView+Border.h"

@implementation ZZChooseCell{
    UIButton *btnSel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)dataToView:(ZZQSModel *)itemModel{
    [super dataToView:itemModel];
    
    CGRect topF = self.labTitle.frame;
    CGFloat y =  topF.origin.y + topF.size.height + 10;
    
    
    
    
    [_chooseViews setFrame:CGRectMake(15, y,ScreenWidth, 0)];
    [_chooseViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_chooseViews addTopBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:1.0f];
    
    CGFloat h = 0;
    for (int i=0; i<self.tempModel.quesAnswer.count; i++) {
        ZZQSAnswerModel *item = self.tempModel.quesAnswer[i];
        BOOL isSelected = NO;
        if(!is_null(self.tempModel.values) && [self.tempModel.values isKindOfClass:[NSDictionary class]]){
            if([self.tempModel.values objectForKey:convertIntToString(item.aid)]){
                isSelected = YES;
            }
        }
        h = h + [self createItemButton:self.tempModel.quesAnswer[i] tag:i y:h sel:isSelected];
    }
    [_chooseViews setFrame:CGRectMake(0, y, ScreenWidth, h)];
    
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + h + 10 +15)];
}

-(CGFloat)createItemButton:(ZZQSAnswerModel *)model tag:(int) tag y:(CGFloat) y sel:(BOOL) isSelected{
    UIView *view = [UIView new];
    UILabel *lab = [UILabel new];
    [lab setFrame:CGRectMake(20, 10, ScreenWidth - 110, 24)];
    [lab setTextColor:UIColorFromRGB(TextListColor)];
    [lab setText:[NSString stringWithFormat:@"%@、%@",model.tag,model.context]];
    [lab setNumberOfLines:0];
    CGSize s = [self autoHeightOfLabel:lab with:ScreenWidth - 110];
    if(s.height<24){
        s.height = 24;
    }
    [view addSubview:lab];
    
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    btn.objTag = model;
    [btn setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    [btn setFrame:CGRectMake(ScreenWidth - 100, (s.height+20 - 34)/2, 90, 34)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    if(self.showType == 0){
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:btn];
    btn.selected = isSelected;
    if(isSelected && self.tempModel.quesType == 1){
        btnSel = btn;
    }
    [view setFrame:CGRectMake(0, y, ScreenWidth, s.height + 20)];
    [_chooseViews addSubview:view];
    return s.height + 20;
}


-(void)btnOnClick:(MyButton *) btn{
    if(self.delegate){
        btn.selected = !btn.selected;
        if(self.tempModel.quesType  == 1){
            
            if(btnSel){
                btnSel.selected = NO;
            }
            if(btn.selected){
                btnSel = btn;
            }
        }
        
        ZZQSAnswerModel *model = btn.objTag;
        model.isSelected = btn.selected;
        
        self.tempModel = [self.delegate onCellClick:model type:self.tempModel.quesType with:self.tempModel];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
