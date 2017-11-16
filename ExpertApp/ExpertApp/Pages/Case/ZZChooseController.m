//
//  ZZChooseController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChooseController.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZCaseCell.h"
#define cellIdentifier @"ZZCaseCell"

#import "ZZBuyController.h"
#import "ZZCreateCaseController.h"
#import "ZZCreateSportCaseController.h"
#import "ZZCaseDetailController.h"
#import "ZCActionSheetView.h"

#import "ZZMyHZListController.h"

#import "ASQController.h"

@interface ZZChooseController ()<UITableViewDelegate,UITableViewDataSource,ZZCaseCellDelegate,ZCActionSheetViewDelegate>{
    
    ZZUserInfo *loginUser;
    
    NSInteger checkedRow;
    
    UIButton *addHZBtn;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"选择健康病例" forState:UIControlStateNormal];
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setTitle:@"刷新" forState:UIControlStateNormal];
    
    [self createTableView];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self loadMoreData];
    
    checkedRow = -1;
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        [self loadMoreData];
    }
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight - 40)];
    
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
    
    
    addHZBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addHZBtn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [addHZBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [addHZBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [addHZBtn setTitle:@"提交" forState:UIControlStateNormal];
    addHZBtn.tag = 111;
    [addHZBtn addTarget:self action:@selector(confirmCase:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addHZBtn];
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
        addVC.docId = _doctorId;
        [addVC setZZCreateResultBlock:^(int status){
            if(status == 1){
                [self loadMoreData];
            }
//            if(status == 2){
//                [self loadMoreData];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
//                    [self openNav:vc sound:nil];
//                });
//            }
        }];
        [self openNav:addVC sound:nil];
    }
    
    if(buttonIndex == 2){
        if(_doctInfo && ![convertToString(_doctInfo.departmentName) hasPrefix:@"运动康复"]){
            [self.view makeToast:@"只有运动康复科室的医生才可接受此病例的咨询"];
            return;
        }
        
        ZZCreateSportCaseController *addVC = [[ZZCreateSportCaseController alloc] init];
        addVC.docId = _doctorId;
        [addVC setZZCreateResultBlock:^(int status){
            if(status == 1){
                [self loadMoreData];
            }
//            if(status == 2){
//                [self loadMoreData];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
//                    [self openNav:vc sound:nil];
//                });
//            }
        }];
        [self openNav:addVC sound:nil];
    }
    
    
    
}


// 选择病例,去支付
-(void)confirmCase:(UIButton *) btn{
    if(checkedRow<0 || _listArray.count==0){
        [self.view makeToast:@"请选择一个病例"];
        return;
    }
    
    if([@"" isEqual:convertToString(_doctorId)]){
        [self.view makeToast:@"请先选择一个医生"];
        return;
    }
    
    NSDictionary *item = _listArray[checkedRow];
    // 直接发起会诊
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    // 医生ID
    [dict setObject:convertToString(_doctorId) forKey:@"forUserId"];
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
        
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        int hzId = [dict[@"retData"] intValue];
        [self checkWenjuan:hzId];
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD dismiss];
        [self.view makeToast:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
    
}


-(void)checkWenjuan:(int )hzId{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(_doctorId) forKey:@"userId"];
    [dict setObject:@"2" forKey:@"type"];
    [ZZRequsetInterface post:API_checkWenjuanByUserId param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if([dict[@"retData"] intValue]>0){
            ASQController *avc = [[ASQController alloc] init];
            avc.type = ASQTYPEWJ;
            avc.docId = [_doctorId intValue];
            [avc setZZCreateResultBlock:^(int status) {
                if(status == 1){
                    [self.view makeToast:@"提交完成，请等待诊断结果!"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
                        [self openNav:vc sound:nil];
                    });
                }
            }];
            [self openNav:avc sound:nil];
        }else{
            [self.view makeToast:@"提交完成，请等待诊断结果!"];
            ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
            [self openNav:vc sound:nil];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
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
        [_listArray removeAllObjects];
        NSArray *arr = dict[@"retData"];
        if(arr && arr.count>0){
            for (NSDictionary *item in arr) {
                [_listArray addObject:item];
            }
        }
        [_listTable reloadData];
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
    
    ZZCaseDetailController *vc = [[ZZCaseDetailController alloc] init];
    vc.caseId =  [item[@"caseId"] intValue];
    vc.caseType = [item[@"type"] intValue];
    [self openNav:vc sound:nil];
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
        
        NSMutableDictionary *item = _listArray[indexPath.row];
        
        if(is_null(item)){
            return;
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:convertToString(item[@"caseId"]) forKey:@"caseId"];
        [dict setObject:convertToString(item[@"type"]) forKey:@"type"];
        
        [ZZRequsetInterface post:API_DelCase param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [_listArray removeObjectAtIndex:indexPath.row];
            [_listTable reloadData];
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
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
