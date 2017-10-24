//
//  ZZChapterUserCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterUserCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZChapterUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - 设置cell
- (void)setChapterModel:(ZZChapterModel *)newsModel
{
    _chapterModel = newsModel;
    
    self.sendButton.tag    = ZZChapterCellClickTagSend;
    self.collectButton.tag = ZZChapterCellClickTagCollect;
    self.commentButton.tag = ZZChapterCellClickTagComment;
    [self.sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconImage.layer.borderColor = UIColorFromRGB(BgListSectionColor).CGColor;
    self.iconImage.layer.borderWidth = 1.0f;
    
    [self.imgVideoOrMp3 setBackgroundColor:[UIColor clearColor]];
    
    
    [self.sendButton.titleLabel setFont:ListDetailFont];
    [self.sendButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.sendButton setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
    [self.collectButton.titleLabel setFont:ListDetailFont];
    [self.collectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.collectButton setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
    [self.commentButton.titleLabel setFont:ListDetailFont];
    [self.commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.commentButton setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
    
    // 标题
    self.titleLabel.text = newsModel.title;
    
    // 判断已读标记
    //    if ([[DDNewsCache sharedInstance] containsObject:self.titleLabel.text])
    self.imgVideoOrMp3.hidden = NO;
    if(newsModel.showVideo == 1){
        [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_sound"]];
    }else if(newsModel.showVideo == 2){
        [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_video"]];
    }else{
        self.imgVideoOrMp3.hidden = YES;
    }
    
    if(newsModel.collect){
        [self.collectButton setImage:[UIImage imageNamed:@"btn_alreadycollected"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
    }
    if(newsModel.commentNum>0){
        [self.commentButton setTitle:convertIntToString(newsModel.commentNum) forState:UIControlStateNormal];
    }
    
    [self.titleLabel setFont:ListTitleFont];
    self.titleLabel.textColor = UIColorFromRGB(TextDarkColor);
    
    // 标题
    [self.digestLabel setFont:ListDetailFont];
    self.digestLabel.text = newsModel.author;
    self.digestLabel.textColor = UIColorFromRGB(TextPlaceHolderColor);
    
    // 时间
    [self.timeLabel setFont:ListDetailFont];
    self.timeLabel.textColor = UIColorFromRGB(TextPlaceHolderColor);
    self.timeLabel.text = dateTransformDateString(@"yyyy.MM.dd", newsModel.createTime);
    
    // 单图、左图右字的第一张
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:newsModel.picture]
                      placeholderImage:[UIImage imageNamed:@"placeholder_small"]
                               options:SDWebImageDelayPlaceholder
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 if (cacheType == 1 || cacheType == 2) {return;} // 0新下载，1磁盘缓存，2内存缓存
                                 self.iconImage.alpha = 0;
                                 [UIView animateWithDuration:0.5 animations:^{
                                     self.iconImage.alpha = 1;
                                 }];
                             }
     ];
    
}

-(void)buttonClick:(UIButton *) btn{
    NSAssert(self.onItemClickBlock, @"必须传入self.onItemClickBlock");
    self.onItemClickBlock(btn.tag);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
