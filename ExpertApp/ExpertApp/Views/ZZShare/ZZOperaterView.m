//
//  ZZOperaterView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/5/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZOperaterView.h"
#import <UShareUI/UShareUI.h>
#import "UIButtonUpDown.h"

#import "ZZUserHomeModel.h"
#import "ZZChapterModel.h"
#import "ZZHZEngity.h"
#import "ZZQSModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <WXApi.h>
#import "ZZShareView.h"

#import "ZZCommentController.h"
#import "AppDelegate.h"

@interface ZZOperaterView(){
    ZZOperaterType zzShareType;
}

@property(nonatomic,strong) UIViewController *curVC;
@property(nonatomic,assign) ZZOperaterType type;
@property(nonatomic,strong) UIView *bottomView;

@end


@implementation ZZOperaterView

-(instancetype)initWithShareType:(UIViewController *)vc{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
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
    CGFloat itemW = (ScreenWidth-84 - 30)/3;
    CGFloat x = 42 + (i-1)*itemW + (i-1)*10;
    UIButtonUpDown *btn = [UIButtonUpDown buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(x, y, itemW, 78)];
    [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [btn.titleLabel setFont:ListTimeFont];
    [btn addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn];
    
    if(i==1){
        [btn setImage:[UIImage imageNamed:@"my_recommend"] forState:UIControlStateNormal];
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        btn.tag = ZZOperaterTypeShare;
    }else if(i==2){
        [btn setImage:[UIImage imageNamed:@"btn_collect"] forState:UIControlStateNormal];
        [btn setTitle:@"收藏" forState:UIControlStateNormal];
        btn.tag = ZZOperaterTypeCollect;
    }else if(i==3){
        [btn setImage:[UIImage imageNamed:@"btn_comment"] forState:UIControlStateNormal];
        [btn setTitle:@"评论" forState:UIControlStateNormal];
        btn.tag = ZZOperaterTypeComment;
    }
}

-(void)shareWithButton:(UIButtonUpDown *) shareButton{
    ZZChapterModel *newsModel = (ZZChapterModel *)_operatorModel;
    ZZOperaterType tag = shareButton.tag;
    
    if(tag == ZZOperaterTypeShare){
        // 转发
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeChapter vc:_curVC];
        shareView.shareModel = newsModel;
        [shareView show];
        
        [self dissmisMenu];
    }
    if(tag == ZZOperaterTypeCollect){
        // 收藏
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(newsModel.collect){
            [dict setObject:convertToString(@"0") forKey:@"collectiontType"];
        }else{
            [dict setObject:convertToString(@"1") forKey:@"collectiontType"];
        }
        [dict setObject:convertIntToString(newsModel.nid) forKey:@"nid"];
        [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"uid"];
        [ZZRequsetInterface post:API_CollectChapter param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            
            [self dissmisMenu];
        } complete:^(NSDictionary *dict) {
            if(newsModel.collect){
                [[self getRootView] makeToast:@"取消收藏成功!"];
            }else{
                [[self getRootView] makeToast:@"收藏成功!"];
            }
            
            newsModel.collect = !newsModel.collect;
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [[self getRootView] makeToast:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
    if(tag == ZZOperaterTypeComment){
        // 评论
        ZZCommentController *vc = [[ZZCommentController alloc] init];
        vc.nid = newsModel.nid;
        vc.model = newsModel;
        
        
        [[((AppDelegate *)[UIApplication sharedApplication].delegate) getCurVC].navigationController pushViewController:vc animated:YES];
        
        
        [self dissmisMenu];
    }
}

-(UIView *) getRootView{
    return [((AppDelegate *)[UIApplication sharedApplication].delegate) getCurVC].view;
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
