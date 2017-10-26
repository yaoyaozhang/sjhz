//
//  ZZInviteDoctorController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZInviteDoctorController.h"


#import "UIView+Extension.h"
#import <MJRefresh.h>
#import "NirKxMenu.h"

#import "ZZDoctorCell.h"
#define cellIdentifier @"ZZDoctorCell"

#import "ZZDiscussController.h"

@interface ZZInviteDoctorController ()<UITableViewDelegate,UITableViewDataSource,ZZDoctorCellDelegate>{
    ZZUserInfo *loginUser;
    NSMutableDictionary *checkDict;
    
    ZZDictModel  *checkModel;
    
    int checkIndex;
}

@property(nonatomic,strong)UIButton         *checkButton;
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;


@end

@implementation ZZInviteDoctorController


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
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    
    
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:ListDetailFont,NSFontAttributeName,UIColorFromRGB(TextWhiteColor), NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:UIColorFromRGB(BgTitleColor) forKey:NSForegroundColorAttributeName];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    [self.titleMenu addSubview:segmentedControl];
    
    checkIndex = 0;
    [self refreshData];
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index)
    {
        case 0:
            if(checkIndex != 0){
                checkIndex = 0;
                [self refreshData];
            }
            break;
        case 1:
            if(checkIndex != 1){
                checkIndex = 1;
                [self refreshData];
            }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    checkDict = [[NSMutableDictionary alloc] init];
    
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:[NSString stringWithFormat:@"%@的医生朋友",loginUser.name] forState:UIControlStateNormal];
    
    
    
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    __weak typeof(self) weakSelf = self;
    _listTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    _listTable.tableHeaderView = [self createTableHeaderView];
    
    
    [self setTableSeparatorInset];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    if(_isRecommend){
        [self initSegmentedControl];
    }else if(_isInvited){
        [self.menuTitleButton setTitle:[NSString stringWithFormat:@"选择会诊医生"] forState:UIControlStateNormal];
        [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight - 40)];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"邀请" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
        [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        [btn.titleLabel setFont:ListTitleFont];
        btn.tag = OTHER_BUTTON;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self refreshData];
        
    }else{
        [self refreshData];
    }
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        if(_ResultBlock){
            _ResultBlock(checkDict);
        }
        [self goBack:nil];
    }
    
    if(sender.tag == OTHER_BUTTON){
        if(checkDict == nil || checkDict.allKeys.count==0){
            [self.view makeToast:@"你还没有选择医生哦！"];
            return ;
        }
        NSString *userids = @"";
        for (NSString *userid in checkDict.allKeys) {
            userids = [userids stringByAppendingFormat:@",%@",userid];
        }
        if(userids.length>0){
            userids = [userids substringFromIndex:1];
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertToString(userids) forKey:@"forUserId"];
        [dict setObject:convertIntToString(_model.tid) forKey:@"caseId"];
        [dict setObject:convertIntToString(_model.type) forKey:@"type"];
        [dict setObject:convertToString(@"0") forKey:@"firstDoc"];
        [ZZRequsetInterface post:API_AddOtherDoctor param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            ZZDiscussController *vc = [[ZZDiscussController alloc] init];
            vc.model = _model;
            vc.checkDoctors = checkDict;
            [self openNav:vc sound:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZNoticeInviteDoctorSucess" object:convertIntToString(_model.caseId)];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
        
       
        
    }
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

/** 下拉刷新 */
- (void)refreshData
{
    [_listArray removeAllObjects];
    [self loadMoreData];
}

/** 上拉加载 */
- (void)loadMoreData
{
    // 获取tid来拼接urlString
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    if(checkModel){
        [dict setObject:convertIntToString(checkModel.baseId) forKey:@"keshi"];
    }else{
        [dict setObject:@"0" forKey:@"keshi"];
    }
    
    [ZZRequsetInterface post:API_getMyDoctorList param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        
        if(_listArray.count < 20){
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
            
            [_listTable reloadData];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
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
    cell.cellType = ZZDoctorCellTypeCheck;
    cell.delegate = self;
    ZZUserInfo *model=[_listArray objectAtIndex:indexPath.section];
    
    [cell dataToView:model];
    
    
    return cell;
}

-(void)onDoctorCellClick:(ZZDoctorCellType)type model:(ZZUserInfo *)model{
    if(type == ZZDoctorCellTypeCheck){
        model.isChecked = !model.isChecked;
        if(!model.isChecked){
            [checkDict removeObjectForKey:convertIntToString(model.userId)];
        }else{
            [checkDict setObject:model forKey:convertIntToString(model.userId)];
        }
        [_listTable reloadData];
    }
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //	NSLog(@"%s", __func__);
    //	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //	cell.textLabel.textColor = [UIColor lightGrayColor];
    //    ZZDoctorUserCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
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
