//
//  ZZGuideView.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZGuideView.h"

@interface ZZGuideView(){
    UIImageView *_imageView;
}

@end


@implementation ZZGuideView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllViews];
    }
    return self;
}
#pragma mark ---- 添加所有视图元素

- (void)addAllViews{
    
    //1.创建UIScrollView对象，并设置大小
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //2.添加
    [self addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    //3.设置内容视图大小
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width*3, _scrollView.bounds.size.height);
    
    //4.添加图片
    for (int i = 0;i<3 ; i++) {
        
        
        if (ScreenHeight == 480 && ScreenWidth == 320 ) {
            NSString *iagName = [NSString stringWithFormat:@"icon_guide%d",i];
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iagName]];
        }else{
            NSString *iagName = [NSString stringWithFormat:@"guide%d",i];
            _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iagName]];
        }
        
        // 设置imageView的位置和大小
        _imageView.frame = CGRectMake(_scrollView.bounds.size.width*i, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
        [_scrollView addSubview:_imageView];
        if (i== 2) {
            [_imageView addSubview:_enterButton];
        }
    }
    // 设置scrollView的整页滑动
    _scrollView.pagingEnabled = YES;
    // 设置滚动条的隐藏
    _scrollView.showsHorizontalScrollIndicator = NO;
    // 设置scrollView的弹动效果
    _scrollView.bounces = NO;
    
    // 添加小点 如果需要添加 注开
    //    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 25, self.bounds.size.width, 30)];
    //    _pageControl.numberOfPages = 3;
    //    [self addSubview:_pageControl];
    
    
    //添加进入按钮
    self.enterButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_enterButton setTitle:@"" forState:UIControlStateNormal];
    _enterButton.frame = CGRectMake(0.3*ScreenWidth, 0.845*ScreenHeight, 150, 40);
    _enterButton.layer.cornerRadius = 10;
    _enterButton.layer.masksToBounds = YES;
    _enterButton.hidden = YES;
    _enterButton.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_enterButton];
}
- (void)dealloc{
    _enterButton = nil;
    _scrollView = nil;
    _pageControl = nil;
}

@end
