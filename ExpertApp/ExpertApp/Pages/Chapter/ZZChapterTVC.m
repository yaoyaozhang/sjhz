//
//  ZZChapterTVC.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterTVC.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZChapterCell.h"
#import "SVWebViewController.h"
#import "ZZCommentController.h"
#import "ZZChapterDetailController.h"
#import "ZZShareView.h"
#import "ExpertApp-Swift.h"

#import "ZZKnowledgeItemTextCell.h"
#define cellIndentifer @"ZZKnowledgeItemTextCell"


@interface ZZChapterTVC ()<ZZKnowledgeItemsCellDelegate>{
    int pageNum;
    ZZChapterModel *playModel;
}

@property (nonatomic, strong) NSMutableArray *dataList;


@end

@implementation ZZChapterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 把小菊花漏出来
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    __weak typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self.tableView setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    // 注册
    [self.tableView registerNib:[UINib nibWithNibName:cellIndentifer bundle:nil] forCellReuseIdentifier:cellIndentifer];
    if(iOS7){
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackGround)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    _dataList = [NSMutableArray arrayWithCapacity:0];
}

- (void)setNewsType:(NSString *)newsType
{
    _newsType = newsType;
    pageNum = 1;
    [self.tableView.header beginRefreshing];
}


/** 下拉刷新 */
- (void)refreshData
{
    
    // 获取tid来拼接urlString
    pageNum = 1;
    [self loadMoreData];
}

