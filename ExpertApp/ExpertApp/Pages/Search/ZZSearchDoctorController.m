//
//  ZZSearchDoctorController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSearchDoctorController.h"
#import <MJRefresh/MJRefresh.h>

#import "NirKxMenu.h"
#import "ZZDoctorCell.h"
#import "MyButton.h"
#define cellIndentifer @"ZZDoctorCell"

#import "ZZDoctorDetailController.h"
#import "ZZDictModel.h"


@interface ZZSearchDoctorController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>{
    MyButton *btnDepartment;
    MyButton *btnArea;
    
    
    NSMutableArray     *_listArray;
    UITableView        *_listTable;
    
    // 当前选择的标签
    
    int          pageNumber;
    
    
}


@property (nonatomic,strong) UITextField * searchTF;
@property (nonatomic,strong) UIImageView * searchImg;
@property (nonatomic,strong) UIButton    * cancelBtn;
@property (nonatomic,strong) UIImageView * arrowImg;
@property (nonatomic,strong) UIButton    * seletBtn;
@property (nonatomic,assign) int         Btntag;

@end

@implementation ZZSearchDoctorController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(BgSystemColor);
    [self layoutSearchBarView];
    
    [self setSearchTypeValue];
    [_searchTF becomeFirstResponder];
    
    _listArray = [[NSMutableArray alloc] init];
    
    [_listTable reloadData];
    
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        
    }];
}

-(void) setSearchTypeValue{
    if(_searchType == ZZSearchDoctorTypeHospital){
        [_seletBtn setTitle:@"医院" forState:UIControlStateNormal];
    }else if(_searchType == ZZSearchDoctorTypeDoctor){
        [_seletBtn setTitle:@"医生" forState:UIControlStateNormal];
    }else{
        [_seletBtn setTitle:@"默认" forState:UIControlStateNormal];
    }
}

#pragma mark -- 上拉加载
- (void)beginNetRefreshData{
    [_listArray removeAllObjects];
    pageNumber = 1;
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(pageNumber) forKey:@"page"];
    [dict setObject:convertToString(_searchTF.text) forKey:@"value"];
    [dict setObject:convertIntToString(_searchType) forKey:@"type"];
    if(btnDepartment && btnDepartment.objTag){
        ZZDictModel *model = btnDepartment.objTag;
        [dict setObject:convertToString(model.name) forKey:@"department"];
    }
    if(btnArea && btnArea.objTag){
        ZZDictModel *model = btnDepartment.objTag;
        [dict setObject:convertToString(model.name) forKey:@"region"];
    }
    [ZZRequsetInterface post:API_searchDoctor param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.footer && [_listTable.footer respondsToSelector:@selector(endRefreshing)]){
            [_listTable.footer endRefreshing];
        }
        
        NSString *jsonStr= @"{\"retData\":[{\"accomplished\":\"放假放假，皮肤病\",\"hospital\":\"海淀妇幼\",\"titleNmae\":\"高级职称,第二高级\",\"departmentName\":\"全部科室\",\"docName\":\"李丹\",\"imageUrl\":\"url:/upload/uhead/2017-09-06/demoUploadimage1001504693326.jpg\",\"userId\":\"7\",\"docId\":1}]}";
        NSDictionary *dict = [ZCLocalStore dictionaryWithJsonString:jsonStr];
        
        NSArray *arr = dict[@"retData"];
        
        for (NSDictionary *item in arr) {
            [_listArray addObject:[[ZZUserHomeModel alloc] initWithMyDict:item]];
        }
        
        [_listTable reloadData];
    } complete:^(NSDictionary *dict) {
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [_listTable reloadData];
    } progress:^(CGFloat progress) {
        
    }];
}

- (void)dismissAction:(UIButton*)sender{
    [self.searchTF resignFirstResponder];
    [self goBack:nil];
}

// 值变化
- (void)textChangAction:(UITextField*)textFiled{
//    if(is_null(textFiled.text)){
//        [self createPlaceholderView:@"搜素医生信息" message:@"" image:[UIImage imageNamed:@"icon_search"] withView:_listTable action:nil];
//    }else{
//        [self removePlaceholderView];
//    }
//    [_listTable reloadData];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (!is_null(textField.text)) {
        [[ZZDataCache getInstance] setSearchKeyword:convertToString(textField.text)];
        
        [self beginNetRefreshData];
    }
    
    [self keyboardHidde];
    return YES;
}


