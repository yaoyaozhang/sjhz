//
//  ZZDoctorChapterController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorChapterController.h"
#import "ZZChapterTVC.h"

@interface ZZDoctorChapterController ()


@property (nonatomic, strong) ZZChapterTVC *newsTVC;

@end

@implementation ZZDoctorChapterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"文章列表" forState:UIControlStateNormal];
    self.menuRightButton.hidden = YES;
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZZChapterTVC" bundle:nil];
    _newsTVC = [sb instantiateInitialViewController];
    _newsTVC.preVC = self;
    _newsTVC.view.frame = CGRectMake(0, NavBarHeight + 10, ScreenWidth, ScreenHeight - NavBarHeight - 10);
    _newsTVC.urlString = @"";
    
    [self.view addSubview:_newsTVC.view];
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
