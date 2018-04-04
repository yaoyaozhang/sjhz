//
//  ZZAudioPlayerView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ZZAudioPlayerView : UIView

-(void)playWith:(NSURL *)url;

-(void)releasePlayer;

-(void)showInWindow;

-(void)dissmissInWindow;

-(void)backAction;// 点击返回事件

@end
