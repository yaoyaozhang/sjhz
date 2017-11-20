//
//  ZZAttentionController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZAttentionController.h"


#import "UIView+Extension.h"
#import <MJRefresh.h>

#import "ZZDoctorCell.h"
#define cellIdentifier @"ZZDoctorCell"

#import "NirKxMenu.h"
#import "ZZDoctorDetailController.h"

@interface ZZAttentionController ()<UITableViewDelegate,UITableViewDataSource,ZZDoctorCellDelegate>{
    ZZUserInfo *loginUser;
    NSInteger selectIndex;
    ZZDictModel  *checkModel;
    int pageNumber;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)UIButton         *checkButton;


@end

@implementation ZZAttentionController


- (void)initSegmentedControl
{
    self.menuTitleButton.hidden = YES;
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"所有医生",@"我的朋友",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(ScreenWidth/2 -  90.0, StatusBarHeight + 8.0f,180.0, 28.0);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = UIColorFromRGB(TextWhiteColor);
    segmentedControl.selectedSegmentIndex = 1;//默认选中的按钮索引
    
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:ListDetailFont,NSFontAttributeName,UIColorFromRGB(TextWhiteColor), NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:UIColorFromRGB(BgTitleColor) forKey:NSForegroundColorAttributeName];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(sementedControlClick:)forControlEvents:UIControlEventValueChanged];
    
    [self.titleMenu addSubview:segmentedControl];
    
    selectIndex = 1;
    
    
    _listTable.tableHeaderView = [self createTableHeaderView];
    
    pageNumber = 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"我的医生" forState:UIControlStateNormal];
    
    loginUser = [self getLoginUser];
    
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    __weak typeof(self) weakSelf = self;
    _listTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    _listTable.header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    if(loginUser.isDoctor){
        self.menuTitleButton.hidden = YES;
        [self initSegmentedControl];
    }
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    [self refreshData];
}

//监听方法
- (void)sementedControlClick:(UISegmentedControl *) Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index)
    {
        case 0:
            if(selectIndex != 0){
                selectIndex = 0;
                [_listArray removeAllObjects];
                [self refreshData];
            }
            break;
        case 1:
            if(selectIndex != 1){
                selectIndex = 1;
                [_listArray removeAllObjects];
                [self refreshData];
            }
            break;
        default:
            break;
    }
}


/** 下拉刷新 */
- (void)refreshData
{
    [_listArray removeAllObjects];
    pageNumber = 1;
    [self loadMoreData];
}

/** 上拉加载 */
- (void)loadMoreData
{
    NSString *api = API_getMyDoctorList;
    // 获取tid来拼接urlString
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    if(loginUser.isDoctor){
        if(selectIndex == 0){
            api = API_searchDoctor;
        }else{
            api = API_getMyDoctorList;
        }
        if(checkModel){
            [dict setObject:convertIntToString(checkModel.baseId) forKey:@"keshi"];
        }else{
            [dict setObject:@"0" forKey:@"keshi"];
        }
    }else{
        api = API_searchDoctor;
//        [dict setObject:convertToString(model.name) forKey:@"department"];
    }
    [dict setObject:convertIntToString(pageNumber) forKey:@"pageNum"];
    [dict setObject:@"30" forKey:@"pageSize"];
    
    [ZZRequsetInterface post:api param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
        if(_listTable.footer){
            if([_listTable.footer isRefreshing]){
                [_listTable.footer endRefreshing];
            }
        }
        if(_listTable.header){
            if([_listTable.header isRefreshing]){
                [_listTable.header endRefreshing];
            }
        }
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        
        if(_listArray.count < 30){
            if(_listTable.footer){
                if([_listTable.footer isRefreshing]){
                    [_listTable.footer endRefreshing];
                }
                [_listTable.footer removeFromSuperview];
            }
        }
        
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        if(arr && arr.count>0){
            for (NSDictionary *item in arr) {
                [_listArray addObject:[[ZZUserInfo alloc] initWithMyDict:item]];
            }
            
            if(arr.count == 30){
                pageNumber = pageNumber + 1;
            }
        }
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}


-(void)checkConfigLoading:(UIButton *) sender{
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        if(status == 0){
            [SVProgressHUD dismiss];
            
            [self btnShowMenu:sender];
        }
        if(status == 1){
            [SVProgressHUD show];
        }
        if(status == 2){
            [SVProgressHUD showErrorWithStatus:@"加载配置信息错误"];
        }
    }];
}
-(void)btnShowMenu:(UIButton *) sender{
    
    NSString *configKey = KEY_CONFIG_DEPARTMENT;
    
    
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:configKey];
    if(arr==nil || arr.count==0){
        return;
    }
    
    //配置一：基础配置
    KxMenu.titleFont = ListDetailFont;
    
    //    //配置二：拓展配置
    OptionalConfiguration options;
    options.arrowSize = 0.0f;
    options.marginXSpacing = 7;
    options.marginYSpacing = 9;
    options.seperatorLineHasInsets = 25;
    options.menuCornerRadius = 0.0f;
    options.maskToBackground = true;
    options.shadowOfMenu = false;
    options.hasSeperatorLine = true;
    options.seperatorLineHasInsets = false;
    
    Color txtColor = {0,0,0};
    Color bgColor = {1,1,1};
    options.textColor = txtColor;
    options.menuBackgroundColor = bgColor;
    NSMutableArray *menuItems=[[NSMutableArray alloc] init];
    
    
    for (ZZDictModel *item in arr) {
        KxMenuItem *item1 =[KxMenuItem menuItem:item.name
                                          image:[UIImage imageNamed:@""]
                                            tag:(int)sender.tag
                                         objTag:item
                                         target:self
                                         action:@selector(pushMenuItem:)];
        [item1 setForeColor:[UIColor blackColor]];
        [item1 setAlignment:NSTextAlignmentCenter];
        [menuItems addObject:item1];
    }
    
    
    [KxMenu setTitleFont:ListDetailFont];
    CGRect f = sender.frame;
    f.origin.y = f.origin.y + NavBarHeight;
    [KxMenu showMenuInView:self.view fromRect:f menuItems:menuItems withOptions:options];
}

