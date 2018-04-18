//
//  ZZKnowledgeHomeController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeHomeController.h"
#import "MyButton.h"
#import <MJRefresh.h>
#import "ZZKnowledgeSearchController.h"
#import "ZZDoctorChapterController.h"

#define cellIndentiferRich @"ZZKnowledgeRichCell"
#define cellIndentifer @"ZZKnowledgeItemsCell"

#import "ZZKnowledgeRichCell.h"
#import "ZZKnowledgeItemsCell.h"

#import "SDCycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ZZKnowledgeHomeController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate>{
   
    
    NSMutableArray     *_listArray;
    UITableView        *_listTable;
    SDCycleScrollView *_cycleScrollView;
    
    // 当前选择的标签
    
    int          pageNumber;
    ZZUserInfo *loginUser;
    
    NSArray *menuTitles;
    NSArray *menuIcons;
    
    
}



@property (nonatomic,strong) UIButton    * seletBtn;


@end

@implementation ZZKnowledgeHomeController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(BgSystemColor);
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"知识" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = YES;
    
    
    menuIcons = @[@"icon_knowledge_type1",@"icon_knowledge_type2",@"icon_knowledge_type3",@"icon_knowledge_type4",@"icon_knowledge_type5"];
    menuTitles = @[@"运动",@"养生",@"妇科",@"康复",@"医学"];
    
    [self layoutSearchBarView];
    
    _listArray = [[NSMutableArray alloc] init];
    
    [_listTable reloadData];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        
    }];
}



#pragma mark -- 上拉加载
-(void)btnGoSearch{
    ZZKnowledgeSearchController *vc = [[ZZKnowledgeSearchController alloc] init];
    [self openNav:vc sound:nil];
}

-(void)btnShowDropMenu:(UIButton *) sender{
    if(sender.tag == 1){
        // 编辑推荐
    }
    if(sender.tag == 2){
        // 精品课
    }
    
}

- (void)beginNetRefreshData{
    pageNumber = 1;
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
        if(pageNumber == 1){
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
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 245.0f;
    }
    
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1||section == 2){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [headerView addSubview:lineView];
        
        [self createMenuButton:headerView tag:(int)section];
        
        return headerView;
    }else if(section == 0){
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 245.0f)];
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        if(_cycleScrollView==nil){
            [self setupCycleImageCell];
        }
        _cycleScrollView.titlesGroup = ({
            NSMutableArray *titleArrayM = [NSMutableArray array];
            for (int i = 0; i < 3; i++) {
                [titleArrayM addObject:@"ssss"];
            }
            
            titleArrayM;
        });
        
        _cycleScrollView.imageURLStringsGroup = ({
            NSMutableArray *urlArrayM = [NSMutableArray array];
            for (int i = 0; i < 3; i++) {
                [urlArrayM addObject:@"http://www.sanjiahuizhen.com/images/zuqiu1.jpg"];
            }
            
            urlArrayM;
        });
        [_cycleScrollView setFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        [headerView addSubview:_cycleScrollView];
        
        [self createItemsMenuButton:headerView];
        
        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
     
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


-(void)createMenuButton:(UIView *) pview tag:(int) tag{
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [btn addTarget:self action:@selector(btnShowDropMenu:) forControlEvents:UIControlEventTouchUpInside];
    if(tag == 1){
        btn.tag = 1;
        [btn setTitle:@"编辑推荐" forState:UIControlStateNormal];
    }else{
        btn.tag = 2;
        [btn setTitle:@"精品课" forState:UIControlStateNormal];
    }
    
    [btn setFrame:CGRectMake(10, 17.5, ScreenWidth-40, 30)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    // 箭头
    UIImageView * lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 2, 20)];
    lineImg.backgroundColor = UIColorFromRGB(BgTitleColor);
    [btn addSubview:lineImg];
    
    // 箭头
    UIImageView * arrawImg = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-60, 0, 30, 30)];
    arrawImg.image = [UIImage imageNamed:@"icon_list_more"];
    [btn addSubview:arrawImg];
    
    [pview addSubview:btn];
}





#pragma mark -- searchBar
- (void)layoutSearchBarView{
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
    [_listTable registerNib:[UINib nibWithNibName:cellIndentiferRich bundle:nil] forCellReuseIdentifier:cellIndentiferRich];
    _listArray  = [[NSMutableArray alloc] init];
    [self setTableSeparatorInset];
    
    
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
    [headerView setBackgroundColor:UIColor.whiteColor];
    
    _seletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seletBtn setFrame:CGRectMake(15, 15, ScreenWidth - 30, 35)];
    _seletBtn.layer.cornerRadius = 17.5f;
    _seletBtn.layer.masksToBounds = YES;
    [_seletBtn setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [_seletBtn setImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [_seletBtn setTitle:@"搜索内容" forState:UIControlStateNormal];
    [_seletBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_seletBtn setTitleColor:UIColorFromRGB(TextLightDarkColor) forState:UIControlStateNormal];
    [_seletBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [_seletBtn addTarget:self action:@selector(btnGoSearch) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_seletBtn];
    _listTable.tableHeaderView = headerView;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        
        return NO;
        
    }
    
    return YES;
    
}



#pragma mark - 图片轮播
/** 设置轮播图 */
- (void)setupCycleImageCell
{
    // 网络加载 --- 创建带标题的图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 15, ScreenWidth, 150) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_big"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    [_cycleScrollView setBannerImageViewContentMode:UIViewContentModeScaleAspectFill];
    
    _cycleScrollView.delegate = self;
}

/** SDCycleScrollView轮播点击事件代理 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
}

-(void)onMenuClick:(UIButton *)btn{
    ZZDoctorChapterController *vc = [[ZZDoctorChapterController alloc] init];
    vc.fromType = (int)btn.tag;
    vc.pageTitle = menuTitles[btn.tag-1];
    [self openNav:vc sound:nil];
}


-(void)createItemsMenuButton:(UIView *) pview{
    CGFloat x = 30;
    CGFloat space = 29;
    CGFloat xw = (ScreenWidth - 60 - 116)/5;
    for (int i=0; i<menuTitles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x + space *i + xw*i, 165, xw, 65)];
        [btn setImage:[UIImage imageNamed:menuIcons[i]] forState:UIControlStateNormal];
        btn.tag = i+1;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 21, 0)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, xw, 21)];
        [label setText:menuTitles[i]];
        [label setFont:ListDetailFont];
        [label setTextAlignment:NSTextAlignmentCenter];
        [btn addSubview:label];
        [btn addTarget:self action:@selector(onMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [pview addSubview:btn];
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
