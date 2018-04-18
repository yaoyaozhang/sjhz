//
//  ZZKnowledgeSearchController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeSearchController.h"
#import <MJRefresh.h>
#import "ZZKnowledgeSearchResultController.h"
#import "UIImage+ImageWithColor.h"

#define cellIndentiferRich @"ZZKnowledgeRichCell"
#define cellIndentifer @"ZZKnowledgeItemsCell"

#import "ZZKnowledgeRichCell.h"
#import "ZZKnowledgeItemsCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ZZKnowledgeSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>{
    UISearchController * _searchVC;//搜索视图
    ZZKnowledgeSearchResultController * _searchTableView;//搜索结果的表格视图
    
    int page;
}


@property (nonatomic,strong) UITableView * listTable;
@property (nonatomic,strong) NSMutableArray * listArray;

@end

@implementation ZZKnowledgeSearchController

- (void)loadCollectionView
{
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight + 64, ScreenWidth, ScreenHeight -NavBarHeight-64) style:UITableViewStylePlain];
    _listTable.dataSource = self;
    _listTable.delegate = self;
    [_listTable setBackgroundColor:[UIColor redColor]];
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
    [_listTable registerNib:[UINib nibWithNibName:cellIndentiferRich bundle:nil] forCellReuseIdentifier:cellIndentiferRich];
    _listArray  = [[NSMutableArray alloc] init];
    [self setTableSeparatorInset];
    
    
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
    
    
    
}



//**************************项目中的导航栏一部分是自定义的View,一部分是系统自带的NavigationBar*********************************
- (void)setNavigationBarStyle{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.hidden=YES;
            }
        }
        //        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, iOS7?-20:0,ScreenWidth, NavBarHeight)];
        //        imageView.image=[UIImage imageWithColor:UIColorFromRGB(BgTitleColor)];
        //        imageView.tag=10001;
        //        [self.navigationController.navigationBar addSubview:imageView];
        //        [self.navigationController.navigationBar sendSubviewToBack:imageView];
    }
    
    if(iOS7){
        [self.navigationController.navigationBar setTranslucent:YES];
    }
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,TitleFont, NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgTitleColor)] forBarMetrics:UIBarMetricsDefault];
    
    [self createLeftBarItemSelect:@selector(goBack:) norImageName:nil highImageName:nil];
    //
    //     [UITabBar appearance].translucent = NO;
    //      [[UITabBar appearance] setBackgroundColor:UIColor.redColor];
}