- (void)keyboardHidde{
    
    NSLog(@"ksjdh");
    [_searchTF resignFirstResponder];
    [KxMenu dismissMenu];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _listTable) {
        CGFloat sectionHeaderHeight = 10;
        
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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


#pragma mark 搜索
-(void)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"有变化了");
//    if(is_null(searchBar.text)){
//        
//        [self createPlaceholderView:@"搜素医生信息" message:@"" image:[UIImage imageNamed:@"icon_search"] withView:_listTable action:nil];
//    }else{
//        [self removePlaceholderView];
//    }
//    
//    [_listTable reloadData];
    
}


#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count==0?1:_listArray.count+1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        CGFloat h = 60.0f;
        NSArray *arr = [[ZZDataCache getInstance] getSearchKeyWork];
        if(arr.count > 0){
            
            
            CGFloat x = 10.0f;
            CGFloat y = 99.0f;
            for (NSString *keyword in arr) {
                
                CGFloat tw = [ZZCoreTools getWidthContain:keyword font:ListTimeFont Height:22];
                if(tw > ScreenWidth - x){
                    y = y + 22 + 5;
                    x = 10.0;
                }
                x = x + tw;
            }
            
            h = y + 22 + 20.0f;
        }

        return h;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        CGFloat headerH = 60.0f;
        UIView *headerView = [[UIView alloc] init];
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        
        [self createMenuButton:headerView tag:1];
        [self createMenuButton:headerView tag:2];
        
        NSArray *arr = [[ZZDataCache getInstance] getSearchKeyWork];
        if(arr.count > 0){
            
            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, ScreenWidth-20, 1.0f)];
            [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
            [headerView addSubview:lineView];
            
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 71, ScreenWidth - 80, 20)];
            [label setText:@"最近搜索"];
            [label setFont:ListDetailFont];
            [headerView addSubview:label];
            
            UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [delButton setImage:[UIImage imageNamed:@"search_cleanup"] forState:UIControlStateNormal];
            [delButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [delButton setFrame:CGRectMake(ScreenWidth-54, 71, 44, 20)];
            [delButton setBackgroundColor:[UIColor clearColor]];
            [delButton addTarget:self action:@selector(cleanupKeyword:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:delButton];
            
            CGFloat x = 10.0f;
            CGFloat y = 99.0f;
            for (NSString *keyword in arr) {
                CGRect f = [self createKeywordButton:keyword view:headerView x:x y:y maxW:ScreenWidth - x];
                x = x + f.size.width;
                y = f.origin.y;
            }
            
            headerH = y + 22 + 20.0f;
        }
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, headerH)];
        
        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDoctorCell *cell = (ZZDoctorCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[ZZDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    if(indexPath.section==_listArray.count){
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
    
    [cell dataToView:_listArray[indexPath.section-1]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ZZUserHomeModel *model =  _listArray[indexPath.section-1];
    ZZDoctorDetailController  *listVC = [[ZZDoctorDetailController alloc]init];
    listVC.docId = model.userId;
    listVC.model = model;
    [self openNav:listVC sound:nil];
//    [self.searchTF resignFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}


-(void)cleanupKeyword:(UIButton *) sender{
    [ZCLocalStore removeObjectforKey:KEY_SEARCH_KEYWORD];
    [_listTable reloadData];
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
    _searchType = item.intTag;
   
    [self setSearchTypeValue];
}
-(void) pushDropMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem*) sender;
    if(item.intTag==1){
        btnDepartment.objTag = item.objTag;
        [btnDepartment setTitle:item.title forState:UIControlStateNormal];
    }else{
        btnArea.objTag = item.objTag;
        [btnArea setTitle:item.title forState:UIControlStateNormal];
    }
}


-(void)keyworkOnClick:(UIButton *) sender{
    _searchTF.text =sender.titleLabel.text;
    [self beginNetRefreshData];
}



-(void)createMenuButton:(UIView *) pview tag:(int) tag{
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTimeFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    [btn addTarget:self action:@selector(btnShowDropMenu:) forControlEvents:UIControlEventTouchUpInside];
    if(tag == 1){
        btn.tag = 1;
        [btn setTitle:@"全部科室" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(10, 15, (ScreenWidth-30)/2, 30)];
        btnDepartment = btn;
    }else{
        btn.tag = 2;
        [btn setTitle:@"全部地区" forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(20 + (ScreenWidth-30)/2, 15, (ScreenWidth-30)/2, 30)];
        btnArea = btn;
    }
    // 箭头
    UIImageView * arrawImg = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-30)/2 - 20, 10, 8, 8)];
    arrawImg.image = [UIImage imageNamed:@"search_dropdown"];
    [btn addSubview:arrawImg];
    
    [pview addSubview:btn];
}



