//
//  ZZMyIntegralListController.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZMyIntegralListController.h"


#import "UIView+Extension.h"

#import "ZZIntegralCell.h"
#define cellIdentifier @"ZZIntegralCell"

@interface ZZMyIntegralListController ()<UITableViewDelegate,UITableViewDataSource>{
    ZZUserInfo *user;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray          *listArray;

@end

@implementation ZZMyIntegralListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"积分详情" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = NO;
    
    user = [[ZZDataCache getInstance] getLoginUser];
    [self createTableView];
    [self loadMoreData];
    
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable = [self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    
    if (iOS7) {
        
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
}

/**
 加载更多
 */
-(void)loadMoreData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(user.userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_getSouceeList param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(dict && dict[@"retData"]){
            
            [_listArray addObjectsFromArray:dict[@"retData"]];
            [_listTable reloadData];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}


-(void)changeValue:(UISwitch *) sender{
    if(sender.tag == 0){
        
    }
    if(sender.tag == 1){
        
    }
}


#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section>0){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        //        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, 25)];
        //        [label setFont:ListDetailFont];
        //        [label setText:@"gansha a"];
        //        [label setTextAlignment:NSTextAlignmentLeft];
        //        [label setTextColor:UIColorFromRGB(TextBlackColor)];
        //        [view addSubview:label];
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZIntegralCell *cell = (ZZIntegralCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ZZIntegralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        
    }
    [cell dataToView:_listArray[indexPath.section]];
    
    
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
    
    //int code =  [_listArray[indexPath.section][@"code"] intValue];
    
    
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
