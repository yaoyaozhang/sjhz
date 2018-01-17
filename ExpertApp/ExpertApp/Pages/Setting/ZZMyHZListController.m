//
//  ZZMyHZListController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZMyHZListController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"


#import "ZZDoctorCaseCell.h"
#define cellIdentifierCase @"ZZDoctorCaseCell"

#import "ZZCommentController.h"
#import "ZZDoctorChapterController.h"

#import "ZZCaseDetailController.h"
#import "ZZShareView.h"
#import "ZZHZResultController.h"
#import "ZZPatientSymptomController.h"

@interface ZZMyHZListController ()<ZZDoctorCaseDelegate>{
    ZZUserInfo *loginUser;
    
    int   allgroup;
    int   waitgroup;
    int   dogroup;
}
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZMyHZListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    self.menuRightButton.hidden = YES;
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self.menuTitleButton setTitle:@"会诊结果" forState:UIControlStateNormal];
    
    [self createTableView];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeUser vc:self];
        shareView.shareModel = _model;
        [shareView show];
    }
}

-(void)checkHeaderClick:(UIButton *) sender{
    if(sender.tag==1){
        // 全部病例
    }else if(sender.tag == 2){
        // 待处理病例
    }else if(sender.tag == 3){
        // 已处理病例
    }
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    
    _listTable=[self.view createTableView:self cell:cellIdentifierCase];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth,self.view.frame.size.height - NavBarHeight)];
    _listTable.bounces = NO;
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
    
    if(_model != nil){
        _listTable.tableHeaderView = [self createTHeader];
        [self loadDoctorInfo];
    }else{
        // 加载某一个病例下的历史记录
        [self loadDoctorInfo];
    }
}




/**
 加载更多
 */
-(void)loadDoctorInfo{
    NSString *api = API_SearchDocCase;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(_isFromDoc){
        [dict setObject:convertIntToString(_model.healthId) forKey:@"healthId"];
        api =  API_serachDocCaseByHealthId;
    }else{
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
        //0 用户1、医生
        [dict setObject:convertIntToString(_isFromDoc) forKey:@"type"];
    }
    [ZZRequsetInterface post:api param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSDictionary *values = dict[@"retData"];
        if(values){
            allgroup = [values[@"allgroup"] intValue];
            waitgroup = [values[@"waitgroup"] intValue];
            dogroup = [values[@"dogroup"] intValue];

            
            NSArray *arr = values[@"groupList"];
            if(arr && arr.count > 0 ){
                for (NSDictionary *item in arr) {
                    [_listArray addObject:[[ZZHZEngity alloc] initWithMyDict:item]];
                }
            }
            
            [_listTable reloadData];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

-(UIView *) createTHeader{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    [view setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    
    CGFloat x = 10;
    NSArray *titles = @[@"全部病例",@"待处理病例",@"已处理病例"];
    for(int i=0;i<titles.count;i++){
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0){
            
            [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],allgroup] forState:UIControlStateNormal];
        }else if(i==1){
            
            [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],waitgroup] forState:UIControlStateNormal];
        }else{
            
            [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],dogroup] forState:UIControlStateNormal];
        }
        [otherBtn setFrame:CGRectMake(x,15, (ScreenWidth-40)/3, 30)];
        [otherBtn setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
        [otherBtn setTitleColor:UIColorFromRGB(TextSizeThreeColor) forState:UIControlStateNormal];
        [otherBtn.titleLabel setFont:ListDetailFont];
        [otherBtn addTarget:self action:@selector(checkHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = i+1;
        [view addSubview:otherBtn];
        x = x + (ScreenWidth-40)/3 + 10;
    }
    return view;
}

#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
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
    ZZDoctorCaseCell *cell = (ZZDoctorCaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierCase];
    if (cell == nil) {
        cell = [[ZZDoctorCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierCase];
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
    
    if(_model!=nil){
        cell.cellType = ZZHZCellTypeHZHistory;
    }else{
        cell.cellType = ZZHZCellTypeUserHistory;
    }
    cell.indexPath = indexPath;
    ZZHZEngity *model = [_listArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell dataToView:model];
    
    
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
    
    ZZHZEngity *entity = [_listArray objectAtIndex:indexPath.row];
    ZZPatientSymptomController *vc = [[ZZPatientSymptomController alloc] init];
    //        ZZCaseDetailController *vc = [[ZZCaseDetailController alloc] init];
    vc.entity = entity;
    //        vc.caseType = model.type;
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


-(void)onDelegateDel:(ZZHZEngity *)model type:(int)type index:(NSIndexPath *)path{
    // 删除
    if(type == 0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_model.caseId) forKey:@"id"];
        [ZZRequsetInterface post:API_delCaseById param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [_listArray removeObjectAtIndex:path.row];
            [_listTable reloadData];
            [self.view makeToast:@"删除成功!"];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    if(type == 2){
        // 病例详情
        ZZPatientSymptomController *vc = [[ZZPatientSymptomController alloc] init];
//        ZZCaseDetailController *vc = [[ZZCaseDetailController alloc] init];
        vc.entity = model;
//        vc.caseType = model.type;
        [self openNav:vc sound:nil];
    }
    if(type == 3){
        if(model.state < 3){
            [self.view makeToast:@"还没有给结果！"];
            return;
        }
        // 会诊结果
        ZZHZResultController *vc = [[ZZHZResultController alloc] init];
        vc.model = model;
        [self openNav:vc sound:nil];
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
