//
//  ZZKnowledgeCollegeListController.m
//  ExpertApp
//
//  Created by 张新耀 on 2019/5/22.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import "ZZKnowledgeCollegeListController.h"


#import "MyButton.h"
#import <MJRefresh.h>
#import "ZZKnowledgeSearchController.h"
#import "ZZDoctorChapterController.h"
#import "AppDelegate.h"

#define cellIndentiferRich @"ZZKnowledgeRichCell"
#define cellIndentifer @"ZZKnowledgeItemsCell"

#import "ZZKnowledgeRichCell.h"
#import "ZZKnowledgeItemsCell.h"

#import "SDCycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "MusicPlayTools.h"
#import "ZZChapterDetailController.h"
#import "ZZVoiceTools.h"
#import "ExpertApp-Swift.h"

#import "ZZKnowledgeUserController.h"
#import "ZZKnowledgeDetailController.h"
#import "ZZVoiceTools.h"

@interface ZZKnowledgeCollegeListController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,SDCycleScrollViewDelegate,ZZKnowledgeItemsCellDelegate>{
    
    
    NSMutableArray     *_tjArray;
    NSMutableArray     *_listArray;
    NSMutableArray     *_picArray;
    
    UITableView        *_listTable;
    SDCycleScrollView *_cycleScrollView;
    
    
    ZZChapterModel *playModel;
    
    
    // 当前选择的标签
    
    int          pageNumber;
    ZZUserInfo *loginUser;
    
    NSMutableArray *titles;
    NSArray *menuIcons;
    
    
}



@property (nonatomic,strong) UIButton    * seletBtn;


@end

@implementation ZZKnowledgeCollegeListController


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(BgSystemColor);
    
    
    [self layoutSearchBarView];
    
    _listArray = [[NSMutableArray alloc] init];
    _picArray  = [[NSMutableArray alloc] init];
    
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self beginNetRefreshData];
    
}


-(void)toggleData{
    if(_listArray.count == 0){
        [self beginNetRefreshData];
    }
}


#pragma mark -- 上拉加载
-(void)btnGoSearch{
    ZZKnowledgeSearchController *vc = [[ZZKnowledgeSearchController alloc] init];
    vc.searchType = 1;
    [self openNav:vc sound:nil];
}

-(void)btnShowDropMenu:(UIButton *) sender{
    if(sender.tag == 1){
        // 推荐
        ZZKnowledgeSearchController *vc = [[ZZKnowledgeSearchController alloc] init];
        vc.searchType = 3;
        [self openNav:vc sound:nil];
    }
    if(sender.tag == 2){
        // 精品课
        ZZKnowledgeSearchController *vc = [[ZZKnowledgeSearchController alloc] init];
        vc.searchType = 2;
        [self openNav:vc sound:nil];
        
    }
    
}

- (void)beginNetRefreshData{
    pageNumber = 1;
    if(![_listTable.header isRefreshing]){
        [SVProgressHUD show];
    }
    
    [self endNetRefreshData];
    
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        if(status == 0){
            [SVProgressHUD dismiss];
            
            if(dict[KEY_CONFIG_CHAPTERTYPE]){
                NSArray *arr = dict[KEY_CONFIG_CHAPTERTYPE];
                [titles addObjectsFromArray:arr];
                
                [_listTable reloadData];
            }
        }
        if(status == 1){
            [SVProgressHUD show];
        }
        if(status == 2){
            [SVProgressHUD showErrorWithStatus:@"加载配置信息错误"];
        }
    }];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"0" forKey:@"newsType"];
    [dict setObject:@"30" forKey:@"pageSize"];
    [dict setObject:convertIntToString(pageNumber) forKey:@"pageNum"];
    
    
    if(_dataType == 2){
        
    }
    
    [ZZRequsetInterface post:API_getKnowledgeHome param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        //        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.footer && [_listTable.footer respondsToSelector:@selector(endRefreshing)]){
            [_listTable.footer endRefreshing];
        }
        if(_listTable.header && [_listTable.header respondsToSelector:@selector(endRefreshing)]){
            [_listTable.header endRefreshing];
        }
        [SVProgressHUD dismiss];
    } complete:^(NSDictionary *dict) {
        if(pageNumber == 1){
            [_listArray removeAllObjects];
            [_picArray removeAllObjects];
            [_tjArray removeAllObjects];
            
        }
        NSDictionary *data= dict[@"retData"];
        
        for (NSDictionary *item in data[@"pic"]) {
            [_picArray addObject:item];
        }
        for (NSDictionary *item in data[@"jinpingke"]) {
            [_listArray addObject:[[ZZKnowledgeTopicModel alloc] initWithMyDict:item]];
        }
        for (NSDictionary *item in data[@"tuijian"]) {
            [_tjArray addObject:[[ZZTJListModel alloc] initWithMyDict:item]];
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
        return 170.0f;//245.0f;
    }
    
    return 1.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1||section == 2){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [headerView addSubview:lineView];
        
//        [self createMenuButton:headerView tag:(int)section];
        
        return headerView;
    }else if(section == 0){
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170.0f)];
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        if(_cycleScrollView==nil){
            [self setupCycleImageCell];
        }
        //        _cycleScrollView.titlesGroup = ({
        //            NSMutableArray *titleArrayM = [NSMutableArray array];
        //            for (int i = 0; i < _picArray.count; i++) {
        //                ZZChapterModel *model = [_picArray objectAtIndex:i];
        //                [titleArrayM addObject:model.title];
        //            }
        //
        //            titleArrayM;
        //        });
        
        _cycleScrollView.titleLabelBackgroundColor = UIColor.clearColor;
        _cycleScrollView.imageURLStringsGroup = ({
            NSMutableArray *urlArrayM = [NSMutableArray array];
            for (int i = 0; i < _picArray.count; i++) {
                NSDictionary *item = [_picArray objectAtIndex:i];
                [urlArrayM addObject:item[@"url"]];
            }
            
            urlArrayM;
        });
        [_cycleScrollView setFrame:CGRectMake(10, 10, ScreenWidth-20, 150)];
        [headerView addSubview:_cycleScrollView];
        
