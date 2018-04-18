//
//  ZZKnowledgeSearchResultController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//
#import "ZZKnowledgeSearchResultController.h"
#import <MJRefresh.h>
#import "UIImage+ImageWithColor.h"

#define cellIndentiferRich @"ZZKnowledgeRichCell"
#define cellIndentifer @"ZZKnowledgeItemsCell"

#import "ZZKnowledgeRichCell.h"
#import "ZZKnowledgeItemsCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ZZKnowledgeSearchResultController ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    int page;
}


@property (nonatomic,strong) UITableView * listTable;
@property (nonatomic,strong) NSMutableArray * listArray;

@end

@implementation ZZKnowledgeSearchResultController

- (void)loadCollectionView
{
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _listArray = [[NSMutableArray alloc] init];
    page = 1;
    [self loadCollectionView];
}


-(void)loadResult:(NSString *)text{
    //调取接口
    //刷新数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(text) forKey:@"title"];
    [dict setObject:@"24" forKey:@"pageSize"];
    [dict setObject:convertIntToString(page) forKey:@"pageNum"];
    [ZZRequsetInterface post:API_searchWikit param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [SVProgressHUD dismiss];
        //            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //            NSArray *arr = [dict objectForKey:@"lemmaList"];
        //            [_listArray addObjectsFromArray:arr];
        //            [_collectionView reloadData];
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        
        if(page == 1){
            [_listArray removeAllObjects];
        }
        
        for (NSDictionary *item in arr) {
//            [_listArray addObject:[[LemmaModel alloc] initWithMyDict:item]];
        }
        [_listTable reloadData];
        if(arr.count >= 24){
            page = page  + 1;
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
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
