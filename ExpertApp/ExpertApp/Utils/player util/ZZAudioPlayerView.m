//
//  ZZAudioPlayerView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZAudioPlayerView.h"

// 按钮区域的view高度
#define bgViewHight   25
#define ZCScreenScale          (ScreenWidth / 375.0f)
#define ZCNumber(num)          (num*ZCScreenScale)
@interface ZZAudioPlayerView()
{
    UIView   *_bgView;
    UISlider *_progressSlider;
}

@property (nonatomic,strong)  UILabel * currentTimeLab ; // 当前时间

@property (nonatomic,strong)  UILabel * allTimeLab; // 总时间

@property(nonatomic,strong) AVPlayer *player;//播放器

@property(nonatomic,strong) UISlider *progressSlider;//用于显示(控制)视频的播放进度

@property(nonatomic,strong) UIButton *playBtn;

@property(nonatomic,strong) UIButton * backBtn;

-(void)uiConfigWith:(CGRect)bframe;


@end

@implementation ZZAudioPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self uiConfigWith:frame];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageClick:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
    }
    return self;
}


-(void)uiConfigWith:(CGRect)bframe
{
    self.backgroundColor=[UIColor blackColor];
    
    // 返回按钮
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(15, StatusBarHeight, 50, 44)];
    [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backBtn];
    
    
    // 添加按钮和进度条
    _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, bframe.size.height- ZCNumber(54) - bgViewHight, bframe.size.width, bgViewHight)];
    _bgView.backgroundColor=[UIColor clearColor];
    [self addSubview:_bgView];
    
    //播放暂停按钮
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setFrame:CGRectMake(20 ,3,14,20)];
    _playBtn.backgroundColor=[UIColor clearColor];
    _playBtn.selected=YES;
    
    [_playBtn setImage:[UIImage imageNamed:@"play"]  forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_playBtn];
    
    
    _currentTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_playBtn.frame) + 20, 3, 40, 21)];
    _currentTimeLab.textColor = UIColorFromRGB(0xFFFFFF);
    _currentTimeLab.text = @"00:00";
    _currentTimeLab.font = [UIFont systemFontOfSize:12];
    [_bgView addSubview:_currentTimeLab];
    
    
    
    _progressSlider= [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_currentTimeLab.frame) + ZCNumber(20),0,bframe.size.width - CGRectGetMaxX(_currentTimeLab.frame) - ZCNumber(20) - 45 - 20 - ZCNumber(20),bgViewHight)];
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = 1.0;
    _progressSlider.minimumTrackTintColor = [UIColor orangeColor];
    _progressSlider.maximumTrackTintColor = [UIColor lightGrayColor];
    _progressSlider.thumbTintColor = [UIColor orangeColor];
    [_progressSlider addTarget:self action:@selector(progressChange:) forControlEvents:UIControlEventValueChanged];
    [_bgView addSubview:_progressSlider];
    
    _allTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_progressSlider.frame) + ZCNumber(20), 3, 40, 21)];
    _allTimeLab.textColor = UIColorFromRGB(0xFFFFFF);
    _allTimeLab.font = [UIFont systemFontOfSize:12];
    _allTimeLab.text = @"00:00";
    [_bgView addSubview:_allTimeLab];
    
    
}

//每个视图都对应一个层，改变视图的形状、动画效果\与播放器的关联等，都可以在层上操作
//播放器支持的播放格式:mp4、mov(iPhone手机录制视频的默认格式) avi
-(void)setPlayer:(AVPlayer *)myPlayer
{
    AVPlayerLayer *playerLayer=(AVPlayerLayer *)self.layer;
    [playerLayer setPlayer:myPlayer];
}


//在调用视图的layer时，会自动触发layerClass方法，重写它，保证返回的类型是AVPlayerLayer
+(Class)layerClass
{
    return [AVPlayerLayer class];
}

-(void)playWith:(NSURL *)url
{
    // 支持后台播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 激活
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    // 开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    AVPlayerItem *currentPlayerItem = [AVPlayerItem playerItemWithURL:url];
    _player = [[AVPlayer alloc] initWithPlayerItem:currentPlayerItem];
    
    
}


#pragma mark -------BtnClick---------
-(void)playBtnClick:(UIButton *)btn
{
    if (btn.selected==YES) { //暂停按钮被点击
        
        if (_player) {
            [_player pause];
        }
        btn.selected=NO;
        return;
    }
    
    //播放按钮被点击
    if (_player) {
        [_player play];
    }
    btn.selected=YES;
    return;
}
-(void)progressChange:(UISlider *)sl
{
    //通过进度条控制播放进度
    if (!_player) {
        return;
    }
    CMTime dur = _player.currentItem.duration;
    float current = _progressSlider.value;
    //CMTimeMultiplyByFloat64 将总时长，当前进度，转化成为CMTime
    //seekToTime 跳转到指定的时间
    [_player seekToTime:CMTimeMultiplyByFloat64(dur, current)];
}

//销毁player
-(void)releasePlayer
{
    if (_player) {
        [_player pause];
        _player=nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    for(int i=0;i<[_bgView.subviews count];i++)
    {
        UIView *view=[_bgView.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view=nil;
        i--;
    }
    [_bgView removeFromSuperview];
    _bgView=nil;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


-(void)nextPlay:(NSURL *) url{
    if (_player){
        AVPlayerItem *currentPlayerItem = [AVPlayerItem playerItemWithURL:url];
        
        //[_player replaceCurrentItemWithPlayerItem:_currentPlayerItem];
        _player = [[AVPlayer alloc] initWithPlayerItem:currentPlayerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [_player play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        
    }

}

#pragma mark ------Notification-------
-(void)moviePlayDidEnd:(NSNotification*)notification
{
    NSLog(@"视频播放完毕！");
    
    CMTime dur = _player.currentItem.duration;
    //CMTimeMultiplyByFloat64 将总时长，当前进度，转化成为CMTime
    //seekToTime 跳转到指定的时间
    [_player seekToTime:CMTimeMultiplyByFloat64(dur, 0)];
    if (_player) {
        [_player pause];
    }
    _playBtn.selected=NO;
}

-(void)pageClick:(UITapGestureRecognizer *) tap{
    _bgView.hidden = !_bgView.hidden;
}

-(void)showInWindow{
    [self setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(void)dissmissInWindow{
    [self releasePlayer];
    [self removeFromSuperview];
}

#pragma mark -- 时间转换
-(NSString *)timeFromSeconds:(NSInteger)seconds
{
    int m = (int)seconds/60;
    int s = seconds%60;
    NSString *mString ;
    NSString *sString ;
    if (m<10)
        mString =[NSString stringWithFormat:@"%d",m];
    else
        mString =[NSString stringWithFormat:@"%d",m];
    
    if (s<10)
        sString =[NSString stringWithFormat:@"0%d",s];
    else
        sString =[NSString stringWithFormat:@"%d",s];
    
    return  [NSString stringWithFormat:@"%@:%@",mString,sString];
    
}


-(void)backAction{
    [self dissmissInWindow];
}

@end
