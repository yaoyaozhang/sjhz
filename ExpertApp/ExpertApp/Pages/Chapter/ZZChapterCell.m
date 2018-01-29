//
//  ZZChapterCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterCell.h"

#import "SDCycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZZChapterCell()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *cycleImageView;

// 摘要
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoOrMp3;


/** 左图右字的单个图片，三图中的第一个图片 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
/** 三图：其余两张图片 */
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgextras;

/** 大图：区分开，为了给大图设置不同的placeholder */
@property (weak, nonatomic) IBOutlet UIImageView *bigImage;

@end

@implementation ZZChapterCell

#pragma mark - 设置cell
- (void)setChapterModel:(ZZChapterModel *)newsModel
{
    _chapterModel = newsModel;
    
    // 图片轮播
    if(!is_null(_chapterModel.pics)){
        [self setupCycleImageCell:newsModel];
    }
    
    self.sendButton.tag    = ZZChapterCellClickTagSend;
    self.collectButton.tag = ZZChapterCellClickTagCollect;
    self.commentButton.tag = ZZChapterCellClickTagComment;
    [self.sendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    [self.titleLabel setFont:ListTitleFont];
    self.titleLabel.textColor = UIColorFromRGB(TextDarkColor);
    
    // 标题
    [self.digestLabel setFont:ListDetailFont];
    self.digestLabel.text = newsModel.content;
    self.digestLabel.textColor = UIColorFromRGB(TextPlaceHolderColor);
    
    // 时间
    [self.timeLabel setFont:ListDetailFont];
    self.timeLabel.textColor = UIColorFromRGB(TextPlaceHolderColor);
    self.timeLabel.text = dateTransformDateString(FormateTime, newsModel.updateTime);
    
    
    self.iconImage.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    self.iconImage.layer.borderWidth = 0.75f;
    
    if(newsModel.commentNum>0){
        [self.commentButton setTitle:convertIntToString(newsModel.commentNum) forState:UIControlStateNormal];
    }
    
    self.imgVideoOrMp3.hidden = NO;
    if(newsModel.showVideo == 1){
        [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_sound"]];
    }else if(newsModel.showVideo == 2){
        [self.imgVideoOrMp3 setImage:[UIImage imageNamed:@"knowledge_video"]];
    }else{
        self.imgVideoOrMp3.hidden = YES;
    }
    
    if(newsModel.commentNum>0){
        [_commentButton setTitle:convertIntToString(newsModel.commentNum) forState:UIControlStateNormal];
    }
    if(newsModel.collect){
        [self.collectButton setImage:[UIImage imageNamed:@"btn_alreadycollected"] forState:UIControlStateNormal];
    }else{
        [self.collectButton setImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
    }
    
    [self.iconImage setContentMode:UIViewContentModeScaleAspectFit];
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
    
    // 大图的单张：
    [self.bigImage sd_setImageWithURL:[NSURL URLWithString:newsModel.picture]
                     placeholderImage:[UIImage imageNamed:@"placeholder_big"]
                              options:SDWebImageDelayPlaceholder
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (cacheType == 1 || cacheType == 2) {return;} // 0新下载，1磁盘缓存，2内存缓存
                                self.bigImage.alpha = 0;
                                [UIView animateWithDuration:0.5 animations:^{
                                    self.bigImage.alpha = 1;
                                }];
                            }
     ];
}

#pragma mark - 图片轮播
/** 设置轮播图 */
- (void)setupCycleImageCell:(ZZChapterModel *)newsModel
{
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleImageView.bounds delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_big"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    [cycleScrollView setBannerImageViewContentMode:UIViewContentModeScaleAspectFill];
    cycleScrollView.titlesGroup = ({
        NSMutableArray *titleArrayM = [NSMutableArray array];
        for (int i = 0; i < newsModel.pics.count; i++) {
            [titleArrayM addObject:((ZZChapterModel*)newsModel.pics[i]).title];
        }
        
        titleArrayM;
    });
    
    cycleScrollView.imageURLStringsGroup = ({
        NSMutableArray *urlArrayM = [NSMutableArray array];
        for (int i = 0; i < newsModel.pics.count; i++) {
            [urlArrayM addObject:((ZZChapterModel*)newsModel.pics[i]).picture];
        }
        
        urlArrayM;
    });
    
    [self.cycleImageView addSubview:cycleScrollView];
    cycleScrollView.delegate = self;
}

/** SDCycleScrollView轮播点击事件代理 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSAssert(self.cycleImageClickBlock, @"必须传入self.cycleImageClickBlock");
    self.cycleImageClickBlock(index);
}

-(void)buttonClick:(UIButton *) btn{
    NSAssert(self.onItemClickBlock, @"必须传入self.onItemClickBlock");
    self.onItemClickBlock(btn.tag);
}


#pragma mark - cell相关
+ (NSString *)cellReuseID:(ZZChapterModel *)newsModel
{
    // 接口中，ads 和 imgextra 可能共同出现，所以有ads的就直接弄成轮播。
    if (!is_null(newsModel.pics)) {
        return @"NewsCycleImageCell"; // 轮播
    } else {
        return @"News_L_img_R_text_Cell"; // 左图右字
    }
}

+ (CGFloat)cellForHeight:(ZZChapterModel *)newsModel
{
    if (!is_null(newsModel.pics)) {
        return 210;
    } else {
        return 120;
    }
}
@end
