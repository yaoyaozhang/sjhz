//
//  ZZRemarkUserController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRemarkUserController.h"


#import "UIView+Extension.h"

#import "ZZRemakBaseCell.h"

#import "ZZBasicCell.h"
#define cellIdentifier @"ZZBasicCell"

#import "ZZRemarkLabelCell.h"
#define cellIdentifierLab @"ZZRemarkLabelCell"

#import "ZZRemarkCaseCell.h"
#define cellIdentifierCase @"ZZRemarkCaseCell"

#import "ZZRemarkNextCell.h"
#define cellIdentifierNext @"ZZRemarkNextCell"

#import "ZZCaseDetailController.h"
#import "ZZPatientListController.h"

#import "ASQListController.h"

@interface ZZRemarkUserController ()<ZZRemarkCellDelegate>{
    NSMutableArray *cases;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZRemarkUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTitleMenu];
    // Do any additional setup after loading the view.
    [self.menuTitleButton setTitle:@"个人信息" forState:UIControlStateNormal];
    if(_type>0){
        
    }else{
        
        [self.menuRightButton setTitle:@"保存" forState:UIControlStateNormal];
        self.menuRightButton.hidden = NO;
        
    }
    [self createTableView];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        if([@"" isEqual:convertToString(_myFriend.name)]){
            
        }
        ZZUserInfo *login = [ZZDataCache getInstance].getLoginUser;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(login.userId) forKey:@"userId"];
        [dict setObject:convertIntToString(_myFriend.userId) forKey:@"touserId"];
        [dict setObject:convertToString(_myFriend.name) forKey:@"remarkName"];
        [dict setObject:convertToString(_myFriend.lableName) forKey:@"lableName"];
        
        [ZZRequsetInterface post:API_saveRemarkName param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [self.view makeToast:@"备注成功!"];
            
            if(_ZZCreateResultBlock){
                _ZZCreateResultBlock(1);
            }
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierLab bundle:nil] forCellReuseIdentifier:cellIdentifierLab];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierCase bundle:nil] forCellReuseIdentifier:cellIdentifierCase];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierNext bundle:nil] forCellReuseIdentifier:cellIdentifierNext];
    
    
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
//
//
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cases = [[NSMutableArray alloc] init];
    
    [self setTableSeparatorInset];
    
    [self loadMoreData];
    [self loadCases];
}


/**
 加载更多
 */
-(void)loadMoreData{
    [_listArray removeAllObjects];
    
    
    if(_type > 0){
        [_listArray addObject:@{@"cid":@"4",@"name":@"个人档案",@"value":@"",@"type":@"0"}];
        [_listArray addObject:@{@"cid":@"5",@"name":@"调查问卷",@"value":@"",@"type":@"0"}];
        [_listArray addObject:@{@"cid":@"6",@"name":@"自测量表",@"value":@"",@"type":@"0"}];
    }else{
        // 1 普通，2表情，3病例
        [_listArray addObject:@{@"cid":@"1",@"name":@"备注名",@"value":@"",@"type":@"1"}];
        [_listArray addObject:@{@"cid":@"2",@"name":@"标签",@"value": convertToString(_myFriend.lableName),@"type":@"2"}];
        [_listArray addObject:@{@"cid":@"3",@"name":@"电话号码",@"value":@"",@"type":@"1"}];
        [_listArray addObject:@{@"cid":@"4",@"name":@"个人病例",@"value":@"",@"type":@"0"}];
        [_listArray addObject:@{@"cid":@"5",@"name":@"调查问卷",@"value":@"",@"type":@"0"}];
        [_listArray addObject:@{@"cid":@"6",@"name":@"自测量表",@"value":@"",@"type":@"0"}];
        
    }
    
    [_listTable reloadData];
    
}


/**
 加载更多
 */
-(void)loadCases{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_myFriend.userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_SearchAllCase param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD showWithStatus:@"病例加载中"];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        if(arr && arr.count>0){
            [cases removeAllObjects];
            for (NSDictionary *item in arr) {
                [cases addObject:item];
            }
            [self loadMoreData];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
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
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listArray.count == 0){
        return 0;
    }
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZRemakBaseCell *cell = nil;
    NSDictionary *item = [_listArray objectAtIndex:indexPath.section];
    int type = [item[@"type"] intValue];
    if(type == 1){
        cell = (ZZBasicCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ZZBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(type == 2){
        cell = (ZZRemarkLabelCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierLab];
        if (cell == nil) {
            cell = [[ZZRemarkLabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        ((ZZRemarkLabelCell *)cell).labText = _myFriend.lableName;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if(type == 0){
        cell = (ZZRemarkNextCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierNext];
        if (cell == nil) {
            cell = [[ZZRemarkNextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierNext];
        }
    }
//    if(type == 3){
//        cell = (ZZRemarkCaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierCase];
//        if (cell == nil) {
//            cell = [[ZZRemarkCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierCase];
//        }
//        ((ZZRemarkCaseCell *)cell).cases = cases;
//    }
    
    cell.user = _myFriend;
    cell.delegate =self;
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
    
    [cell dataToView:item];
    
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
    NSDictionary *item = _listArray[indexPath.section];
    int cid = [item[@"cid"] intValue];
    if(cid == 5 || cid == 6){
        ASQListController *vc = [[ASQListController alloc] init];
        vc.userId = _myFriend.userId;
        vc.type = ASQTYPEWJ;
        if(cid == 6){
            vc.type = ASQTYPELB;
        }
        [self openNav:vc sound:nil];
    }
    if(cid == 4){
        ZZPatientListController *vc = [[ZZPatientListController alloc] init];
        vc.userId = _myFriend.userId;
        [self openNav:vc sound:nil];
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


-(void)onCellClick:(id)obj type:(int)type{
    if(type == 1){
        _myFriend.lableName = convertToString(obj);
    }
    
    if(type == 2){
        NSDictionary *item = obj;
        
        ZZCaseDetailController *vc = [[ZZCaseDetailController alloc] init];
        vc.caseId =  [item[@"caseId"] intValue];
        vc.caseType = [item[@"type"] intValue];
        [self openNav:vc sound:nil];
    }
    if(type == 3){
        _myFriend.name = convertToString(obj);
//        [self loadMoreData];
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
