//
//  ZZArchivesController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZArchivesController.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZCaseCell.h"
#define cellIdentifier @"ZZCaseCell"

#import "ZZBuyController.h"
#import "ZZCreateCaseController.h"
#import "ZZCreateSportCaseController.h"
#import "ZCActionSheetView.h"

#import "ZZMyHZListController.h"

#import "ZZCreateCaseController.h"
#import "ZZCreateSportCaseController.h"

@interface ZZArchivesController ()<UITableViewDelegate,UITableViewDataSource,ZZCaseCellDelegate,ZCActionSheetViewDelegate>{
    
    ZZUserInfo *loginUser;
    
    NSInteger checkedRow;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZArchivesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"我的档案" forState:UIControlStateNormal];
    
    [self createTableView];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self loadMoreData];
    
    checkedRow = -1;
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
    
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


// 添加病例
-(void) addCase:(UIButton *) btn{
    ZCActionSheetView *actionSheet = [[ZCActionSheetView alloc]initWithDelegate:self title:nil CancelTitle:@"取消" OtherTitles:@"普通病例",@"运动康复病例", nil];
    [actionSheet show];
    
    
}

-(void)actionSheet:(ZCActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zd",buttonIndex);
    if(buttonIndex == 1){
        ZZCreateCaseController *addVC = [[ZZCreateCaseController alloc] init];
        [self openNav:addVC sound:nil];
    }
    
    if(buttonIndex == 2){
        ZZCreateSportCaseController *addVC = [[ZZCreateSportCaseController alloc] init];
        
        [self openNav:addVC sound:nil];
    }
    
    
    
}


// 选择病例,去支付
-(void)confirmCase:(UIButton *) btn{
    //    ZZBuyController *addVC = [[ZZBuyController alloc] init];
    //    [self openNav:addVC sound:nil];
    if(checkedRow<0 || _listArray.count==0){
        [self.view makeToast:@"请选择一个病例"];
        return;
    }
    
//    if([@"" isEqual:convertToString(_doctorId)]){
//        [self.view makeToast:@"请先选择一个医生"];
//        return;
//    }
//    
    NSDictionary *item = _listArray[checkedRow];
    // 直接发起会诊
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 医生ID
//    [dict setObject:convertToString(_doctorId) forKey:@"forUserId"];
    // 病例ID
    [dict setObject:convertToString(item[@"caseId"]) forKey:@"caseId"];
    // 问卷类型 1普通 2运动
    [dict setObject:convertToString(item[@"type"]) forKey:@"type"];
    //
    [dict setObject:convertToString(@"1") forKey:@"firstDoc"];
    [dict setObject:convertToString(@"0") forKey:@"state"];
    [dict setObject:convertToString(@"") forKey:@"caseDept"];
    [ZZRequsetInterface post:API_AddDiscussCase param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        [self.view makeToast:@"提交完成，请等待诊断结果!"];
        
        ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
        [self openNav:vc sound:nil];
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [self.view makeToast:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
    
}


/**
 加载更多
 */
-(void)loadMoreData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_SearchAllCase param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD showWithStatus:@"病例加载中"];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        if(arr && arr.count>0){
            for (NSDictionary *item in arr) {
                [_listArray addObject:item];
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
    return 2;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        if(is_null(_listArray) || _listArray.count == 0){
            return 0;
        }
        return 40;
    }else{
        return 70;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 40)];
        [label setFont:ListDetailFont];
        [label setText:@"请选择为谁提问"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromRGB(TextDarkColor)];
        [view addSubview:label];
        return view;
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, 20, ScreenWidth, 50)];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [addBtn setTitle:@"+ 添加病例" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addCase:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return _listArray.count;
    }
    
    return 0;
    
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZCaseCell *cell = (ZZCaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    if(_listArray.count < indexPath.row){
        return cell;
    }
    
    if(indexPath.row == checkedRow){
        cell.isChecked = YES;
    }else{
        cell.isChecked = NO;
    }
    cell.delegate = self;
    cell.curIndexPath = indexPath;
    cell.chooseBtn.hidden = YES;
    [cell dataToView:_listArray[indexPath.row]];
    
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
    return 60.0f;
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    //    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    
    NSDictionary *item = _listArray[indexPath.row];
    
    int caseType = [item[@"caseId"] intValue];
    // 选择
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(item[@"caseId"]) forKey:@"caseId"];
    [dict setObject:convertIntToString(caseType) forKey:@"type"];
    [ZZRequsetInterface post:API_SearchCaseDetail param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        
        if(caseType == 1){
             ZZCaseModel *editModel = [[ZZCaseModel alloc] initWithMyDict:dict[@"retData"]];
            
            ZZCreateCaseController *vc = [[ZZCreateCaseController alloc] init];
            vc.editModel = editModel;
            [self openNav:vc sound:nil];
        }else{
            ZZSportCaseEntity *sportModel = [[ZZSportCaseEntity alloc] initWithMyDict:dict[@"retData"]];
            
            ZZCreateSportCaseController *vc = [[ZZCreateSportCaseController alloc] init];
            vc.editModel = sportModel;
            [self openNav:vc sound:nil];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
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



-(void)onCaseCellItemOnClick:(int)type index:(NSIndexPath *)indexPath{
    if(type == 1){
        // 改成单选
        checkedRow = indexPath.row;
        [_listTable reloadData];
    }
    
    if(type == 2){
        // 删除
        [_listArray removeObjectAtIndex:indexPath.row];
        NSMutableDictionary *item = _listArray[indexPath.row];
        NSString *caseId = item[@"caseId"];
        [_listTable reloadData];
        
    }
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
