//
//  ZZKnowledgeDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeDetailController.h"
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZZKnowledgeItemTextCell.h"
#define cellIndentifer @"ZZKnowledgeItemTextCell"
#import "MyButton.h"
#import "ZZApplyFriendController.h"

#import "ExpertApp-Swift.h"
#import "ZZAcountController.h"

@interface ZZKnowledgeDetailController ()<UITableViewDelegate,UITableViewDataSource,ZZKnowledgeItemsCellDelegate>{
    NSMutableArray     *_listArray;
    
    UITableView        *_listTable;
    
    ZZChapterModel     *playModel;
    
    UIButton *otherBtn;
    BOOL isCanRead;
}
@property(nonatomic,strong)UIButton *colloctBtn;

@end

@implementation ZZKnowledgeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:convertToString(_model.className) forState:UIControlStateNormal];
    
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setTitle:@"" forState:UIControlStateNormal];
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    
    
    _listArray = [[NSMutableArray alloc] init];
    [self createTableView];
    [self beginNetRefreshData];
    
    isCanRead = NO;
    
    
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [self goBack:nil];
    }
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeKnowledgeDetail vc:self];
        shareView.shareModel = _model;
        [shareView show];
    }
    else if(sender.tag == 111){
        ZZApplyFriendController *vc = [[ZZApplyFriendController alloc] init];
        vc.toUserId = _model.docId;
        [vc setZZApplyFriendResultBlock:^(int status){
            if(status == 1){
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [sender setEnabled:NO];
            }
        }];
        [self openWithPresent:vc animated:YES];
    }else if(sender.tag == 222){
        [self lookViewClick:nil];
    }
}

