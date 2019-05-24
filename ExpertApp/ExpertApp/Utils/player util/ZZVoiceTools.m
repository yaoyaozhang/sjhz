//
//  ZZVoiceTools.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/24.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZVoiceTools.h"
#import "ExpertApp-Swift.h"


static ZZVoiceTools * mp = nil;


@interface ZZVoiceTools()<ZZVideoViewDelegate>{
    
}


@property(nonatomic,strong) ZZVoiceView *zzvoiceView;


@end


@implementation ZZVoiceTools


// 单例方法
+(instancetype)shareVoiceTools
{
    if (mp == nil) {
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            mp = [[ZZVoiceTools alloc] init];
        });
    }
    return mp;
}

// 这里为什么要重写init方法呢?
// 因为,我们应该得到 "某首歌曲播放结束" 这一事件,之后由外界来决定"播放结束之后采取什么操作".
// AVPlayer并没有通过block或者代理向我们返回这一状态(事件),而是向通知中心注册了一条通知(AVPlayerItemDidPlayToEndTimeNotification),我们也只有这一条途径获取播放结束这一事件.
// 所以,在我们创建好一个播放器时([[AVPlayer alloc] init]),应该立刻为通知中心添加观察者,来观察这一事件的发生.
// 这个动作放到init里,最及时也最合理.
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}



-(void)show:(int)type sFrame:(CGRect)f1 fullFrame:(CGRect)f2{
    [self setupView];
    _zzvoiceView.model = _model;
    _zzvoiceView.viewController = _viewController;
    [_zzvoiceView setSimpleFrame:f1];
    [_zzvoiceView setFullScreenFrame:f2];
    _zzvoiceView.curIndex = convertIntToString(_curIndex);
    _zzvoiceView.listArray = _list;
    
    if(type == 1){
     
        [_zzvoiceView showSimpleView];
    }else{
        [_zzvoiceView showViewAllFull];
    }
    _zzvoiceView.hidden = NO;
    
    [_zzvoiceView startPlay];
    
}

-(void)hideAllView{
    _zzvoiceView.hidden = true;
}

-(void)show:(int)type{
    
    [self show:type sFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50) fullFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}

-(void)stopPlayer{
    [_zzvoiceView dissmisView];
    [_zzvoiceView removeFromSuperview];
    
}

-(void)setupView{
    if(_zzvoiceView){
        [_zzvoiceView removeFromSuperview];
    }
    
    _zzvoiceView = [[ZZVoiceView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50)];
    _zzvoiceView.clipsToBounds = true;
    _zzvoiceView.hidden = YES;
    _zzvoiceView.voiceDelegate = self;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_zzvoiceView];
}


- (void)dissmiss{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = ScreenHeight;
    _zzvoiceView.frame = sheetViewF;
    
    [_zzvoiceView removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        
        if(_onDissmisBlock){
            _onDissmisBlock();
        }
        
    } completion:^(BOOL finished) {
    }];
}


-(void)mmVoiceViewDissmis:(BOOL )isPause{
    if(!isPause){
        [self dissmiss];
    }
}


@end
