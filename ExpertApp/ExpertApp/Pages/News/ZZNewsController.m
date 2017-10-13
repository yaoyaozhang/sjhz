//
//  ZZNewsController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/1.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNewsController.h"
#import "ZZNewsCell.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#define cellIdentifier @"ZZNewsCell"
#import "UIView+Border.h"

#import "ZZNewsListController.h"


@interface ZZNewsController ()<UITableViewDataSource,UITableViewDelegate>{
    ZZUserInfo *loginUser;
    int page;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *caseArray;
@property(nonatomic,strong)NSMutableArray   *xtArray;

@end

@implementation ZZNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    
    loginUser = [ZZDataCache getInstance].getLoginUser;
    
    page = 1;
    
    [self.menuTitleButton setTitle:@"消息" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = YES;
    
    [self createTableView];
}



-(void)createTableView{
    _caseArray = [[NSMutableArray alloc] init];
    _xtArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(_caseArray.count == 0 || _xtArray.count == 0){
        [self loadMoreData];
    }
}


-(void)headerMoreClick:(UIButton *) btn{
    if(btn.tag == 0){
        // 消息
        ZZNewsListController *listVC = [[ZZNewsListController alloc] init];
        listVC.newType = ZZNewsTypeCase;
        [self openNav:listVC sound:nil];
    }
    if(btn.tag == 1){
        // 公告
        // 消息
        ZZNewsListController *listVC = [[ZZNewsListController alloc] init];
        listVC.newType = ZZNewsTypeSystem;
        [self openNav:listVC sound:nil];
    }
}

/**
 加载更多
 */
-(void)loadMoreData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(7) forKey:@"userId"];
    [ZZRequsetInterface post:API_findNewsTops param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        [_caseArray removeAllObjects];
        [_xtArray removeAllObjects];
        
        NSDictionary  * ret = dict[@"retData"];
        if(ret && ret[@"caseMsg"]){
            NSArray *caseMsg = ret[@"caseMsg"];
            for (NSDictionary *item in caseMsg) {
                [_caseArray addObject:[[ZZNewsModel alloc] initWithMyDict:item]];
            }
        }
        if(ret && ret[@"xtMsg"]){
            NSArray *caseMsg = ret[@"xtMsg"];
            for (NSDictionary *item in caseMsg) {
                [_xtArray addObject:[[ZZNewsModel alloc] initWithMyDict:item]];
            }
        }
        [_listTable reloadData];
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
    if(section == 0){
        return 50;
    }
    return 65;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat hy = 15;
    if(section == 0){
        hy = 0;
    }
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50+hy)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, hy, ScreenWidth, 50)];
    [imgView setImage:[UIImage imageNamed:@"classificationbg"]];
    [imgView setBackgroundColor:[UIColor whiteColor]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [titleView addSubview:imgView];
    
    UILabel *_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, hy, ScreenWidth, 50)];
    [_headerLabel setBackgroundColor:[UIColor clearColor]];
    [_headerLabel setFont:ListTitleFont];
    if(section==0){
        [_headerLabel setText:@"会诊消息"];
    }else{
        [_headerLabel setText:@"系统公告"];
    }
    [_headerLabel setTextAlignment:NSTextAlignmentCenter];
    [_headerLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    [titleView addSubview:_headerLabel];
    
    UIButton *btnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnButton addTarget:self action:@selector(headerMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [btnButton setFrame:CGRectMake(ScreenWidth - 50, hy, 50, 50)];
    [btnButton setContentMode:UIViewContentModeCenter];
    [btnButton setBackgroundColor:[UIColor clearColor]];
    btnButton.tag = section;
    [titleView addSubview:btnButton];
    [titleView addBottomBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:0.75f];
    return titleView;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return _caseArray.count;
    }
    return _xtArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZNewsCell *cell = (ZZNewsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
//    if(indexPath.row==_listArray.count-1){
//        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//            [cell setSeparatorInset:UIEdgeInsetsZero];
//        }
//        
//        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//            [cell setLayoutMargins:UIEdgeInsetsZero];
//        }
//        
//        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
//            [cell setPreservesSuperviewLayoutMargins:NO];
//        }
//    }
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
   
    
    ZZNewsModel *model= nil;
    if(indexPath.section == 0){
        model=[_caseArray objectAtIndex:indexPath.row];
    }else{
        model=[_xtArray objectAtIndex:indexPath.row];
    }
    
//    [cell InitDataToView:model row:indexPath.row];
    [cell dataToView:indexPath model:model];
    
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
    
    ZZNewsModel *model= nil;
    if(indexPath.section == 0){
        model=[_caseArray objectAtIndex:indexPath.row];
    }else{
        model=[_xtArray objectAtIndex:indexPath.row];
    }
    if(model == nil){
        return;
    }
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < (indexPath.section == 0? _caseArray.count:_xtArray.count)){
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
