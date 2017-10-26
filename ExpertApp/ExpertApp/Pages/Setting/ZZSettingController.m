//
//  ZZSettingController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSettingController.h"


#import "UIView+Extension.h"

#import "ZZSettingCell.h"
#define cellIdentifier @"ZZSettingCell"

#import "ZZSettingUserCell.h"
#define cellIdentifierUser @"ZZSettingUserCell"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

#import "ZZEditUserController.h"
#import "ZZMyHZListController.h"
#import "ZZArchivesController.h"
#import "ZZAttentionController.h"
#import "ZZCollectionController.h"
#import "ZZSettingHelpController.h"

#import "ZZPerfectInfoController.h"
#import "ZZDoctorChapterController.h"
#import "ZZFansController.h"
#import "ZZDrawMoneyController.h"


@interface ZZSettingController ()<UITableViewDelegate,UITableViewDataSource>{
    ZZUserInfo *loginUser;
}

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)YWFeedbackKit *feedbackKit;

@end

@implementation ZZSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"个人信息" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = YES;
    
    [self createTableView];
    [self loadMoreData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged:) name:@"ZZNoticeUserInfoChanged" object:nil];
}

-(void)userInfoChanged:(NSNotification *) info{
    [self loadMoreData];
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:@"24571002" appSecret:@"15dce9f0e0ebb590542e165703c7687e"];
    }
    return _feedbackKit;
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierUser bundle:nil] forCellReuseIdentifier:cellIdentifierUser];
    
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
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    [_listArray removeAllObjects];
    [_listArray addObject:@[@{@"avatar":convertToString(loginUser.imageUrl),@"uname":convertToString(loginUser.userName),@"num":convertIntToString(loginUser.tcNumber)}]];
    
    if(loginUser.isDoctor != 1){
        NSArray *arr1 = @[@{@"code":@"1",@"icon":@"my_consultationresult",@"text":@"会诊结果"},
                          @{@"code":@"2",@"icon":@"my_healthrecords",@"text":@"健康档案"},
                          @{@"code":@"3",@"icon":@"my_doctor",@"text":@"我的医生"},
                          @{@"code":@"4",@"icon":@"my_collection",@"text":@"我的收藏"}];
        [_listArray addObject:arr1];
        
        NSArray *arr2 = @[@{@"code":@"5",@"icon":@"my_set",@"text":@"设置与帮助"},
                          @{@"code":@"6",@"icon":@"my_recommend",@"text":@"推荐给朋友"},
                          @{@"code":@"7",@"icon":@"my_opinion",@"text":@"意见反馈"}];
        [_listArray addObject:arr2];
    }else{
        NSArray *arr1 = @[@{@"code":@"8",@"icon":@"my_data",@"text":@"我的资料"},
                          @{@"code":@"9",@"icon":@"my_article",@"text":@"文章管理"},
                          @{@"code":@"10",@"icon":@"my_fans",@"text":@"我的粉丝"},
                          @{@"code":@"11",@"icon":@"Doctor_friend",@"text":@"我的医生朋友"}];
        [_listArray addObject:arr1];
        
        NSArray *arr2 = @[@{@"code":@"12",@"icon":@"my_set",@"text":@"设置与帮助"},
                          @{@"code":@"13",@"icon":@"my_withdrawdeposit",@"text":@"提现管理"}];
        [_listArray addObject:arr2];
    }
    [_listTable reloadData];
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 10;
    }
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
    NSArray *arr = _listArray[section];
    return arr.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZSettingUserCell *cell = (ZZSettingUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierUser];
        if (cell == nil) {
            cell = [[ZZSettingUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierUser];
        }
        
        [cell dataToView:_listArray[indexPath.section][indexPath.row]];
        
        return cell;
    }
    ZZSettingCell *cell = (ZZSettingCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    [cell dataToView:_listArray[indexPath.section][indexPath.row]];
    
    
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
    if(indexPath.section == 0){
        ZZEditUserController *vc = [[ZZEditUserController alloc] init];
        [self openNav:vc sound:nil];
        return;
    }
    
    int code =  [_listArray[indexPath.section][indexPath.row][@"code"] intValue];
    
    if(code == 1){
        ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(code == 2){
        ZZArchivesController *vc = [[ZZArchivesController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(code == 3 || code == 10){
        ZZFansController *vc = [[ZZFansController alloc] init];
        [self openNav:vc sound:nil];
    }
    
    
    if(code == 4){
        ZZCollectionController *vc = [[ZZCollectionController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(code == 5 || code == 12){
        ZZSettingHelpController *vc = [[ZZSettingHelpController alloc] init];
        [self openNav:vc sound:nil];
    }
    
    if(code == 8){
        ZZEditUserController *vc = [[ZZEditUserController alloc] init];
        [self openNav:vc sound:nil];
    }
    
    if(code == 9){
        ZZDoctorChapterController *vc = [[ZZDoctorChapterController alloc] init];
        vc.docInfo = loginUser;
        [self openNav:vc sound:nil];
    }
    if(code == 11){
        ZZAttentionController *vc = [[ZZAttentionController alloc] init];
        
        [self openNav:vc sound:nil];
    }
    
    if(code == 13){
        ZZDrawMoneyController *vc = [[ZZDrawMoneyController alloc] init];
        [self openNav:vc sound:nil];
    }
    
    if(code == 7){
        /** 设置App自定义扩展反馈数据 */
        self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                     @"visitPath":@"登陆->关于->反馈",
                                     @"userid":@"yourid",
                                     @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};

        
        __weak typeof(self) weakSelf = self;
        [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(BCFeedbackViewController *viewController, NSError *error) {
            [viewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                // 进行 dismiss 或者 pop，以及一些相关设置
                [weakSelf goBack:nil];
            }];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            
            if ([nav.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
                [nav.navigationBar setBarTintColor:UIColorFromRGB(BgTitleColor)];
                [nav.navigationBar setTranslucent:YES];
                [nav.navigationBar setTintColor:[UIColor whiteColor]];
            }else{
                [nav.navigationBar setBackgroundColor:UIColorFromRGB(BgTitleColor)];
            }
            [nav.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,TitleFont, NSFontAttributeName, nil]];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];

        
        
        [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
            NSLog(@"消息数%zd",unreadCount);
        }];
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
