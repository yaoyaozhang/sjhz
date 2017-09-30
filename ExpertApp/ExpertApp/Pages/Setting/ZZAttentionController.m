//
//  ZZAttentionController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZAttentionController.h"


#import "UIView+Extension.h"
#import <MJRefresh.h>

#import "ZZDoctorUserCell.h"
#define cellIdentifier @"ZZDoctorUserCell"

@interface ZZAttentionController ()<UITableViewDelegate,UITableViewDataSource>{
    ZZUserInfo *loginUser;
}

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;


@end

@implementation ZZAttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"我的关注" forState:UIControlStateNormal];
    
    loginUser = [self getLoginUser];
    
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    __weak typeof(self) weakSelf = self;
    _listTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    [self refreshData];
}


/** 下拉刷新 */
- (void)refreshData
{
    // 获取tid来拼接urlString
    [ZZRequsetInterface get:@"http://www.baidu.com" start:^{
        
    } finish:^(id response, NSData *data) {
        
        
        [_listTable reloadData];
        [_listTable.header endRefreshing];
        if(_listArray.count < 20){
            [_listTable.footer removeFromSuperview];
        }
    } complete:^(NSDictionary *dict) {
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
    [_listTable.header endRefreshing];
}

/** 上拉加载 */
- (void)loadMoreData
{
    [ZZRequsetInterface get:@"http://www.baidu.com" start:^{
        
    } finish:^(id response, NSData *data) {
        
        [_listTable reloadData];
        [_listTable.footer endRefreshing];
    } complete:^(NSDictionary *dict) {
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section>0){
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZZDoctorUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	NSLog(@"%s", __func__);
    //	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //	cell.textLabel.textColor = [UIColor lightGrayColor];
//    ZZDoctorUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([_listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTable setSeparatorInset:inset];
    }
    
    if ([_listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTable setLayoutMargins:inset];
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
