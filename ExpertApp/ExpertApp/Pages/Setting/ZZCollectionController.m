//
//  ZZCollectionController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCollectionController.h"

#import "UIView+Extension.h"
#import <MJRefresh.h>

#import "ZZChapterUserCell.h"
#define cellIdentifier @"ZZChapterUserCell"

#import "SVWebViewController.h"
#import "ZZCommentController.h"


@interface ZZCollectionController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;


@end

@implementation ZZCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    
    
    
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
        NSArray *dicts = @[@{@"title":@"标题啊啊啊啊2",@"digest":@"描述嘻嘻嘻嘻嘻嘻想",@"url":@"http://www.baidu.com",@"imgsrc":@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=99bd7ae7a551f3ded7bfb127fc879a6a/b58f8c5494eef01f3e82aae8eafe9925bc317d0c.jpg"},
                           @{@"title":@"标题啊啊啊啊3",@"digest":@"描述嘻嘻嘻嘻嘻嘻想",@"url":@"http://www.baidu.com",@"imgsrc":@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=99bd7ae7a551f3ded7bfb127fc879a6a/b58f8c5494eef01f3e82aae8eafe9925bc317d0c.jpg"},
                           @{@"title":@"标题啊啊啊啊4",@"digest":@"描述嘻嘻嘻嘻嘻嘻想",@"url":@"http://www.baidu.com",@"imgsrc":@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=99bd7ae7a551f3ded7bfb127fc879a6a/b58f8c5494eef01f3e82aae8eafe9925bc317d0c.jpg"},
                           @{@"title":@"标题啊啊啊啊5",@"digest":@"描述嘻嘻嘻嘻嘻嘻想",@"url":@"http://www.baidu.com",@"imgsrc":@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=99bd7ae7a551f3ded7bfb127fc879a6a/b58f8c5494eef01f3e82aae8eafe9925bc317d0c.jpg"}];
        for (NSDictionary *item in dicts) {
            
            [_listArray addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
        }
        
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
    ZZChapterModel *newsModel = _listArray[indexPath.section];
    ZZChapterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.chapterModel = newsModel;
    
    [cell setOnItemClickBlock:^(ZZChapterCellClickTag tag){
        if(tag == ZZChapterCellClickTagSend){
            // 转发
        }
        if(tag == ZZChapterCellClickTagCollect){
            // 收藏
        }
        if(tag == ZZChapterCellClickTagComment){
            // 评论
            ZZCommentController *vc = [[ZZCommentController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
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
    ZZChapterUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor lightGrayColor];
    
    if(indexPath.section== _listArray.count-1){
        [self setTableSeparatorInset];
    }
    // 记录是否已读
    // [[DDNewsCache sharedInstance] addObject:cell.titleLabel.text];
    
    ZZChapterModel *newsModel = _listArray[indexPath.section];
    //    if (newsModel.photosetID) {
    //        DDPhotoDetailController *photoVC = [[DDPhotoDetailController alloc] initWithPhotosetID:newsModel.photosetID];
    //        photoVC.replyCount = newsModel.replyCount;
    //        photoVC.wantsNavigationBarVisible = NO;
    //        photoVC.hidesBottomBarWhenPushed = YES;
    //        [self.navigationController pushViewController:photoVC animated:YES];
    //    } else {
    // NSLog(@"newsModel.url = %@", newsModel.url); // http://3g.163.com/ntes/16/0315/21/BI7TE54L00963VRO.html
    // NSLog(@"newsModel.docid = %@", newsModel.docid); // BI7TE54L00963VRO
    SVWebViewController *NewsDetailC = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:newsModel.picture]];
    //        NewsDetailC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:NewsDetailC animated:YES];
    //    }
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
