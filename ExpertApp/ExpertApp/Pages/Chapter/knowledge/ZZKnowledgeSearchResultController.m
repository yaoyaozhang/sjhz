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
#define cellIndentiferItems @"ZZKnowledgeItemTextCell"

#import "ZZKnowledgeRichCell.h"
#import "ZZKnowledgeItemsCell.h"
#import "ZZKnowledgeItemTextCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "ZZChapterDetailController.h"
#import "ExpertApp-Swift.h"
#import "ZZKnowledgeDetailController.h"

@interface ZZKnowledgeSearchResultController ()<UITableViewDelegate,UITableViewDataSource,ZZKnowledgeItemsCellDelegate>{
    
    
    int page;
    ZZChapterModel *playModel;
    
    ZZVoiceView *zzvoiceView;
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
    [_listTable registerNib:[UINib nibWithNibName:cellIndentiferItems bundle:nil] forCellReuseIdentifier:cellIndentiferItems];
    
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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(text) forKey:@"search"];
    [dict setObject:convertIntToString(_searchType) forKey:@"type"];
    
    [ZZRequsetInterface post:API_getKnowledgeSearch param:dict timeOut:HttpGetTimeOut start:^{
        
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
            if(_searchType == 2){
                [_listArray addObject:[[ZZKnowledgeTopicModel alloc] initWithMyDict:item]];
            }else if(_searchType == 3){
                [_listArray addObject:[[ZZTJListModel alloc] initWithMyDict:item]];
            }else{
                [_listArray addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
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
    if(_searchType == 1){
        ZZKnowledgeItemTextCell *cell = (ZZKnowledgeItemTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentiferItems];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentiferItems];
        }
        cell.delegate = self;
        [cell dataToView:[_listArray objectAtIndex:indexPath.row]];
        
        return cell;
    }else if(_searchType == 3){
        ZZKnowledgeItemsCell *cell = (ZZKnowledgeItemsCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        }
        cell.delegate = self;
        [cell dataToItem:[_listArray objectAtIndex:indexPath.row]];
        
        return cell;
    }else{
        ZZKnowledgeRichCell *cell = (ZZKnowledgeRichCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentiferRich];
        if (cell == nil) {
            cell = [[ZZKnowledgeRichCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentiferRich];
        }
        [cell dataToItem:[_listArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(_searchType == 1){
        [self chapterOnClick:[_listArray objectAtIndex:indexPath.row] playArr:_listArray from:1];
    }
    
    if(_searchType == 2){
        ZZKnowledgeTopicModel *itemModel = [_listArray objectAtIndex:indexPath.row];
        
        
        ZZKnowledgeDetailController *vc = [[ZZKnowledgeDetailController alloc] init];
        vc.model = itemModel;
        [self openNav:vc sound:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}




-(void)onItemClick:(id)model type:(int)type obj:(NSMutableArray *)arr{
    if(type == 1){
        ZZChapterModel *itemModel = (ZZChapterModel *)model;
        // 播放、暂停
        
        [self chapterOnClick:itemModel playArr:arr from:1];
    }
    
    if(type == 2){
        ZZKnowledgeDetailController *vc = [[ZZKnowledgeDetailController alloc] init];
        vc.model = (ZZKnowledgeTopicModel *)model;
        [self openNav:vc sound:nil];
    }
    if(type == 3){
        ZZChapterDetailController *vc = [[ZZChapterDetailController alloc] init];
        vc.model = model;
        [self openNav:vc sound:nil];
    }
}


-(void)openNav:(UIViewController *)controller sound:(NSString *)soundName{
    if(_openBlock){
        _openBlock(controller);
    }
}

-(void)chapterOnClick:(ZZChapterModel *) itemModel playArr:(NSMutableArray *) arr from:(int) from{
    // 播放、暂停
    if(itemModel.lclassify == 1 || itemModel.lclassify == 0){
        ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
        NewsDetailC.model = itemModel;
        [self.navigationController pushViewController:NewsDetailC animated:YES];
    }
    
    if(itemModel.lclassify == 2){
        ZZVoiceTools *tools = [ZZVoiceTools shareVoiceTools];
        tools.model = itemModel;
        tools.viewController = self;
        
        if(playModel!=nil && playModel.isPlaying){
            playModel.isPlaying = NO;
            playModel = nil;
            
            [tools stopPlayer];
            [_listTable reloadData];
        }
        playModel = itemModel;
        playModel.isPlaying = YES;
        
        
        if(arr && arr.count>0){
            for (int i = 0; i<arr.count; i++) {
                ZZChapterModel *tm = [arr objectAtIndex:i];
                if(itemModel.nid == tm.nid){
                    
                    tools.curIndex = i;
                }
            }
            tools.list = arr;
        }else{
            tools.curIndex = 0;
        }
        [tools show:1];
        [tools setOnDissmisBlock:^{
            if(playModel!=nil && playModel.isPlaying){
                playModel.isPlaying = NO;
                playModel = nil;
                [_listTable reloadData];
            }
        }];
        
        [_listTable reloadData];
    }
    
    if(itemModel.lclassify == 3){
        ZZVideoController *vc = [[ZZVideoController alloc] init];
        vc.model = itemModel;
        [self openNav:vc sound:nil];
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
