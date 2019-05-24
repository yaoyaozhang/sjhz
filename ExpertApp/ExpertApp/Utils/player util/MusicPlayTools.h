//
//  MusicPlayTools.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicInfoModel.h"
#import "MusicLyricModel.h"

// !!! 与block回传值作比较.
// 定义协议. 通过代理方法返回当前歌曲的播放进度.
// 如果外界想使用本播放器,必须遵循和实现协议中的两个方法.
@protocol MusicPlayToolsDelegate <NSObject>
// 外界实现这个方法的同时, 也将参数的值拿走了, 这样我们起到了"通过代理方法向外界传递值"的功能.
-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress totleValue:(NSInteger) total;
// 播放结束之后, 如何操作由外部决定.
-(void)endOfPlayAction;

-(void)startPlayAction;
-(void)pausePlayAction;

@end

@interface MusicPlayTools : NSObject
// 本类中的播放器指针.
@property(nonatomic,strong)AVPlayer * player;

// 代理
@property(nonatomic,weak)id<MusicPlayToolsDelegate> delegate;

// 单例方法
+(instancetype)shareMusicPlay;
// 准备播放
-(void)musicPrePlay:(NSString *) url;

// 播放音乐
-(void)musicPlay;
// 暂停音乐
-(void)musicPause;
// 跳转
-(void)seekToTimeWithValue:(CGFloat)value;

// -15 or 15
-(void)seekToTimeWithCutValue:(CGFloat) value;

-(BOOL)isPlaying;

-(NSInteger)getTotleTime;

@end
