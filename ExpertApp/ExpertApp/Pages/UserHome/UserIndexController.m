//
//  UserIndexController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "UserIndexController.h"

#import <MJRefresh/MJRefresh.h>

#import "NirKxMenu.h"
#import "ZZUserIndexCell.h"
#define cellIndentifer @"ZZUserIndexCell"

#import "ZZSearchDoctorController.h"
#import "ZZDoctorDetailController.h"
#import <UShareUI/UShareUI.h>
#import "ZZShareView.h"

#import "ZZCommentController.h"


@interface UserIndexController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,ZZUserIndexCellDelegate>{
    
    NSMutableArray     *_listArray;
    UITableView        *_listTable;
    // 当前选择的标签
    int         curCheckTag;
    int          pageNumber;
    
    ZZUserInfo *loginUser;
}


@property (nonatomic,strong) UIButton * searchButton;
@property (nonatomic,strong) UIImageView * searchImg;
@property (nonatomic,strong) UIImageView * arrowImg;
@property (nonatomic,strong) UIButton    * seletBtn;
@property (nonatomic,assign) int         Btntag;

@end

@implementation UserIndexController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -- searchBar
- (void)layoutSearchBarView{
    
    // 状态栏
    self.titleMenu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    //    [self.titleMenu setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [self.titleMenu setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [self.titleMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.titleMenu];
    
    UIView * statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusView.backgroundColor = UIColorFromRGB(BgTitleColor);
    [self.titleMenu addSubview:statusView];
    
    // 选项
    self.seletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seletBtn setTitle:@"类别" forState:UIControlStateNormal];
    _seletBtn.frame = CGRectMake(10, StatusBarHeight+5, 40, 26);
    [_seletBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [_seletBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.seletBtn.titleLabel.font = ListDetailFont;
    self.seletBtn.backgroundColor = [UIColor clearColor];
    [self.seletBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.titleMenu addSubview:_seletBtn];
    
    // 箭头
    UIImageView * arrawImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_seletBtn.frame)-10, 10, 8, 8)];
    arrawImg.image = [UIImage imageNamed:@"nav_dropdown"];
    [self.seletBtn addSubview:arrawImg];
    
    
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setFrame:CGRectMake(61, StatusBarHeight+5, ScreenWidth - 71, 26)];
    [self.searchButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [self.searchButton setTitle:@"搜索医生、医院" forState:UIControlStateNormal];
    _searchButton.backgroundColor = UIColorFromRGB(TextWhiteColor);
    _searchButton.layer.cornerRadius = 3.5f;
    [_searchButton.titleLabel setFont:ListDetailFont];
    [_searchButton setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
    [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_searchButton addTarget:self action:@selector(doSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.titleMenu addSubview:_searchButton];
    
    // 线条
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.titleMenu.frame)-1, ScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(BgLineColor);
    [self.titleMenu addSubview:lineView];
    
    
    
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight - TabBarHeight) style:UITableViewStylePlain];
    _listTable.dataSource = self;
    _listTable.delegate = self;
    [_listTable setBackgroundColor:[UIColor clearColor]];
//    [_listTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if(iOS7){
        [_listTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_listTable setTableFooterView:view];
    
    [self.view addSubview:_listTable];
    // 注册
    [_listTable registerNib:[UINib nibWithNibName:cellIndentifer bundle:nil] forCellReuseIdentifier:cellIndentifer];
    _listArray  = [[NSMutableArray alloc] init];
    [self setTableSeparatorInset];
    
    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    curCheckTag = ZZSearchDoctorTypeDefault;
    
//    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginNetRefreshData)];
//    header.stateLabel.hidden = YES;
//    _listTable.header = header;
    // 占位图
//    [self createPlaceholderView:@"搜素医生信息" message:@"" image:[UIImage imageNamed:@"icon_search"] withView:_listTable action:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHidde)];
    tap.delegate =self;
    [self.view addGestureRecognizer:tap];
    
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    return YES;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(BgSystemColor);
    [self layoutSearchBarView];
    
    pageNumber = 1;
    _listArray = [[NSMutableArray alloc] init];
    
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    
    [self beginNetRefreshData];
    
}