//        if(titles.count > 0){
//            [self createItemsMenuButton:headerView];
//        }
        
        return headerView;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    if(section == 1){
        return _tjArray.count;
    }
    
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        
        ZZKnowledgeItemsCell *cell = (ZZKnowledgeItemsCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        }
        cell.delegate = self;
        
        [cell dataToItem:[_tjArray objectAtIndex:indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
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
    
    if(indexPath.section == 2){
        ZZKnowledgeTopicModel *itemModel = [_listArray objectAtIndex:indexPath.row];
        
        
        ZZKnowledgeDetailController *vc = [[ZZKnowledgeDetailController alloc] init];
        vc.model = itemModel;
        [self.preVC.navigationController pushViewController:vc animated:nil];
//        [self openNav:vc sound:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}


-(void)onItemClick:(id)model type:(int)type obj:(NSMutableArray *)arr{
    if(type == 1){
        ZZChapterModel *itemModel = (ZZChapterModel *)model;
        [self chapterOnClick:itemModel playArr:arr from:1];
    }
    
    if(type == 2){
        ZZKnowledgeUserController *userVC = [[ZZKnowledgeUserController alloc] init];
        userVC.model = model;
//        [self openNav:userVC sound:nil];
        
        
        [self.preVC.navigationController pushViewController:userVC animated:nil];
    }
    
    if(type == 3){
        ZZChapterDetailController *vc = [[ZZChapterDetailController alloc] init];
        vc.model = model;
//        [self openNav:vc sound:nil];
        
        
        [self.preVC.navigationController pushViewController:vc animated:nil];
    }
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
    UILabel * labMore = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-80, 0, 64, 30)];
    [labMore setText:@"查看更多"];
    [labMore setFont:ListDetailFont];
    [labMore setTextAlignment:NSTextAlignmentRight];
    [labMore setTextColor:UIColorFromRGB(BgTitleColor)];
    [btn addSubview:labMore];
    
    [pview addSubview:btn];
}





#pragma mark -- searchBar
- (void)layoutSearchBarView{
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavBottomHeight) style:UITableViewStylePlain];
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
    
    
    
    MJRefreshStateHeader *header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginNetRefreshData)];
    //    header.stateLabel.hidden=YES;
    _listTable.header=header;
    
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
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
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10, 15, ScreenWidth-20, 150) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_big"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    [_cycleScrollView setBannerImageViewContentMode:UIViewContentModeScaleAspectFill];
    _cycleScrollView.layer.cornerRadius = 5.0f;
    _cycleScrollView.layer.masksToBounds = YES;
    
    _cycleScrollView.delegate = self;
}

/** SDCycleScrollView轮播点击事件代理 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *item = _picArray[index];
    NSLog(@"%@",item);
    [((AppDelegate*)[UIApplication sharedApplication].delegate) openNewPage:item[@"exUrl"]];
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
//        [self openNav:vc sound:nil];
        
        
        [self.preVC.navigationController pushViewController:vc animated:nil];
    }
}


-(void)onMenuClick:(UIButton *)btn{
    ZZDictModel *model =titles[btn.tag-1];
    ZZDoctorChapterController *vc = [[ZZDoctorChapterController alloc] init];
    vc.fromType = [model.code intValue];
    vc.pageTitle = model.name;
//    [self openNav:vc sound:nil];
    
    
    [self.preVC.navigationController pushViewController:vc animated:nil];
}


-(void)createItemsMenuButton:(UIView *) pview{
    CGFloat x = 30;
    CGFloat space = 29;
    CGFloat xw = (ScreenWidth - 60 - 116)/5;
    for (int i=0; i<titles.count; i++) {
        ZZDictModel *dictModel = titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(x + space *i + xw*i, 165, xw, 65)];
        if(menuIcons.count > i){
            [btn setImage:[UIImage imageNamed:menuIcons[i]] forState:UIControlStateNormal];
        }
        btn.tag = i+1;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 21, 0)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, xw, 21)];
        [label setText:dictModel.name];
        [label setFont:ListDetailFont];
        [label setTextAlignment:NSTextAlignmentCenter];
        [btn addSubview:label];
        [btn addTarget:self action:@selector(onMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [pview addSubview:btn];
    }
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
