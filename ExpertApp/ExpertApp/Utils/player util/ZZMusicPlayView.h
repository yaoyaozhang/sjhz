//
//  ZZMusicPlayView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZMusicPlayViewDelegate <NSObject>

-(void)lastSongAction;

@end

@interface ZZMusicPlayView : UIView

@property(nonatomic,strong)UIScrollView  * mainScrollView;
@property(nonatomic,strong)UIImageView * headImageView;
@property(nonatomic,strong)UITableView * lyricTableView;
@property(nonatomic,strong)UILabel * curTimeLabel;
@property(nonatomic,strong)UISlider * progressSlider;
@property(nonatomic,strong)UILabel * totleTiemLabel;

@property(nonatomic,strong)UIButton * lastSongButton;
@property(nonatomic,strong)UIButton * playPauseButton;
@property(nonatomic,strong)UIButton * nextSongButton;

@property(nonatomic,weak)id<ZZMusicPlayViewDelegate>delegate;

@end
