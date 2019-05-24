//
//  ZZDoctorHomeController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//
//

#import "ZZDoctorHomeController.h"


#import "UIView+Extension.h"
#import "MJRefresh.h"



#import "ZZDoctorHeaderCell.h"
#define cellIdentifierHeader @"ZZDoctorHeaderCell"
#import "ZZDoctorCaseCell.h"
#define cellIdentifierCase @"ZZDoctorCaseCell"

#import "ZZCommentController.h"
#import "ZZChoosePatientController.h"
#import "ZZDoctorChapterController.h"

#import "ZZLeaderDoctorController.h"
#import "ZZDiscussController.h"
#import "ZZHZResultController.h"
#import "ZZSearchResultController.h"

#import "ZZShareView.h"

#import "ZZHZEngity.h"

#import "ASQListController.h"


@interface ZZDoctorHomeController ()<ZZDoctorCaseDelegate>{
    
    int checkIndex;
    
    int   allgroup;
    int   waitgroup;
    int   dogroup;
    
    int pageNum;
}
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZDoctorHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    self.menuRightButton.hidden = NO;
    self.menuLeftButton.hidden = YES;
    [self.view setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [self.menuTitleButton setTitle:[NSString stringWithFormat:@"%@医生的主页",[self getLoginUser].docName] forState:UIControlStateNormal];
    
    [self createTableView];
    
    checkIndex = 1;
    [self loadDoctorInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginNetRefreshData) name:@"ZZNoticeInviteDoctorSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:@"ZZNoticeUserInfoChanged" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self beginNetRefreshData];
    [self.menuTitleButton setTitle:[NSString stringWithFormat:@"%@医生的主页",[self getLoginUser].docName] forState:UIControlStateNormal];
    
}

-(void)userInfoChanged:(NSNotification *) info{
    [_listTable reloadData];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeUser vc:self];
        shareView.shareModel=[self getLoginUser];
        [shareView show];
    }else if(sender.tag == 111){
        // 关注
        
    }else if(sender.tag == 222){
        // 咨询
        ZZChoosePatientController *chooseVC = [[ZZChoosePatientController alloc] init];
        chooseVC.doctorId = convertIntToString([self getLoginUser].userId);
        chooseVC.doctInfo = [self getLoginUser];
        [self openNav:chooseVC sound:nil];
        
    }else if(sender.tag == 333){
        // 所有文章
        ZZDoctorChapterController *chatpterVC = [[ZZDoctorChapterController alloc] init];
        chatpterVC.docInfo = [self getLoginUser];
        [self openNav:chatpterVC sound:nil];
    }
    
}


-(void)checkHeaderClick:(UIButton *) sender{
    checkIndex = (int)sender.tag;
    
    pageNum = 1;
    
    [self beginNetRefreshData];
}

-(void)beginNetRefreshData{
    
    if(checkIndex==1){
        // 全部病例
        [self loadDoctorInfo];
    }else if(checkIndex == 2){
        //1、待處理、2、正在處理、3、已處理完成
        // 待处理病例
        pageNum = 1;
        [self loadCaseByState:1];
    }else if(checkIndex == 3){
        // 已处理病例
        pageNum = 1;
        [self loadCaseByState:3];
    }
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    
    _listTable=[self.view createTableView:self cell:cellIdentifierCase formY:NavBarHeight withHeight:ScreenHeight - 49 - (ZC_iPhoneX?34:0)];
    
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierHeader bundle:nil] forCellReuseIdentifier:cellIdentifierHeader];
//    _listTable.bounces = NO;
//    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    MJRefreshStateHeader *header=[MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self loadDoctorInfo];
    }];
//    header.stateLabel.hidden = YES;
    _listTable.header=header;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
}



/**
 加载更多
 */

/**
 加载更多
 */
