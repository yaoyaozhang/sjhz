//
//  ZZKnowledgeUserController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/5/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeUserController.h"
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZZKnowledgeItemTextCell.h"
#define cellIndentifer @"ZZKnowledgeItemTextCell"
#import "MyButton.h"

#import "ZZChapterDetailController.h"
#import "ExpertApp-Swift.h"

#import "ZZDoctorDetailController.h"

@interface ZZKnowledgeUserController ()<UITableViewDelegate,UITableViewDataSource,ZZKnowledgeItemsCellDelegate>{
    NSMutableArray     *_listArray;
    
    UITableView        *_listTable;
    
    ZZChapterModel     *playModel;
    int pageNum;
}

@end

@implementation ZZKnowledgeUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:convertToString(_model.user.signName) forState:UIControlStateNormal];
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_more_normal"] forState:0];
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_more_pressed"] forState:UIControlStateHighlighted];
    [self.menuRightButton setTitle:@"" forState:0];
    self.menuRightButton.hidden = NO;
    
    _listArray = [[NSMutableArray alloc] init];
    [self createTableView];
    [self beginNetRefreshData];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        ZZDoctorDetailController *vc = [[ZZDoctorDetailController alloc] init];
        vc.docId = _model.user.userId;
        [self openNav:vc sound:nil];
    }
}


- (void)beginNetRefreshData{
    pageNum = 1;
    [self endNetRefreshData];
}

-(void)endNetRefreshData{

    // 获取tid来拼接urlString
    NSString *api = API_getChapterList;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(_model>0){
        [dict setObject:convertIntToString(_model.user.userId) forKey:@"docId"];
        [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"userId"];
        
        api = API_findDoctorChapterList;
    }
    
    [dict setObject:@"30" forKey:@"pageSize"];
    [dict setObject:convertIntToString(pageNum) forKey:@"pageNum"];
    [ZZRequsetInterface post:api param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if([_listTable.header isRefreshing]){
            [_listTable.header endRefreshing];
        }
        if([_listTable.footer isRefreshing]){
            [_listTable.footer endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        if(pageNum == 1){
            [_listArray removeAllObjects];
        }
        
        
        
        
        if(_model!=nil && _model.user!=nil){
            for (NSDictionary *item in dict[@"retData"]) {
                [_listArray addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
        }
        
        if(_listArray.count > 30){
            pageNum = pageNum + 1;
        }else{
            [_listTable.footer removeFromSuperview];
        }
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}



#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 260;
    }
    
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    if(section == 0){
        UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        UIImage *backImage =[UIImage imageNamed:@"voice_bg"];
        imgBg.layer.contents=(id)backImage.CGImage;
        imgBg.layer.backgroundColor = [UIColor clearColor].CGColor;

        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        [img sd_setImageWithURL:[NSURL URLWithString:convertToString(_model.user.signUrl)]];
        [img setContentMode:UIViewContentModeScaleAspectFill];
        img.clipsToBounds = YES;




        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 260, ScreenWidth, 1.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgSystemColor)];

        UIButton *btn = [self createMenuButton:headerView tag:1];
        [btn setFrame:CGRectMake(10, 220, ScreenWidth-40, 30)];

        [headerView addSubview:imgBg];
        [headerView addSubview:img];
        [headerView addSubview:btn];

        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 260)];
        return headerView;
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    
    
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==1){
        
        ZZKnowledgeItemTextCell *cell = (ZZKnowledgeItemTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        }
        cell.delegate = self;
        [cell dataToView:_listArray[indexPath.row]];
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZZChapterModel *item = [_listArray objectAtIndex:indexPath.row];
    [self chapterOnClick:item index:indexPath.row from:1];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
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


-(void)onItemClick:(id)model type:(int)type obj:(NSMutableArray *)arr{
    if(type == 3){
        ZZChapterDetailController *vc = [[ZZChapterDetailController alloc] init];
        vc.model = model;
        [self openNav:vc sound:nil];
    }
}




-(void)chapterOnClick:(ZZChapterModel *) itemModel index:(NSInteger) index from:(int) from{
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
        
        tools.list = _listArray;
        
        
        tools.curIndex = (int)index;
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



#pragma mark -- searchBar
- (void)createTableView{
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
    [self setTableSeparatorInset];
    
    MJRefreshStateHeader *header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginNetRefreshData)];
    //    header.stateLabel.hidden=YES;
    _listTable.header=header;
    
    //    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    //    footer.stateLabel.hidden=YES;
    //    _listTable.footer=footer;
}

-(void)btnShowDropMenu:(UIButton *) btn{
    
}


-(UIButton *)createMenuButton:(UIView *) pview tag:(int) tag{
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [btn addTarget:self action:@selector(btnShowDropMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = 1;
    [btn setTitle:@"课程内容" forState:UIControlStateNormal];
    
    [btn setFrame:CGRectMake(10, 20, ScreenWidth-40, 30)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    //
    UIImageView * lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 2, 14)];
    lineImg.backgroundColor = UIColorFromRGB(BgTitleColor);
    [btn addSubview:lineImg];
    
    
    [pview addSubview:btn];
    
    return btn;
}


-(UILabel *)createLabel:(NSString *) text{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 0)];
    lab.numberOfLines = 0;
    lab.font = ListDetailFont;
    lab.textColor = UIColorFromRGB(TextLightDarkColor);
    [lab setText:text];
    
    [self autoWidthOfLabel:lab with:ScreenWidth - 30];
    
    return lab;
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width,FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
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
