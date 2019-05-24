//
//  ZZKnowledgeSegmentController.m
//  ExpertApp
//
//  Created by 张新耀 on 2019/5/22.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import "ZZKnowledgeSegmentController.h"

#import "ZZKnowledgeHomeController.h"
#import "ZZKnowledgeCollegeListController.h"
#import "UIView+Border.h"

@interface ZZKnowledgeSegmentController (){
    
    int checkTag;
    
    UIScrollView *_mainScroll;
    CGFloat w;
    CGFloat h;
    CGFloat mh;
    int showPage;
    CGFloat scrollHeight;
    
    ZZKnowledgeHomeController *homeVC;
    ZZKnowledgeCollegeListController *centerVC ;
    ZZKnowledgeCollegeListController *rightVC;
    
    int queueUpCount;
    
    UIButton *btnSegmentLeft;
    UIButton *btnSegmentRight;
    UIButton *btnSegmentCenter;
}

@end

@implementation ZZKnowledgeSegmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self InitViewConfig];
}


-(IBAction)changePage:(UIButton *) sender{
    if(sender.tag == 1){
        [_mainScroll scrollRectToVisible:CGRectMake(0,NavBarHeight, w, h-NavBarHeight - mh) animated:NO];
        [homeVC beginNetRefreshData];
        
        btnSegmentCenter.selected = NO;
        btnSegmentRight.selected = NO;
        btnSegmentLeft.selected = YES;
        [btnSegmentRight setBackgroundColor:[UIColor clearColor]];
        [btnSegmentCenter setBackgroundColor:[UIColor clearColor]];
        [btnSegmentLeft setBackgroundColor:[UIColor whiteColor]];
        
        
    }else if(sender.tag == 2){
        [_mainScroll scrollRectToVisible:CGRectMake(w,NavBarHeight, w, h-NavBarHeight - mh) animated:NO];
        [centerVC toggleData];
        
        btnSegmentCenter.selected = YES;
        btnSegmentRight.selected = NO;
        btnSegmentLeft.selected = NO;
        [btnSegmentRight setBackgroundColor:[UIColor clearColor]];
        [btnSegmentCenter setBackgroundColor:[UIColor whiteColor]];
        [btnSegmentLeft setBackgroundColor:[UIColor clearColor]];
        
    }else if(sender.tag == 3){
        [_mainScroll scrollRectToVisible:CGRectMake(2*w,NavBarHeight, w, h-NavBarHeight - mh) animated:NO];
        [rightVC toggleData];
        
        btnSegmentCenter.selected = NO;
        btnSegmentRight.selected = YES;
        btnSegmentLeft.selected = NO;
        [btnSegmentRight setBackgroundColor:[UIColor whiteColor]];
        [btnSegmentCenter setBackgroundColor:[UIColor clearColor]];
        [btnSegmentLeft setBackgroundColor:[UIColor clearColor]];
    }
}


/**
 *  初始化View属性，配置
 */
-(void)InitViewConfig{
    
    h = self.view.frame.size.height;
    w = self.view.frame.size.width;
    
    UIView *titleMenu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    [titleMenu setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [titleMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:titleMenu];
    
    
    UIView *segmentView = [[UIView alloc] initWithFrame:CGRectMake(w/2-150,NavBarHeight-30-6 , 300, 30)];
    [segmentView setBackgroundColor:[UIColor clearColor]];
    segmentView.layer.borderColor = UIColorFromRGB(TextWhiteColor).CGColor;
    segmentView.layer.cornerRadius = 5.0f;
    segmentView.layer.borderWidth = 1.0f;
    segmentView.layer.masksToBounds = YES;
    [self.view addSubview:segmentView];
    
    btnSegmentLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSegmentLeft setFrame:CGRectMake(0, 0 , 100, 30)];
    btnSegmentLeft.tag = 1;
    [btnSegmentLeft.titleLabel setFont:ListTitleFont];
    [btnSegmentLeft addRightBorderWithColor:UIColorFromRGB(TextWhiteColor) andWidth:1.0f];
    [btnSegmentLeft setTitle:@"知识" forState:UIControlStateNormal];
    [btnSegmentLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSegmentLeft setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateSelected];
    [btnSegmentLeft setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateHighlighted];
    [btnSegmentLeft addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:btnSegmentLeft];
    
    
    btnSegmentCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSegmentCenter setFrame:CGRectMake(100, 0 , 100, 30)];
    btnSegmentCenter.tag = 2;
    [btnSegmentCenter.titleLabel setFont:ListTimeFont];
    [btnSegmentCenter addRightBorderWithColor:UIColorFromRGB(TextWhiteColor) andWidth:1.0f];
    [btnSegmentCenter setTitle:@"MSEP-CPX学院" forState:UIControlStateNormal];
    [btnSegmentCenter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSegmentCenter setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateSelected];
    [btnSegmentCenter setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateHighlighted];
    [btnSegmentCenter addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:btnSegmentCenter];
    
    
    btnSegmentRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSegmentRight setFrame:CGRectMake(200, 0, 100, 30)];
    btnSegmentRight.tag = 3;
    [btnSegmentRight.titleLabel setFont:ListTitleFont];
    [btnSegmentRight setTitle:@"长者运动学院" forState:UIControlStateNormal];
    [btnSegmentRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSegmentRight setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateSelected];
    [btnSegmentRight setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateHighlighted];
    [btnSegmentRight addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [segmentView addSubview:btnSegmentRight];
    
    
    scrollHeight = ScreenHeight - NavBarHeight - TabBarHeight;
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, w, scrollHeight)];
    [_mainScroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_mainScroll];
    
    [_mainScroll setContentSize:CGSizeMake(w*3, scrollHeight)];
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.alwaysBounceHorizontal = NO;
    _mainScroll.alwaysBounceVertical = NO;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.bounces = NO;
    _mainScroll.scrollEnabled = NO;
    
    homeVC =[[ZZKnowledgeHomeController alloc] init];
    [homeVC.view setFrame:CGRectMake(0, 0, w, scrollHeight)];
    homeVC.preVC = self;
    [_mainScroll addSubview:homeVC.view];
    
    
    centerVC =[[ZZKnowledgeCollegeListController alloc] init];
    centerVC.dataType = 1;
    centerVC.preVC = self;
    [centerVC.view setFrame:CGRectMake(w, 0, w, scrollHeight)];
    [centerVC.view setBackgroundColor:[UIColor clearColor]];
    [_mainScroll addSubview:centerVC.view];
    
    
    
    rightVC =[[ZZKnowledgeCollegeListController alloc] init];
    rightVC.dataType = 2;
    rightVC.preVC = self;
    [rightVC.view setFrame:CGRectMake(w*2, 0, w, scrollHeight)];
    [rightVC.view setBackgroundColor:[UIColor clearColor]];
    [_mainScroll addSubview:rightVC.view];
    
    [self changePage:btnSegmentLeft];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
