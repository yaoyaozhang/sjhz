//
//  PlayView.h
//  deerkids
//
//  Created by zhangxy on 2017/11/2.
//  Copyright © 2017年 wangzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
PlayView *playView=[[PlayView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
[playView playWith:url];
[self.view addSubview:playView];
*/

@interface PlayView : UIView

-(void)setPlayer:(AVPlayer *)myPlayer;

-(void)playWith:(NSURL *)url;

-(void)releasePlayer;

-(void)showInWindow;

-(void)dissmissInWindow;

-(void)backAction;// 点击返回事件

@end