/** 上拉加载 */
- (void)loadMoreData
{
    // 获取tid来拼接urlString
    NSString *api = API_getChapterList;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(_docId>0){
        [dict setObject:convertIntToString(_docId) forKey:@"docId"];
        [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"userId"];
        
        api = API_findDoctorChapterList;
    }else if(_userId > 0){
        [dict setObject:convertIntToString(_userId) forKey:@"userId"];
        
        api = API_findUserChapterList;
    }else{
        [dict setObject:convertToString(_newsType) forKey:@"newsType"];
    }
    
    [dict setObject:@"30" forKey:@"pageSize"];
    [dict setObject:convertIntToString(pageNum) forKey:@"pageNum"];
    [ZZRequsetInterface post:api param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([self.tableView.header isRefreshing]){
            [self.tableView.header endRefreshing];
        }
        if([self.tableView.footer isRefreshing]){
            [self.tableView.footer endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        if(pageNum == 1){
            [[self dataList] removeAllObjects];
        }
        
        
        
        
        if(_docId>0 || _userId>0){
            for (NSDictionary *item in dict[@"retData"]) {
                [_dataList addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
        }else{
//            if(dict[@"retData"][@"pic"]){
//                NSMutableArray *arr = [[NSMutableArray alloc] init];
//                for (NSDictionary *item in dict[@"retData"][@"pic"]) {
//                    [arr addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
//                }
//                ZZChapterModel *topModel = [ZZChapterModel new];
//                topModel.pics = arr;
//                [_dataList addObject:topModel];
//            }
            for (NSDictionary *item in dict[@"retData"][@"news"]) {
                [_dataList addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
        }
        
        if(_dataList.count > 30){
            pageNum = pageNum + 1;
        }else{
            [self.tableView.footer removeFromSuperview];
        }
        [self.tableView reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat ) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section>0){
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZChapterModel *newsModel = self.dataList[indexPath.section];
    ZZKnowledgeItemTextCell *cell = (ZZKnowledgeItemTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[ZZKnowledgeItemTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    cell.delegate = self;
    [cell dataToView:newsModel];
    
    return cell;
    
//    ZZChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZChapterCell cellReuseID:newsModel] forIndexPath:indexPath];
//    cell.chapterModel = newsModel;
//    [self setupCycleImageClickWithCell:cell newsModel:newsModel];
//    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZZChapterModel *newsModel = self.dataList[indexPath.section];
//
//    return [ZZChapterCell cellForHeight:newsModel];
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    	NSLog(@"%s  %zd", __func__,indexPath.row);
    //	UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    //	cell.textLabel.textColor = [UIColor lightGrayColor];
    // 记录是否已读
    // [[DDNewsCache sharedInstance] addObject:cell.titleLabel.text];
    
//    ZZKnowledgeItemTextCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.titleLabel.textColor = [UIColor lightGrayColor];
    
    if(indexPath.section== _dataList.count-1){
        [self setTableSeparatorInset];
    }
    
    
    ZZChapterModel *newsModel = self.dataList[indexPath.section];

    [self chapterOnClick:newsModel cur:indexPath.section];
    
//   ZZVoiceController *NewsDetailC = [[ZZVoiceController alloc] init];
//    ZZVideoController *NewsDetailC = [[ZZVideoController alloc] init];
    
//    ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
//    NewsDetailC.model = newsModel;
    
    
    
}

#pragma mark -
- (void)enterBackGround
{
//    [[DDNewsCache sharedInstance] removeAllObjects];
}


/** 轮播点击事件 */
- (void)setupCycleImageClickWithCell:(ZZChapterCell *)cell newsModel:(ZZChapterModel *)newsModel
{
    cell.cycleImageClickBlock = ^(NSInteger idx){
        NSLog(@"%zd",idx);
        ZZChapterModel *pmodel = newsModel.pics[idx];
        
        ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
        NewsDetailC.model = pmodel;
       
        if(self.preVC){
            [((UIViewController *)self.preVC).navigationController pushViewController:NewsDetailC animated:YES];
        }else{
            [self.navigationController pushViewController:NewsDetailC animated:YES];
        }
    };
    
    
    cell.onItemClickBlock = ^(ZZChapterCellClickTag tag) {
        if(tag == ZZChapterCellClickTagSend){
            // 转发
            ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeChapter vc:self];
            shareView.shareModel = newsModel;
            [shareView show];
        }
        if(tag == ZZChapterCellClickTagCollect){
            // 收藏
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if(newsModel.collect){
                [dict setObject:convertToString(@"0") forKey:@"collectiontType"];
            }else{
                [dict setObject:convertToString(@"1") forKey:@"collectiontType"];
            }
            [dict setObject:convertIntToString(newsModel.nid) forKey:@"nid"];
            [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"uid"];
            [ZZRequsetInterface post:API_CollectChapter param:dict timeOut:HttpGetTimeOut start:^{
                
            } finish:^(id response, NSData *data) {
                
            } complete:^(NSDictionary *dict) {
                if(newsModel.collect){
                    [self.view makeToast:@"取消收藏成功!"];
                }else{
                    [self.view makeToast:@"收藏成功!"];
                }
                
                newsModel.collect = !newsModel.collect;
                
                [self.tableView reloadData];
                
            } fail:^(id response, NSString *errorMsg, NSError *connectError) {
                [self.view makeToast:errorMsg];
            } progress:^(CGFloat progress) {
                
            }];
        }
        if(tag == ZZChapterCellClickTagComment){
            // 评论
            ZZCommentController *vc = [[ZZCommentController alloc] init];
            vc.nid = newsModel.nid;
            vc.model = newsModel;
           
            if(self.preVC){
                [((UIViewController *)self.preVC).navigationController pushViewController:vc animated:YES];
            }else{
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    };
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}



-(void)onItemClick:(id)model type:(int)type obj:(NSMutableArray *)arr{
    if(type == 3){
        ZZChapterDetailController *vc = [[ZZChapterDetailController alloc] init];
        vc.model = model;
        if(self.preVC){
            [((UIViewController *)self.preVC).navigationController pushViewController:vc animated:YES];
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



-(void)chapterOnClick:(ZZChapterModel *) itemModel cur:(NSUInteger )index{
    // 播放、暂停
    if(itemModel.lclassify == 1 || itemModel.lclassify == 0){
        ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
        NewsDetailC.model = itemModel;
        if(self.preVC){
            [((UIViewController *)self.preVC).navigationController pushViewController:NewsDetailC animated:YES];
        }else{
            [self.navigationController pushViewController:NewsDetailC animated:YES];
        }
    }
    
    if(itemModel.lclassify == 2){
        ZZVoiceTools *tools = [ZZVoiceTools shareVoiceTools];
        tools.model = itemModel;
        tools.viewController = self;
        tools.curIndex = (int)index;
        tools.list = _dataList;
        
        if(playModel!=nil && playModel.isPlaying){
            playModel.isPlaying = NO;
            playModel = nil;
            
            [tools stopPlayer];
            [self.tableView reloadData];
        }
        
        playModel = itemModel;
        playModel.isPlaying = YES;
        [tools show:1];
        [tools setOnDissmisBlock:^{
            if(playModel!=nil && playModel.isPlaying){
                playModel.isPlaying = NO;
                playModel = nil;
                [self.tableView reloadData];
            }
        }];
        
        [self.tableView reloadData];
    }
    
    if(itemModel.lclassify == 3){
        ZZVideoController *vc = [[ZZVideoController alloc] init];
        vc.model = itemModel;
        if(self.preVC){
            [((UIViewController *)self.preVC).navigationController pushViewController:vc animated:YES];
        }else{
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:inset];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:inset];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