- (void)createLeftBarItemSelect:(SEL)select norImageName:(NSString *)imageName highImageName:(NSString *)heightImageName{
    //12 * 19
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn addTarget:self action:select forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 44,44) ;
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else{
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setImage:[UIImage imageNamed:@"titlebar_back_normal"] forState:UIControlStateNormal];
    }
    if (heightImageName) {
        [btn setImage:[UIImage imageNamed:heightImageName] forState:UIControlStateHighlighted];
    }else{
        [btn setImage:[UIImage imageNamed:@"titlebar_back_pressed"] forState:UIControlStateHighlighted];
    }
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGBAlpha(TextWhiteColor, 0.7) forState:UIControlStateHighlighted];
    [btn setTitleColor:UIColorFromRGBAlpha(TextWhiteColor, 0.7) forState:UIControlStateDisabled];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    //    self.navigationItem.leftBarButtonItem = item;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace   target:nil action:nil];
    
    /**
     width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和  边界间距为5pix，所以width设为-5时，间距正好调整为0；width为正数 时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -5;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, item, nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarStyle];
    self.title = @"热点搜索";
    
    _listArray = [[NSMutableArray alloc] init];
    page = 1;
    
    [self loadCollectionView];
    [self createSearchController];
    if(convertToString(_searchText).length>0){
        [_searchVC.searchBar setText:_searchText];
    }else{
        [self beginNetRefreshData];
    }
}

#pragma mark 搜索视图
- (void)createSearchController
{
    //表格界面 UITableViewController表格视图控制器 tableview是表格视图
    _searchTableView = [[ZZKnowledgeSearchResultController alloc] init];
    //创建搜索界面
    _searchVC = [[UISearchController alloc]initWithSearchResultsController:_searchTableView];
    //    _searchVC.delegate=self;
    //把表格视图控制器跟搜索界面相关联（防止searchBar发生64像素的偏移量）
    self.definesPresentationContext = YES;
    
    __block ZZKnowledgeSearchController *safeSelf = self;
    [_searchTableView setBlock:^(NSString *link) {
//        NSString *webUrl = urlEncodedString(link);
//        NSURL *url = [NSURL URLWithString:webUrl];
//        SVWebViewController *web = [[SVWebViewController alloc] initWithURL:url];
//        [safeSelf openNav:web sound:nil];
    }];
    
    //在tableView存在右侧索引情况下防止搜索框右侧缺少一块
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, NavBarHeight, ScreenWidth, 64);
    [headerView setBackgroundColor:UIColor.clearColor];
    [headerView addSubview:_searchVC.searchBar];
    _searchVC.searchResultsUpdater = self;
    
    //修改searchBar的属性
    if(!ZC_iPhoneX){
        UIView *subView =_searchVC.searchBar.subviews[0];
        for (UIView *view in subView.subviews)
        {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
            {
                [view removeFromSuperview];
                //修改搜索框背景
                UIView *backView = [[UIView alloc] init];
                backView.backgroundColor = UIColorFromRGB(BgSystemColor);
                backView.frame = CGRectMake(0, -20, ScreenWidth, 64);
                [_searchVC.searchBar insertSubview:backView atIndex:0];
            }
            //自定义textField
            else if ([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField = (UITextField *)view;
                textField.layer.borderWidth = 0.5;
                textField.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
                textField.layer.cornerRadius = 2;
                textField.clipsToBounds = YES;
            }
        }
    }
    
    
    [self.view addSubview:headerView];
}

#pragma mark 搜索的协议方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //这句代码实现cell顶部和searchBar不发生重叠
    self.edgesForExtendedLayout = UIRectEdgeAll;
    //在点击搜索时会调用一次，点击取消按钮又调用一次
    //判断当前搜索是否在搜索状态还是取消状态
    if (_searchVC.isActive) {
        if (searchController.searchBar.text.length!=0) {
            
            //表示搜索状态
            //调取搜索的接口
            
            [self searchAllDateRequestWithDict:searchController.searchBar.text];
        }
    }
}
#pragma mark -- UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    [UIView animateWithDuration:0.1 animations:^{
        //修改取消按钮字体颜色
        searchController.searchBar.showsCancelButton = YES;
        UIButton *cancelBtn=[searchController.searchBar valueForKey:@"cancelButton"];
        [cancelBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    }];
}



#pragma mark -- 通讯录搜索接口
- (void)searchAllDateRequestWithDict:(NSString *)text
{
    //调取接口
    //刷新搜索界面的tableview
    [_searchTableView loadResult:text];
}

////////////////////////
#pragma mark -- 请求数据
- (void)beginNetRefreshData{
    page = 1;
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    
    [ZZRequsetInterface post:API_searchDoctor param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.footer && [_listTable.footer respondsToSelector:@selector(endRefreshing)]){
            [_listTable.footer endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        if(page == 1){
            [_listArray removeAllObjects];
        }
        NSArray *arr = dict[@"retData"];
        
        for (NSDictionary *item in arr) {
            [_listArray addObject:[[ZZUserInfo alloc] initWithMyDict:item]];
        }
        
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [_listTable reloadData];
    } progress:^(CGFloat progress) {
        
    }];
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



#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        
        ZZKnowledgeItemsCell *cell = (ZZKnowledgeItemsCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        }
        return cell;
    }
    else{
        
        ZZKnowledgeRichCell *cell = (ZZKnowledgeRichCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentiferRich];
        if (cell == nil) {
            cell = [[ZZKnowledgeRichCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentiferRich];
        }
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
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
