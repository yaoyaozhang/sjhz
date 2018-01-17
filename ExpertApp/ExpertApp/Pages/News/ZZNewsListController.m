//
//  ZZNewsListController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNewsListController.h"
#import "ZZNewsCell.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#define cellIdentifier @"ZZNewsCell"
#import "UIView+Border.h"

#import "AppDelegate.h"


@interface ZZNewsListController ()<UITableViewDataSource,UITableViewDelegate>{
    ZZUserInfo *loginUser;
    int page;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZNewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self createTitleMenu];
    
    loginUser = [ZZDataCache getInstance].getLoginUser;
    
    page = 1;
    
    [self.menuTitleButton setTitle:@"消息" forState:UIControlStateNormal];
    if(_newType==ZZNewsTypeCase){
        [self.menuTitleButton setTitle:@"会诊消息" forState:UIControlStateNormal];
    }else if(_newType == ZZNewsTypeSystem){
        [self.menuTitleButton setTitle:@"系统公告" forState:UIControlStateNormal];
    }
    
    
    [self createTableView];
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginNetRefreshData)];
    header.stateLabel.hidden=YES;
    _listTable.header=header;

    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_listArray.count == 0){
        [_listTable.header beginRefreshing];
    }
}

-(void)beginNetRefreshData{
    [_listArray removeAllObjects];
    page = 1;
    
    [self loadMoreData];
}

/**
 加载更多
 */
-(void)loadMoreData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"userId"];
    [dict setObject:convertIntToString(_newType) forKey:@"type"];
    [dict setObject:convertIntToString(page) forKey:@"pageNum"];
    [dict setObject:convertToString(@"30") forKey:@"pageSize"];
    [ZZRequsetInterface post:API_findNews param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.header && [_listTable.header isRefreshing]){
            [_listTable.header endRefreshing];
        }
        
        if(_listTable.footer && [_listTable.footer isRefreshing]){
            [_listTable.footer endRefreshing];
        }
        
        if(_listArray.count == 0){
            [self createPlaceholderView:@"" message:@"还没有任何消息" image:nil withView:_listTable action:nil];
        }else{
            [self removePlaceholderView];
        }
    } complete:^(NSDictionary *dict) {
        if(dict && dict[@"retData"]){
            NSArray *caseMsg = dict[@"retData"];
            for (NSDictionary *item in caseMsg) {
                [_listArray addObject:[[ZZNewsModel alloc] initWithMyDict:item]];
            }
            [_listTable reloadData];
            if(caseMsg.count == 30){
                page = page + 1;
            }else{
                if(_listTable.footer && [_listTable.footer isRefreshing]){
                    [_listTable.footer endRefreshing];
                }
                [_listTable.footer removeFromSuperview];
                _listTable.footer = nil;
            }
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZNewsCell *cell = (ZZNewsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //    if(indexPath.row==_listArray.count-1){
    //        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
    //            [cell setSeparatorInset:UIEdgeInsetsZero];
    //        }
    //
    //        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    //            [cell setLayoutMargins:UIEdgeInsetsZero];
    //        }
    //
    //        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
    //            [cell setPreservesSuperviewLayoutMargins:NO];
    //        }
    //    }
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    
    ZZNewsModel *model=[_listArray objectAtIndex:indexPath.row];
    
    [cell dataToView:indexPath model:model];
    
    return cell;
}



// 是否显示删除功能
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

// 删除清理数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
}


// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    ZZNewsModel *model = [_listArray objectAtIndex:indexPath.row];
    if(model.state == 0){
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(model.newsId) forKey:@"id"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
        [ZZRequsetInterface post:API_updateMessage param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            model.state = 1;
            [_listTable reloadData];
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    if(convertToString(model.action).length > 0){
        [((AppDelegate*)[UIApplication sharedApplication].delegate) openNewPage:model.action];
    }
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < _listArray.count){
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:inset];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
        }
    }
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

#pragma mark UITableView delegate end

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