-(void)loadDoctorInfo{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString([self getLoginUser].userId) forKey:@"userId"];
    //0 用户1、医生
    [dict setObject:convertIntToString(1) forKey:@"type"];
    [ZZRequsetInterface post:API_SearchDocCase param:dict timeOut:HttpGetTimeOut start:^{
        if(![_listTable.header isRefreshing]){
            [SVProgressHUD show];
        }
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
//        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([_listTable.header isRefreshing]){
            [_listTable.header endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        NSDictionary *values = dict[@"retData"];
        [_listArray removeAllObjects];
        if(values){
            allgroup = [values[@"allgroup"] intValue];
            waitgroup = [values[@"waitgroup"] intValue];
            dogroup = [values[@"dogroup"] intValue];
            ZZUserInfo *loginUser = [self getLoginUser];
            loginUser.fansNumber = [values[@"isLook"] intValue];
            loginUser.orderNumber = allgroup;
            loginUser.articleNum = [values[@"newsNum"] intValue];
            [[ZZDataCache getInstance] changeUserInfo:loginUser];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZNoticeUserInfoChanged" object:nil];
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


-(void)loadCaseByState:(int)state{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString([self getLoginUser].userId) forKey:@"userId"];
    //0 用户1、医生
    [dict setObject:@"1" forKey:@"type"];
    [dict setObject:convertIntToString(state) forKey:@"state"];
    [dict setObject:@"1" forKey:@"pageNum"];
    [dict setObject:@"30" forKey:@"pageSize"];
    [ZZRequsetInterface post:API_SearchDocCaseByState param:dict timeOut:HttpGetTimeOut start:^{
        if(![_listTable.header isRefreshing]){
            [SVProgressHUD show];
        }
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
//        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([_listTable.header isRefreshing]){
            [_listTable.header endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        NSArray *values = dict[@"retData"];
        if(pageNum==1){
            [_listArray removeAllObjects];
        }
        if(!is_null(values) && values.count > 0){
            if(values.count == 30){
                pageNum = pageNum + 1;
            }
            
            for (NSDictionary *item in values) {
                [_listArray addObject:[[ZZHZEngity alloc] initWithMyDict:item]];
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
        return 0;
    }else if(section == 1){
        return 97;
    }else{
        return 0;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 97)];
        [view setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
        [view addSubview:[self createTips:[NSString stringWithFormat:@"您现在还有%d个病例需要处理。",waitgroup]]];
        
        UIView *bgWhite = [[UIView alloc] initWithFrame:CGRectMake(0, 37, ScreenWidth, 60)];
        [bgWhite setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:bgWhite];
        
        CGFloat x = 10;
        NSArray *titles = @[@"全部病例",@"待处理病例",@"已处理病例"];
        for(int i=0;i<titles.count;i++){
            UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [otherBtn setTitleColor:UIColorFromRGB(TextSizeThreeColor) forState:UIControlStateNormal];
            if(i==0){
                
                [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],allgroup] forState:UIControlStateNormal];
                
            }else if(i==1){
                
                [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],waitgroup] forState:UIControlStateNormal];
            }else{
                
                [otherBtn setTitle:[NSString stringWithFormat:@"%@(%d个)",titles[i],dogroup] forState:UIControlStateNormal];
            }
            if(checkIndex == (i+1)){
                [otherBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
            }
            [otherBtn setFrame:CGRectMake(x,37 + 15, (ScreenWidth-40)/3, 30)];
            [otherBtn setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
            [otherBtn.titleLabel setFont:ListDetailFont];
            [otherBtn addTarget:self action:@selector(checkHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
            otherBtn.tag = i+1;
            [view addSubview:otherBtn];
            x = x + (ScreenWidth-40)/3 + 10;
            
            
        }
        
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZDoctorHeaderCell *cell = (ZZDoctorHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierHeader];
        if (cell == nil) {
            cell = [[ZZDoctorHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierHeader];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell dataToView:[self getLoginUser]];
        return cell;
    }
    
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
    cell.cellType = ZZHZCellTypeHome;
    cell.delegate = self;
    cell.indexPath = indexPath;
    ZZHZEngity *newsModel = _listArray[indexPath.row];
    [cell dataToView:newsModel];
    
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
    if(_listArray==nil || _listArray.count<indexPath.row || indexPath.section == 0){
        return;
    }
    
    
    ZZHZEngity *model = [_listArray objectAtIndex:indexPath.row];
    if(model.firstDoc && (model.state == 0 ||  model.state == 1)){
        ZZLeaderDoctorController *vc = [[ZZLeaderDoctorController alloc] init];
        vc.model = model;
        [self openNav:vc sound:nil];
    }else if(model.state == 2){
        ZZDiscussController *vc = [[ZZDiscussController alloc] init];
        vc.model = model;
        [self openNav:vc sound:nil];
    }else if(model.state>2){
        ZZHZResultController *vc = [[ZZHZResultController alloc] init];
        vc.model = model;
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

-(void)onDelegateDel:(ZZHZEngity *)model type:(int)type index:(NSIndexPath *)path{
    // 0删除
    
    
    // 状态点击
    if(type == 1){
        if(model.state == 0){
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:convertIntToString(model.caseId) forKey:@"id"];
            [ZZRequsetInterface post:API_SetCaseStateByDoctor param:dict timeOut:HttpPostTimeOut start:^{
                [SVProgressHUD show];
            } finish:^(id response, NSData *data) {
                [SVProgressHUD dismiss];
                NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            } complete:^(NSDictionary *dict) {
                if(dict){
                    model.state = 1;
                    [_listTable reloadData];
                }
            } fail:^(id response, NSString *errorMsg, NSError *connectError) {
                
            } progress:^(CGFloat progress) {
                
            }];
        }
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