#pragma mark -- 上拉加载
- (void)beginNetRefreshData{
    [_listArray removeAllObjects];
    [SVProgressHUD show];
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_findUserHome param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if(_listTable.footer && [_listTable.footer isRefreshing]){
            [_listTable.footer endRefreshing];
        }
        if(_listTable.header && [_listTable.header isRefreshing]){
            [_listTable.header endRefreshing];
        }
        
        
        if(_listArray.count == 0){
            [self createPlaceholderView:@"网络开小差了！" message:@"" image:nil withView:_listTable action:^(UIButton *button) {
                [self endNetRefreshData];
            }];
        }else{
            [self removePlaceholderView];
        }
        
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        
        for (NSDictionary *item in arr) {
            [_listArray addObject:[[ZZUserHomeModel alloc] initWithMyDict:item]];
        }
        
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

// 值变化
- (void)doSearchClick:(UIButton *)sender{
    [self keyboardHidde];
    
    ZZSearchDoctorController *vc = [[ZZSearchDoctorController alloc] init];
    vc.searchType = curCheckTag;
    [self openNav:vc sound:nil];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:NO completion:^{
//        
//    }];
    
}

- (void)keyboardHidde{
    [KxMenu dismissMenu];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

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




#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZUserIndexCell *cell = (ZZUserIndexCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[ZZUserIndexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
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
    cell.delegate = self;
    [cell dataToCellView:_listArray[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZZUserHomeModel *model =  _listArray[indexPath.row];
    ZZDoctorDetailController  *listVC = [[ZZDoctorDetailController alloc]init];
    listVC.docId = model.docInfo.userId;
    listVC.model = model;
    [self openNav:listVC sound:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}


- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems=[[NSMutableArray alloc] init];
    
    KxMenuItem *item0 =[KxMenuItem menuItem:@"默认"
                                      image:[UIImage imageNamed:@""]
                                        tag:ZZSearchDoctorTypeDefault
                                     target:self
                                     action:@selector(pushMenuItem:) ];
    [item0 setForeColor:[UIColor blackColor]];
    [item0 setAlignment:NSTextAlignmentCenter];
    [menuItems addObject:item0];
    
    KxMenuItem *item1 =[KxMenuItem menuItem:@"医生"
                                      image:[UIImage imageNamed:@""]
                                        tag:ZZSearchDoctorTypeDoctor
                                     target:self
                                     action:@selector(pushMenuItem:) ];
    [item1 setForeColor:[UIColor blackColor]];
    [item1 setAlignment:NSTextAlignmentCenter];
    [menuItems addObject:item1];
    
    
    KxMenuItem *item2 =[KxMenuItem menuItem:@"医院"
                                      image:[UIImage imageNamed:@""]
                                        tag:ZZSearchDoctorTypeHospital
                                     target:self
                                     action:@selector(pushMenuItem:)];
    [item2 setForeColor:[UIColor blackColor]];
    [item2 setAlignment:NSTextAlignmentCenter];
    [menuItems addObject:item2];
    
    
    [KxMenu setTitleFont:ListDetailFont];
    OptionalConfiguration options;
    options.arrowSize = 6.5f;
    options.marginXSpacing = 5;
    options.marginYSpacing = 6;
    options.seperatorLineHasInsets = 5;
    options.menuCornerRadius = 3.0f;
    options.maskToBackground = true;
    options.shadowOfMenu = false;
    options.hasSeperatorLine = true;
    options.seperatorLineHasInsets = false;
    Color txtColor = {0,0,0};
    Color bgColor = {1,1,1};
    options.textColor = txtColor;
    options.menuBackgroundColor = bgColor;
    
    CGRect f = sender.frame;
    f.size.width = 60;
    [KxMenu showMenuInView:self.view
                  fromRect:f
                 menuItems:menuItems withOptions:options];
    
    
}

/**
 *  menu 点击事件
 *
 *  @param sender
 */
-(void) pushMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem*) sender;
    int tag = (int)item.intTag;
    if(curCheckTag == tag){
        return;
    }
    curCheckTag = tag;
    [_seletBtn setTitle:trimString(item.title) forState:UIControlStateNormal];
}


#pragma mark UITableViewCell代理
-(void)onUserIndexCellClick:(NSInteger)tag model:(ZZUserHomeModel *)model{
    if(tag == 11){
        ZZShareView *view = [[ZZShareView alloc] initWithShareType:ZZShareTypeUser vc:self];
        view.shareModel = model.docInfo;
        [view show];
    }else if(tag == 22){
        // 评论
        ZZCommentController *comVC = [[ZZCommentController alloc] init];
        comVC.nid = model.chpater.nid;
        [self openNav:comVC sound:nil];
    }else if(tag == 33){
        // 收藏
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(model.chpater.collect){
            [dict setObject:convertToString(@"0") forKey:@"collectiontType"];
        }else{
            [dict setObject:convertToString(@"1") forKey:@"collectiontType"];
        }
        [dict setObject:convertIntToString(model.chpater.nid) forKey:@"nid"];
        [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"uid"];
        [ZZRequsetInterface post:API_CollectChapter param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            
        } complete:^(NSDictionary *dict) {
            if(model.chpater.collect){
                [self.view makeToast:@"取消收藏成功!"];
            }else{
                [self.view makeToast:@"收藏成功!"];
            }
            
            model.chpater.collect = !model.chpater.collect;
            
            [_listTable reloadData];
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [self.view makeToast:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
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