-(CGRect )createKeywordButton:(NSString *) text view:(UIView *) pView x:(CGFloat) px y:(CGFloat) py maxW:(CGFloat ) maxWidth{
    CGRect f = CGRectMake(px, py, maxWidth, 22);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn.titleLabel setFont:ListTimeFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    [btn addTarget:self action:@selector(keyworkOnClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat tw = [ZZCoreTools getWidthContain:text font:btn.titleLabel.font Height:22];
    if(tw > maxWidth){
        f.origin.y = py + 22 + 5;
        f.origin.x = 10.0;
    }
    f.size.width = tw + 20;
    [btn setFrame:f];
    [pView addSubview:btn];
    return f;
    
}

-(void)btnShowDropMenu:(UIButton *) sender{
    NSString *configKey = @"";
    if(sender.tag == 2){
        configKey = KEY_CONFIG_REGION;
    }
    if(sender.tag == 1){
        configKey = KEY_CONFIG_DEPARTMENT;
    }
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:configKey];
    if(arr==nil || arr.count==0){
        return;
    }
    
    [self keyboardHidde];
    
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
                                         action:@selector(pushDropMenuItem:)];
        [item1 setForeColor:[UIColor blackColor]];
        [item1 setAlignment:NSTextAlignmentCenter];
        [menuItems addObject:item1];
    }
    
    
    [KxMenu setTitleFont:ListDetailFont];
    CGRect f = sender.frame;
    f.origin.y = f.origin.y + NavBarHeight;
    [KxMenu showMenuInView:self.view fromRect:f menuItems:menuItems withOptions:options];
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
    
    
    // 灰色背景
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(61, StatusBarHeight+5, ScreenWidth - 58 - 71, 26)];
    bgView.backgroundColor = UIColorFromRGB(BgSystemColor);
    bgView.layer.cornerRadius = 3.5f;
    bgView.layer.masksToBounds = YES;
    [self.titleMenu addSubview:bgView];
    
    // 收索img
    UIImageView * searchImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 14, 26)];
    searchImg.image = [UIImage imageNamed:@"icon_search"];
    searchImg.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:searchImg];
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(searchImg.frame) + 10, 0, CGRectGetWidth(bgView.frame) - 34, 26)];
    _searchTF.placeholder = @"医生/医院";
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTF.delegate = self;
    _searchTF.font = [UIFont systemFontOfSize:14];
    [_searchTF addTarget:self action:@selector(textChangAction:) forControlEvents:UIControlEventEditingChanged];
    _searchTF.keyboardType = UIKeyboardTypeWebSearch;
    [bgView addSubview:_searchTF];
    
    // 取消btn
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(CGRectGetMaxX(bgView.frame)+10, StatusBarHeight + 5, 48, 26);
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleMenu addSubview:_cancelBtn];
    
    // 线条
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.titleMenu.frame)-1, ScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(BgTitleColor);
    [self.titleMenu addSubview:lineView];
    
    pageNumber = 1;
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight -NavBarHeight) style:UITableViewStylePlain];
    _listTable.dataSource = self;
    _listTable.delegate = self;
    [_listTable setBackgroundColor:[UIColor clearColor]];
    [_listTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
    
    
    
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
