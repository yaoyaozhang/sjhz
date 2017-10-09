//
//  ZZChapterTVC.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterTVC.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZChapterCell.h"
#import "SVWebViewController.h"
#import "ZZCommentController.h"
#import "ZZChapterDetailController.h"
#import "ZZShareView.h"

@interface ZZChapterTVC ()

@property (nonatomic, strong) NSMutableArray *dataList;


@end

@implementation ZZChapterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 把小菊花漏出来
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    if(iOS7){
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    _dataList = [NSMutableArray arrayWithCapacity:0];
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    
    [self.tableView.header beginRefreshing];
}


/** 下拉刷新 */
- (void)refreshData
{
    
    // 获取tid来拼接urlString
    [self loadMoreData];
}

/** 上拉加载 */
- (void)loadMoreData
{
    // 获取tid来拼接urlString
    [ZZRequsetInterface get:API_getChapterList start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([self.tableView.header isRefreshing]){
            [self.tableView.header endRefreshing];
        }
        if([self.tableView.footer isRefreshing]){
            [self.tableView.footer endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        if([self.tableView.header isRefreshing]){
            [[self dataList] removeAllObjects];
        }
        
        if(dict[@"retData"][@"pic"]){
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSDictionary *item in dict[@"retData"][@"pic"]) {
                [arr addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
            ZZChapterModel *topModel = [ZZChapterModel new];
            topModel.pics = arr;
            [_dataList addObject:topModel];
        }
        for (NSDictionary *item in dict[@"retData"][@"news"]) {
            [_dataList addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
        }
        
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
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
    ZZChapterModel *newsModel = self.dataList[indexPath.section];
    ZZChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZChapterCell cellReuseID:newsModel] forIndexPath:indexPath];
    cell.chapterModel = newsModel;
    [self setupCycleImageClickWithCell:cell newsModel:newsModel];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZChapterModel *newsModel = self.dataList[indexPath.section];

    return [ZZChapterCell cellForHeight:newsModel];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    	NSLog(@"%s  %zd", __func__,indexPath.row);
    //	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //	cell.textLabel.textColor = [UIColor lightGrayColor];
    // 记录是否已读
    // [[DDNewsCache sharedInstance] addObject:cell.titleLabel.text];
    
    ZZChapterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.titleLabel.textColor = [UIColor lightGrayColor];
    
    if(indexPath.section== _dataList.count-1){
        [self setTableSeparatorInset];
    }
    
    ZZChapterModel *newsModel = cell.chapterModel;
    
    ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
    NewsDetailC.model = newsModel;
    [self.navigationController pushViewController:NewsDetailC animated:YES];
}

#pragma mark -
- (void)enterBackGround
{
//    [[DDNewsCache sharedInstance] removeAllObjects];
}


/** 轮播点击事件 */
- (void)setupCycleImageClickWithCell:(ZZChapterCell *)cell newsModel:(ZZChapterModel *)newsModel
{
    cell.cycleImageClickBlock = ^(NSInteger idx){
        NSLog(@"%zd",idx);
        ZZChapterModel *pmodel = newsModel.pics[idx];
        
        ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
        NewsDetailC.model = pmodel;
        [self.navigationController pushViewController:NewsDetailC animated:YES];
    };
    
    
    cell.onItemClickBlock = ^(ZZChapterCellClickTag tag) {
        if(tag == ZZChapterCellClickTagSend){
            // 转发
            ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeChapter vc:self];
            shareView.shareModel = newsModel;
            [shareView show];
        }
        if(tag == ZZChapterCellClickTagCollect){
            // 收藏
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:convertToString(@"1") forKey:@"collectiontType"];
            [dict setObject:convertIntToString(newsModel.nid) forKey:@"nid"];
            [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"uid"];
            [ZZRequsetInterface post:API_CollectChapter param:dict timeOut:HttpGetTimeOut start:^{
                
            } finish:^(id response, NSData *data) {
                NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                newsModel.chickLikeNum = newsModel.chickLikeNum + 1;
                [self.tableView reloadData];
            } complete:^(NSDictionary *dict) {
                newsModel.chickLikeNum = newsModel.chickLikeNum + 1;
                [self.tableView reloadData];
                [self.view makeToast:@"收藏成功!"];
            } fail:^(id response, NSString *errorMsg, NSError *connectError) {
                [self.view makeToast:errorMsg];
            } progress:^(CGFloat progress) {
                
            }];
        }
        if(tag == ZZChapterCellClickTagComment){
            // 评论
            ZZCommentController *vc = [[ZZCommentController alloc] init];
            vc.nid = newsModel.nid;
            vc.model = newsModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:inset];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:inset];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end