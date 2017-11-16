//
//  ASQListController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/15.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ASQListController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "ZZQSModel.h"
#import "ZZQSListCell.h"
#define cellIdentifier @"ZZQSListCell"

#import "ASQDetailController.h"

@interface ASQListController ()


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@end

@implementation ASQListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:@"量表" forState:UIControlStateNormal];
    
    [self createTableView];
    
    [self loadMoreData];
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
}


/**
 加载更多
 */
-(void)loadMoreData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(_userId>0){
        [dict setObject:convertIntToString(_userId) forKey:@"userId"];
    }else{
        ZZUserInfo *user = [ZZDataCache getInstance].getLoginUser;
        [dict setObject:convertIntToString(user.userId) forKey:@"userId"];
    }
    
    [ZZRequsetInterface post:API_findLiangBiaoList param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        if(!is_null(arr) && arr.count>0){
            for(NSDictionary *item in arr){
                [_listArray addObject:[[ZZQSListModel alloc] initWithMyDict:item]];
            }
            [_listTable reloadData];
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
    if(section==0){
        return 0;
    }else{
        return 25;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listArray==nil){
        return 0;
    }
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZQSListCell *cell = (ZZQSListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZQSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(indexPath.row==_listArray.count-1){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    if(_listArray.count < indexPath.row){
        return cell;
    }
    
    ZZQSListModel *m=[_listArray objectAtIndex:indexPath.row];
    [cell.labTitle setText:m.quesName];
    
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
//    return 70.0f;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    ZZQSListModel *m=[_listArray objectAtIndex:indexPath.row];
    ASQDetailController *detail = [[ASQDetailController alloc] init];
    detail.model = m;
    [self openNav:detail sound:nil];
    
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
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
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
