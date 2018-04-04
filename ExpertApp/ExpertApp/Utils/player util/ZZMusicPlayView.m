//
//  ZZMusicPlayView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZMusicPlayView.h"

@implementation ZZMusicPlayView

// 初始化
-(instancetype)init{
    if (self = [super init]) {
        // 布局方法
        [self p_setup];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)p_setup
{
    // 1.ScorollView
    self.mainScrollView = [[UIScrollView alloc] init];
    self.mainScrollView.frame = CGRectMake(0, 0,ScreenWidth , ScreenHeight);
    self.mainScrollView.contentSize = CGSizeMake(2*ScreenWidth, CGRectGetHeight(self.mainScrollView.frame));
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.alwaysBounceHorizontal = YES; // 打开水平滚动
    self.mainScrollView.alwaysBounceVertical = NO; // 关闭垂直滚动
    [self addSubview:self.mainScrollView];
    
    // 旋转的CD ImageView
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.mainScrollView.frame));
    self.headImageView.backgroundColor  = [UIColor redColor];
    [self.mainScrollView addSubview:self.headImageView];
    
    // 歌词tableView
    self.lyricTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.mainScrollView.frame)) style:(UITableViewStylePlain)];
    [self.mainScrollView addSubview:self.lyricTableView];
    
    // 当前播放时间
    self.curTimeLabel = [[UILabel alloc] init];
    self.curTimeLabel.frame = CGRectMake(CGRectGetMinX(self.mainScrollView.frame),
                                         CGRectGetMaxY(self.mainScrollView.frame),
                                         60, 30);
    self.curTimeLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.curTimeLabel];
    
    // 播放进度条
    self.progressSlider = [[UISlider alloc] init];
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.curTimeLabel.frame),
                                           CGRectGetMinY(self.curTimeLabel.frame),
                                           ScreenWidth - CGRectGetWidth(self.curTimeLabel.frame)*2, 30);
    [self addSubview:self.progressSlider];
    
    // 总时间
    self.totleTiemLabel = [[UILabel alloc] init];
    self.totleTiemLabel.frame = CGRectMake(CGRectGetMaxX(self.progressSlider.frame),
                                           CGRectGetMinY(self.progressSlider.frame),
                                           CGRectGetWidth(self.curTimeLabel.frame),
                                           CGRectGetHeight(self.curTimeLabel.frame));
    self.totleTiemLabel.backgroundColor = [UIColor greenColor];
    [self addSubview:self.totleTiemLabel];
    
    // 上一首的按钮
    self.lastSongButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.lastSongButton.frame = CGRectMake(CGRectGetMinX(self.curTimeLabel.frame),
                                           ScreenHeight - 30 - 94,
                                           60,
                                           30);
    self.lastSongButton.backgroundColor = [UIColor clearColor];
    [self.lastSongButton setTitle:@"上一首" forState:(UIControlStateNormal)];
    [self addSubview:self.lastSongButton];
    [self.lastSongButton addTarget:self action:@selector(lastSongButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 下一首的按钮
    self.nextSongButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.nextSongButton.frame = CGRectMake(ScreenWidth - CGRectGetWidth(self.lastSongButton.frame),
                                           CGRectGetMinY(self.lastSongButton.frame),
                                           CGRectGetWidth(self.lastSongButton.frame),
                                           CGRectGetHeight(self.lastSongButton.frame));
    self.nextSongButton.backgroundColor = [UIColor clearColor];
    [self.nextSongButton setTitle:@"下一首" forState:(UIControlStateNormal)];
    [self addSubview:self.nextSongButton];
    
    // 播放/暂停的按钮
    self.playPauseButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.playPauseButton.frame = CGRectMake(ScreenWidth/2 - 30,
                                            CGRectGetMinY(self.lastSongButton.frame),
                                            CGRectGetWidth(self.lastSongButton.frame),
                                            CGRectGetHeight(self.lastSongButton.frame));
    self.playPauseButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.playPauseButton];
}

// 这里采用真正的MVC设计模式, 和其他的空间比较一下, 这里将lastButton的处理事件作为代理事件被外部重新实现.
-(void)lastSongButtonAction:(UIButton *)sender
{
    [self.delegate lastSongAction];
}

@end
