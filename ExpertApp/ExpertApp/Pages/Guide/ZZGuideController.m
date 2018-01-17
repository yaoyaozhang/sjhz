//
//  ZZGuideController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZGuideController.h"
#import "ZZGuideView.h"

#import "ZZLoginController.h"
#import "ViewController.h"

@interface ZZGuideController ()<UIScrollViewDelegate>
@property (nonatomic,strong) ZZGuideView *guideView;


@end


@implementation ZZGuideController


#pragma mark - 设置自定义视图
- (void)loadView{
    self.guideView = [[ZZGuideView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _guideView;
    
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    // 设置scrollerView的代理
    _guideView.scrollView.delegate = self;
    
    // 给pageController 添加点击事件
    [_guideView.pageControl addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
    
    // 给进入按钮绑定时间
    [_guideView.enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - pageController的监听事件
- (void)pageControlAction:(UIPageControl*)sender{
    // 1.获取当前的页面
    NSInteger index = sender.currentPage;
    
    // 2.计算偏移量
    CGPoint offSetPoint = CGPointMake(index *_guideView.scrollView.bounds.size.width, 0);
    
    // 3。将偏移量赋值给scrollerView
    [_guideView.scrollView setContentOffset:offSetPoint animated:YES];
    
    // 判断并且决定是否显示进入按钮
    if(index == 2){
        _guideView.enterButton.hidden = NO;
        
    }else{
        _guideView.enterButton.hidden = YES;
    }
}
#pragma mark- 按钮点击事件
- (void)enterButtonAction:(UIButton*)sender{
    UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController=[stryBoard instantiateInitialViewController];
    // 如果需要设置首先进入登录界面，再展示轮播图注开下面这行代码
    if(![[ZZDataCache getInstance] isLogin]){
        ZZLoginController * login = [[ZZLoginController alloc] initWithNibName:@"ZZLoginController" bundle:nil];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:login];
        nav.navigationBarHidden=YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        [window setRootViewController:nav];
    }
    
}
#pragma mark-UIScrollerViewDelegate Metods
#pragma mark 结束滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 判断当前是第几页
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    // NSLog(@"%ld",index +1);
    
    // 停止滑动后修改“点”的位置
    _guideView.pageControl.currentPage = index;
    // 判断是否显示“进入按钮“
    if(index == 2){
        _guideView.enterButton.hidden = NO;
    }else{
        _guideView.enterButton.hidden = YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
