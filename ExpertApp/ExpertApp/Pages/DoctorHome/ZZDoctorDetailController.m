//
//  ZZDoctorDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorDetailController.h"


#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZChapterUserCell.h"
#define cellIdentifier @"ZZChapterUserCell"

#import "ZZDoctorHeaderCell.h"
#define cellIdentifierHeader @"ZZDoctorHeaderCell"

#import "ZZCommentController.h"
#import "ZZChooseController.h"
#import "ZZDoctorChapterController.h"

#import "ZZShareView.h"

@interface ZZDoctorDetailController ()
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZDoctorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
    [self createTitleMenu];
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [self.menuTitleButton setTitle:[NSString stringWithFormat:@"个人诊所"] forState:UIControlStateNormal];
    
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeUser vc:self];
        shareView.shareModel = _model;
        [shareView show];
    }else if(sender.tag == 111){
        // 关注
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_model.userId) forKey:@"toUserId"];
        [ZZRequsetInterface post:API_followUserDoctor param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }else if(sender.tag == 222){
        // 咨询
        ZZChooseController *chooseVC = [[ZZChooseController alloc] init];
        chooseVC.doctorId = convertIntToString(_model.userId);
        [self openNav:chooseVC sound:nil];
        
    }else if(sender.tag == 333){
        // 所有文章
        ZZDoctorChapterController *chatpterVC = [[ZZDoctorChapterController alloc] init];
        [self openNav:chatpterVC sound:nil];
    }
    
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-48)];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierHeader bundle:nil] forCellReuseIdentifier:cellIdentifierHeader];
    _listTable.bounces = NO;
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    UIButton *colloctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [colloctBtn setImage:[UIImage imageNamed:@"doctor_follow"] forState:UIControlStateNormal];
    [colloctBtn setTitle:@"关注" forState:UIControlStateNormal];
    [colloctBtn setFrame:CGRectMake(0, ScreenHeight-40, 105, 40)];
    [colloctBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [colloctBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [colloctBtn.titleLabel setFont:ListDetailFont];
    colloctBtn.tag = 111;
    [colloctBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colloctBtn];
    
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn setTitle:@"立即咨询" forState:UIControlStateNormal];
    [otherBtn setFrame:CGRectMake(105, ScreenHeight-40, ScreenWidth-105, 40)];
    [otherBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [otherBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [otherBtn.titleLabel setFont:ListDetailFont];
    [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.tag = 222;
    [self.view addSubview:otherBtn];
    
    
    if(_listArray.count == 0){
        [self createPlaceholderView:nil message:@"暂时未添加任何文章" image:[UIImage imageNamed:@"service_dissatisfied"] withView:_listTable action:nil];
        
        [self.placeholderView setCenter:CGPointMake(_listTable.center.x, _listTable.bounds.size.height-130)];
    }else{
        [self removePlaceholderView];
    }
}


/**
 加载更多
 */
-(void)loadDoctorInfo{
    
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count == 0?1:3;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else if(section == 1){
        return 50;
    }else{
        return 10;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherBtn setTitle:@"更多文章" forState:UIControlStateNormal];
        [otherBtn setFrame:CGRectMake(0,10, ScreenWidth, 40)];
        [otherBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        [otherBtn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        [otherBtn.titleLabel setFont:ListDetailFont];
        [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = 333;
        [view addSubview:otherBtn];
        
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 10, 20, 20)];
        [imgview setImage:[UIImage imageNamed:@"btn_more"]];
        [otherBtn addSubview:imgview];
        
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }
    if(section == 1){
        return 0;
    }
    
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZDoctorHeaderCell *cell = (ZZDoctorHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierHeader];
        if (cell == nil) {
            cell = [[ZZDoctorHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierHeader];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell dataToView:_model];
//        [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
        return cell;
    }
    
    ZZChapterModel *newsModel = _listArray[indexPath.section];
    ZZChapterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.chapterModel = newsModel;
    
    [cell setOnItemClickBlock:^(ZZChapterCellClickTag tag){
        if(tag == ZZChapterCellClickTagSend){
            // 转发
        }
        if(tag == ZZChapterCellClickTagCollect){
            // 收藏
        }
        if(tag == ZZChapterCellClickTagComment){
            // 评论
            ZZCommentController *vc = [[ZZCommentController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    if(indexPath.row==_listArray.count-1){
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
    
    
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    if(_listArray.count < indexPath.row){
        return cell;
    }
    
   
    
    
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
//    return 70.0f;
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < _listArray.count){
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
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
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
