//
//  ZZKnowledgeItemsCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeItemsCell.h"
#import "MyButton.h"

@implementation ZZKnowledgeItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgAvatar.layer.cornerRadius = 16.0f;
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    _imgAvatar.layer.borderWidth = LINE_WIDTH;
    
    [_lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_btnMore setImage:[UIImage imageNamed:@"icon_list_more"] forState:UIControlStateNormal];
    [_btnMore setTitle:@"" forState:UIControlStateNormal];
    
    [_btnMore addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_labAuthor setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labAuthor setFont:ListTitleFont];
}

-(void)moreClick:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:)]){
        [self.delegate onItemClick:_tempModel type:2];
    }
}


-(void)dataToItem:(ZZTJListModel *)model{
    _tempModel = model;
    [_labAuthor setText:model.className];
    [[_viewsItem subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createItemView:model];
    
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, _viewsItem.frame.size.height + 57 + 15)];
}

-(void)createItemView:(ZZTJListModel *) model{
    CGFloat y = 0;
    CGFloat w =  ScreenWidth - 30;
    for (ZZChapterModel *item in model.wenzhang) {
        UIView *itemV = [[UIView alloc] initWithFrame:CGRectMake(15, y, w, 35)];
        [itemV setBackgroundColor:UIColor.clearColor];
        
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 4, 32, 32);
        btn.objTag = item;
        if(item.isPlaying){
            [btn setImage:[UIImage imageNamed:@"icon_list_pause"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"icon_list_play"] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, w - 45, 40)];
        [lab setFont:ListDetailFont];
        [lab setTextColor:UIColorFromRGB(TextDarkColor)];
        [lab setText:[NSString stringWithFormat:@"%@",item.title]];
        
        [itemV addSubview:btn];
        [itemV addSubview:lab];
        
        [_viewsItem addSubview:itemV];
        y=y+40;
    }
    
    [_viewsItem setFrame:CGRectMake(0, 57, ScreenWidth, 40*model.wenzhang.count)];
}

-(void)btnClick:(MyButton *)btn{
    ZZChapterModel *model = btn.objTag;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:)]){
        [self.delegate onItemClick:model type:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
