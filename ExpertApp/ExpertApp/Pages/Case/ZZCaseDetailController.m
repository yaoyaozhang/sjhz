//
//  ZZCaseDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseDetailController.h"


#import "ZZCreateCaseController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"


#import "ZZAlertview.h"
#import "ZCActionSheetView.h"

#import "ZCTextPlaceholderView.h"
#import "ZZCreateCaseBaseCell.h"
#import "ZZCaseDetailMulCell.h"
#import "ZZCaseDtailCell.h"

#define cellIdentifierG @"ZZCaseDetailMulCell"
#define cellIdentifierM @"ZZCaseDtailCell"

#import "NirKxMenu.h"



@interface ZZCaseDetailController (){
  
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZCaseDetailController


-(void)refreshViewData:(BOOL) isRefresh{
    
    [_listArray removeAllObjects];
    //    NSDictionary *dict = [ZCJSONDataTools getObjectData:_model];
    // dictType 字段类型
    // valueType 数据类型
    
    if(_editModel!=nil){
        [_listArray addObjectsFromArray:[_editModel getArrlist]];
    }else if(_sportModel!=nil){
        [_listArray addObjectsFromArray:[_sportModel getArrlist]];
    }else{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_caseId) forKey:@"caseId"];
        [dict setObject:convertIntToString(_caseType) forKey:@"type"];
        [ZZRequsetInterface post:API_SearchCaseDetail param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if(_caseType == 1){
                _editModel = [[ZZCaseModel alloc] initWithMyDict:dict[@"retData"]];
            }else{
                _sportModel = [[ZZSportCaseEntity alloc] initWithMyDict:dict[@"retData"]];
            }
            [self refreshViewData:YES];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    if(isRefresh){
        [_listTable reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 屏蔽橡皮筋功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [self createTitleMenu];
    self.menuRightButton.hidden = YES;
    [self.menuLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.menuTitleButton setTitle:@"病例详情" forState:UIControlStateNormal];
    
    
    
    _listArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self refreshViewData:YES];
}



-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [self goBack:nil];
        
        return;
    }
    if(sender.tag == 111){
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
       
        
        //
        NSString *api = API_SaveSportCase;
        
        
        [ZZRequsetInterface post:api param:param timeOut:HttpPostTimeOut start:^{
            [SVProgressHUD showWithStatus:@"加载中...."];
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
}




-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    _listTable=[self.view createTableView:self cell:nil];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight)];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierG bundle:nil] forCellReuseIdentifier:cellIdentifierG];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierM bundle:nil] forCellReuseIdentifier:cellIdentifierM];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self setTableSeparatorInset];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [addBtn setTitle:@"马上抢单" forState:UIControlStateNormal];
    addBtn.tag = 111;
    [addBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if(_formDoctor){
        [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-40)];
        [self.view addSubview:addBtn];
    }
    
}



#pragma mark UITableView delegate Start

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self hideKeyboard];
//    [self allHideKeyBoard];
}

// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [view setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [label setFont:ListTimeFont];
    [label setText:@"请您仔细阅读病例"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:UIColorFromRGB(BgTitleColor)];
    [view addSubview:label];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZCaseDetailBaseCell *cell = nil;
    // 0，特殊行   1 单行文本 2 多行文本 3 日期 4 时间 5 数值 6 下拉列表 7 复选框 8 单选框 9 级联字段
    NSDictionary *itemDict = _listArray[indexPath.row];
    int type = [itemDict[@"dictType"] intValue];
    if(type == ZZEditControlTypeTextView || type == ZZEditControlTypeButton){
        cell = (ZZCaseDetailMulCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierG];
        if (cell == nil) {
            cell = [[ZZCaseDetailMulCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierG];
        }
    }else{
        cell = (ZZCaseDtailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierM];
        if (cell == nil) {
            cell = [[ZZCaseDtailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierM];
        }
    }
    
    
    [cell dataToView:itemDict];
    
    
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
    
    
    NSDictionary *itemDict = _listArray[indexPath.section][@"arr"][indexPath.row];
    
    if([itemDict[@"propertyType"] intValue]==3){
        return;
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
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
    if ([_listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTable setSeparatorInset:inset];
    }
    
    if ([_listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTable setLayoutMargins:inset];
    }
}



#pragma mark UITableViewCell 行点击事件处理

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