/**
 *  menu 点击事件
 *
 *  @param sender
 */
-(void) pushMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem*) sender;
    checkModel = item.objTag;
    
    
    [_checkButton setTitle:item.title forState:UIControlStateNormal];
    
    
    [self refreshData];
    
    
}

#pragma mark - Table view data source
-(UIView *)createTableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    [img setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [view addSubview:img];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/2-80, 60)];
    label.numberOfLines = 1;
    [label setText:@"选择科室"];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:ListDetailFont];
    [label setTextColor:UIColorFromRGB(TextSizeNineColor)];
    [view addSubview:label];
    
    
    CGFloat xw = ScreenWidth/2 + 30;
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect bf = CGRectMake(ScreenWidth/2 - 60, 15, xw, 30);
    [_checkButton setFrame:bf];
    [_checkButton setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    _checkButton.layer.cornerRadius = 4.0f;
    _checkButton.layer.masksToBounds = YES;
    _checkButton.layer.borderColor = UIColorFromRGB(BgListSectionColor).CGColor;
    _checkButton.layer.borderWidth = 1.0f;
    [_checkButton.titleLabel setFont:ListDetailFont];
    [_checkButton setTitle:[NSString stringWithFormat:@"选择科室"] forState:UIControlStateNormal];
    [_checkButton setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    [view addSubview:_checkButton];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(xw - 15, 12, 8, 8)];
    [arrow setImage:[UIImage imageNamed:@"search_dropdown"]];
    [_checkButton addSubview:arrow];
    
    [_checkButton addTarget:self action:@selector(checkConfigLoading:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        
    }
    return nil;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDoctorCell *cell = (ZZDoctorCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    if(loginUser.isDoctor){
        if(selectIndex == 1){
            cell.cellType = ZZDoctorCellTypeDel;
        }else{
            
            cell.cellType = ZZDoctorCellTypeStar;
        }
    }else{
        cell.cellType =  ZZDoctorCellTypeDefault;
    }
    cell.delegate = self;
    ZZUserInfo *model=[_listArray objectAtIndex:indexPath.section];
    
    
    [cell dataToView:model];
    
    
    return cell;
}

-(void)onDoctorCellClick:(ZZDoctorCellType)type model:(ZZUserInfo *)model{
    if(type == ZZDoctorCellTypeDel){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"fromUserId"];
        [dict setObject:convertIntToString(model.userId) forKey:@"toUserId"];
        [ZZRequsetInterface post:API_delMyDoctorList param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [_listArray removeObject:model];
            [_listTable reloadData];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    
    // 关注，取消关注
    if(type == ZZDoctorCellTypeStar){
        // 关注
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(model.userId) forKey:@"toUserId"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"forUserId"];
        //        [dict setObject:convertToString(@"") forKey:@"context"];
        [ZZRequsetInterface post:API_followUserDoctor param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            model.state = 3;
            [_listTable reloadData];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
    [_listTable reloadData];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZUserInfo *model = [_listArray objectAtIndex:indexPath.section];
    ZZDoctorDetailController *listVC = [[ZZDoctorDetailController alloc] init];
    listVC.docId = model.userId;
    ZZUserHomeModel *home = [ZZUserHomeModel new];
    home.docInfo = model;
    listVC.model = home;
    [self openNav:listVC sound:nil];
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

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
