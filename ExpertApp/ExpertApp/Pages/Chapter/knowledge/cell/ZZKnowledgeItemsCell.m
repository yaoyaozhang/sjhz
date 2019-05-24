//
//  ZZKnowledgeItemsCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeItemsCell.h"
#import "MyButton.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:obj:)]){
        [self.delegate onItemClick:_tempModel type:2 obj:nil];
    }
}


-(void)dataToItem:(ZZTJListModel *)model{
    _tempModel = model;
    [_labAuthor setText:model.user.signName];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(model.user.imageUrl)]];
    [[_viewsItem subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createItemView:model];
    
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, _viewsItem.frame.size.height + 57 + 15)];
}

-(void)createItemView:(ZZTJListModel *) model{
    
    CGFloat y = 0;
    CGFloat w =  ScreenWidth - 30;
    int i = 0;
    for (ZZChapterModel *item in model.news) {
        UIView *itemV = [[UIView alloc] initWithFrame:CGRectMake(15, y, w, 35)];
        [itemV setBackgroundColor:UIColor.clearColor];
        
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 4, 32, 32);
        btn.objTag = item;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, w - 45, 40)];
        [lab setFont:ListDetailFont];
        [lab setTextColor:UIColorFromRGB(TextDarkColor)];
        [lab setText:[NSString stringWithFormat:@"%@",item.title]];
        
        if(item.lclassify == 3){
            [btn setImage:[UIImage imageNamed:@"icon_list_video"] forState:UIControlStateNormal];
        }else if(item.lclassify == 1){
            [btn setImage:[UIImage imageNamed:@"icon_list_text"] forState:UIControlStateNormal];
        }else{
            if(item.isPlaying){
                [btn setImage:[UIImage imageNamed:@"icon_list_pause"] forState:UIControlStateNormal];
                [lab setTextColor:UIColorFromRGB(BgTitleColor)];
                
            }else{
                [btn setImage:[UIImage imageNamed:@"icon_list_play"] forState:UIControlStateNormal];
                [lab setTextColor:UIColorFromRGB(TextDarkColor)];
            }
        }
        
        [itemV addSubview:btn];
        [itemV addSubview:lab];
        itemV.tag = i;
        itemV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClick:)];
        [itemV addGestureRecognizer:tap];
        
        [_viewsItem addSubview:itemV];
        y=y+40;
        i= i +1;
    }
    
    [_viewsItem setFrame:CGRectMake(0, 57, ScreenWidth, 40*model.news.count)];
}


-(void)onItemClick:(UITapGestureRecognizer *) tap{
    UIView *v = tap.view;
    NSInteger tag = v.tag;
    ZZChapterModel *model = [_tempModel.news objectAtIndex:tag];
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:obj:)]){
        [self.delegate onItemClick:model type:1 obj:_tempModel.news];
    }
}

-(void)btnClick:(MyButton *)btn{
    ZZChapterModel *model = btn.objTag;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:obj:)]){
        [self.delegate onItemClick:model type:1 obj:_tempModel.news];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
