//
//  ZZDrawMoneyController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/28.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDrawMoneyController.h"

@interface ZZDrawMoneyController ()

@end

@implementation ZZDrawMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"提现管理" forState:UIControlStateNormal];
    
    
    [self createPlaceholderView:nil message:@"请进入后台绑定好银行卡号进行提现操作" image:nil withView:self.view action:nil];
    
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