-(void)lookViewClick:(ZZChapterModel *) itemModel{
    if(isCanRead){
        if(itemModel){
            [self chapterOnClick:itemModel];
        }else{
            if(_listArray.count > 0){
                ZZChapterModel *item = [_listArray objectAtIndex:0];
                [self chapterOnClick:item];
            }
        }
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"2" forKey:@"type"];
    [dict setObject:convertIntToString([ZZDataCache getInstance].getLoginUser.userId) forKey:@"userId"];
    [dict setObject:convertIntToString(_model.sid) forKey:@"souId"];
    
    [ZZRequsetInterface post:API_getSourceByUserId param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(dict && dict[@"retData"]){
            // 已支付
            if([dict[@"retData"][@"can"] intValue] == 1){
                
                isCanRead = YES;
                if(itemModel){
                    [self chapterOnClick:itemModel];
                }else{
                    if(_listArray.count > 0){
                        ZZChapterModel *item = [_listArray objectAtIndex:0];
                        [self chapterOnClick:item];
                    }
                }
            }else{
                ZZAcountController *vc = [[ZZAcountController alloc] init];
                vc.type = ZZAcountDoctorVideo;
                vc.objModel = _model;
                vc.otherId = convertIntToString(_model.sid);
                vc.item = dict[@"retData"];
                [self openNav:vc sound:nil];
            }
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)beginNetRefreshData{
    
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_model.sid) forKey:@"classId"];
    
    [ZZRequsetInterface post:API_getKnowledgeTopicDetail param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.footer && [_listTable.footer respondsToSelector:@selector(endRefreshing)]){
            [_listTable.footer endRefreshing];
        }
        if(_listTable.header && [_listTable.header respondsToSelector:@selector(endRefreshing)]){
            [_listTable.header endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        
        NSDictionary *data= dict[@"retData"][0];
        if(data){
            _model = [[ZZKnowledgeTopicModel alloc] initWithMyDict:data];
            [self.menuTitleButton setTitle:convertToString(_model.className) forState:UIControlStateNormal];
            [_listArray removeAllObjects];
            
            
            [_listArray addObjectsFromArray:_model.wenzhang];
            
            
            [otherBtn setTitle:[NSString stringWithFormat:@"立即观看(%.0f积分)",_model.score] forState:UIControlStateNormal];
            [_listTable reloadData];
            
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [_listTable reloadData];
    } progress:^(CGFloat progress) {
        
    }];
}




#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UILabel *lab = [self createLabel:_model.introduce];
        return 270 +  lab.frame.size.height;
    }
    
    if(section == 1){
        UILabel *lab = [self createLabel:_model.synopsis];
        return 70 + lab.frame.size.height;;
    }
    if(section == 2){
        UILabel *lab = [self createLabel:_model.adaptUser];
        return 60 + lab.frame.size.height;;
    }
    
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    if(section == 0){
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        [img sd_setImageWithURL:[NSURL URLWithString:convertToString(_model.classUrl)]];
        [img setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 230, ScreenWidth-30, 25)];
        
        [btn setTitle:[NSString stringWithFormat:@"%@",_model.className] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:0];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10, 0, 10, 25)];
        [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
        [arrow setContentMode:UIViewContentModeCenter];
        [btn addSubview:arrow];
        
        UILabel *lab = [self createLabel:_model.introduce];
        CGRect f = lab.frame;
        f.origin.y = 250 + 15;
        lab.frame = f;
        
        
        [headerView addSubview:img];
        [headerView addSubview:btn];
        [headerView addSubview:lab];
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 270 + f.size.height)];
        return headerView;
    }else if(section == 1){
        
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        [headerView addSubview:lineView];
        
        [self createMenuButton:headerView tag:1];
        
        
        UILabel *lab = [self createLabel:_model.synopsis];
        
        CGRect f = lab.frame;
        f.origin.y =60;
        lab.frame = f;
        
        [headerView addSubview:lab];
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 60 + f.size.height + 10)];
        return headerView;
    }else if(section == 2){
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UIButton *btn = [self createMenuButton:headerView tag:2];
        [btn setFrame:CGRectMake(10, 10, ScreenWidth-40, 30)];
        
        UILabel *lab = [self createLabel:_model.adaptUser];
        
        CGRect f = lab.frame;
        f.origin.y =50;
        lab.frame = f;
        
        [headerView addSubview:lineView];
        [headerView addSubview:lab];
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 60 + f.size.height + 10)];
        
        return headerView;
    }else{
        
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        [headerView addSubview:lineView];
        
        [self createMenuButton:headerView tag:3];
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        return headerView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section < 3){
        return 0;
    }
    
    
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==3){
        
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
    [self lookViewClick:item];
    
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

-(void)chapterOnClick:(ZZChapterModel *) itemModel{
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
        
        tools.curIndex  = (int)[_listArray indexOfObject:itemModel];
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
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight -NavBarHeight-48-(ZC_iPhoneX?34:0)) style:UITableViewStylePlain];
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
    
    
    _colloctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_colloctBtn setImage:[UIImage imageNamed:@"doctor_follow"] forState:UIControlStateNormal];
    [_colloctBtn setTitle:@"关注医生" forState:UIControlStateNormal];
    [_colloctBtn setFrame:CGRectMake(0, ScreenHeight-40-(ZC_iPhoneX?34:0), 105, 40)];
    [_colloctBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [_colloctBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [_colloctBtn.titleLabel setFont:ListDetailFont];
    _colloctBtn.tag = 111;
    [_colloctBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_colloctBtn];
    
    
    otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn setTitle:@"立即观看" forState:UIControlStateNormal];
    [otherBtn setImage:[UIImage imageNamed:@"zzicon_jf_look_video"] forState:UIControlStateNormal];
    [otherBtn setFrame:CGRectMake(105, ScreenHeight-40-(ZC_iPhoneX?34:0), ScreenWidth-105, 40)];
    [otherBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [otherBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [otherBtn.titleLabel setFont:ListDetailFont];
    [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.tag = 222;
    [self.view addSubview:otherBtn];
}

-(void)btnShowDropMenu:(UIButton *) btn{
    
}


-(UIButton *)createMenuButton:(UIView *) pview tag:(int) tag{
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [btn addTarget:self action:@selector(btnShowDropMenu:) forControlEvents:UIControlEventTouchUpInside];
    if(tag == 1){
        btn.tag = 1;
        [btn setTitle:@"课程说明" forState:UIControlStateNormal];
    }else if(tag == 2){
        btn.tag = 2;
        [btn setTitle:@"适宜人群" forState:UIControlStateNormal];
    }else{
        btn.tag = 3;
        [btn setTitle:@"课程内容" forState:UIControlStateNormal];
    }
    
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
    lab.font = ListTitleFont;
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
