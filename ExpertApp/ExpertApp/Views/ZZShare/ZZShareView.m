//
//  ZZShareView.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZShareView.h"
#import <UShareUI/UShareUI.h>
#import "UIButtonUpDown.h"

#import "ZZUserHomeModel.h"
#import "ZZChapterModel.h"
#import "ZZHZEngity.h"
#import <WXApi.h>

@interface ZZShareView(){
    ZZShareType zzShareType;
}

@property(nonatomic,strong) UIViewController *curVC;
@property(nonatomic,assign) ZZShareType type;
@property(nonatomic,strong) UIView *bottomView;

@end


@implementation ZZShareView

-(instancetype)initWithShareType:(ZZShareType)type vc:(UIViewController *)vc{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
        _type = type;
        _curVC = vc;
        self.backgroundColor = [UIColor clearColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisMenu)];
        [self addGestureRecognizer:tap];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-180, ScreenWidth, 180)];
        _bottomView.backgroundColor = UIColorFromRGBAlpha(TextBlackColor, 0.7);
        [self addSubview:_bottomView];
        
        
        [self createShareButton:1];
        [self createShareButton:2];
        [self createShareButton:3];
        [self createShareButton:4];
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setFrame:CGRectMake(ScreenWidth/2-22, 180-64, 44, 44)];
        [btnClose setImage:[UIImage imageNamed:@"share_close"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(dissmisMenu) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btnClose];
    }
    
    return self;
}

-(void)createShareButton:(int) i{
    CGFloat y = 20;
    CGFloat itemW = (ScreenWidth-84 - 30)/4;
    CGFloat x = 42 + (i-1)*itemW + (i-1)*10;
    UIButtonUpDown *btn = [UIButtonUpDown buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(x, y, itemW, 78)];
    [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [btn.titleLabel setFont:ListTimeFont];
    [btn addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn];
    
    if(i==1){
        [btn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
        [btn setTitle:@"微信好友" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_WechatSession;
    }else if(i==2){
        [btn setImage:[UIImage imageNamed:@"share_wechat_circle"] forState:UIControlStateNormal];
        [btn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_WechatTimeLine;
    }else if(i==3){
        [btn setImage:[UIImage imageNamed:@"share_sina"] forState:UIControlStateNormal];
        [btn setTitle:@"新浪微博" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_Sina;
    }else if(i==4){
        [btn setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
        [btn setTitle:@"QQ好友" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_QQ;
    }
}

-(void)shareWithButton:(UIButtonUpDown *) shareButton{
    UMSocialPlatformType shareType = shareButton.tag;
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareObject *shareObject;
    if(_type == ZZShareTypeUser){
        ZZUserInfo *userModel = (ZZUserInfo *)_shareModel;
        if([@"" isEqual:convertToString(userModel.docName)]){
            userModel.docName = convertToString(userModel.accomplished);
        }
        shareObject = [UMShareObject shareObjectWithTitle:userModel.docName descr:convertToString(userModel.userName) thumImage:userModel.imageUrl];
        shareObject.thumbImage = convertToString(@"https://static.pgyer.com/static-20171115/images/newHome/header_marker.png");
        
        messageObject.text = shareObject.descr;
        messageObject.title = shareObject.title;
        
        // 必须为视频
//        messageObject.shareObject = shareObject;
    }else if(_type == ZZShareTypeChapter){
        ZZChapterModel *model = (ZZChapterModel *)_shareModel;
        shareObject = [UMShareObject shareObjectWithTitle:model.author descr:model.title thumImage:model.picture];
        shareObject.thumbImage = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
        
        messageObject.text = shareObject.descr;
        messageObject.title = shareObject.title;
        
        //分享消息对象设置分享内容对象
        UMShareVideoObject *shareObject1 =[UMShareVideoObject shareObjectWithTitle:convertToString(shareObject.title) descr:convertToString(shareObject.descr) thumImage:convertToString(shareObject.thumbImage)];
        //        shareObject1.videoUrl = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
        
        //    UMShareImageObject *share1 = [UMShareImageObject shareObjectWithTitle:convertToString(shareObject.title) descr:convertToString(shareObject.descr) thumImage:convertToString(shareObject.thumbImage)];
        shareObject1.videoUrl = shareObject.thumbImage;
        
        messageObject.shareObject = shareObject1;
    }else if(_type == ZZShareTypeHZResult){
        ZZHZEngity *model = (ZZHZEngity *)_shareModel;
        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
        
        messageObject.text = shareObject.descr;
        messageObject.title = shareObject.title;
        
//        messageObject.shareObject = shareObject;
    }
    
    
    messageObject.moreInfo = @{@"name":@"userHome"};
    
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:_curVC completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [_curVC.view makeToast:@"分享失败！"];
        }else{
            NSLog(@"response data is %@",data);
            [_curVC.view makeToast:@"分享成功！"];
        }
    }];
    
    if(![[UMSocialManager defaultManager] isInstall:shareType]){
        [self dissmisMenu];
    }
}



- (void)dissmisMenu{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = sheetViewF;
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}

@end
