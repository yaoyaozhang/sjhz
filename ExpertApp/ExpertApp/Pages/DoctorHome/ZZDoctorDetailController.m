//
//  ZZDoctorDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorDetailController.h"

#import "UIView+Border.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZChapterUserCell.h"
#define cellIdentifier @"ZZChapterUserCell"

#import "ZZDoctorHeaderCell.h"
#define cellIdentifierHeader @"ZZDoctorHeaderCell"

#import "ZZQSListCell.h"
#define cellIdentifierQS @"ZZQSListCell"


#import "ZZCommentController.h"
#import "ZZChoosePatientController.h"
#import "ZZDoctorChapterController.h"
#import "ZZApplyFriendController.h"
#import "ZZChapterDetailController.h"

#import "ZZShareView.h"

#import "ZZQSModel.h"
#import "ASQController.h"

@interface ZZDoctorDetailController (){
    ZZUserInfo *loginUser;
    int isLook;
    
    BOOL showDesc;
    BOOL showWenjuan;
}
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)NSMutableArray   *questions;
@property(nonatomic,strong)UIView   *descView;
@property(nonatomic,strong)UIButton *colloctBtn;


@end

@implementation ZZDoctorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self createTitleMenu];
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    [self.menuTitleButton setTitle:[NSString stringWithFormat:@"个人诊所"] forState:UIControlStateNormal];
    
    showDesc = NO;
    showWenjuan = NO;
    // 加载医生信息
    [self loadDoctorInfo];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeUser vc:self];
        shareView.shareModel = _model.docInfo;
        [shareView show];
    }else if(sender.tag == 111){
        
        ZZApplyFriendController *vc = [[ZZApplyFriendController alloc] init];
        vc.toUserId = _model.docInfo.userId;
        [vc setZZApplyFriendResultBlock:^(int status){
            if(status == 1){
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [sender setEnabled:NO];
            }
        }];
        [self openWithPresent:vc animated:YES];
    }else if(sender.tag == 222){
        if(isLook == 0){
            [self.view makeToast:@"互相关注后才可以咨询！"];
            return;
        }
        if(isLook == 1){
            [self.view makeToast:@"医生未关注您，暂时无法咨询，请耐心等待！"];
            return;
        }
        
        // 咨询
        ZZChoosePatientController *chooseVC = [[ZZChoosePatientController alloc] init];
        chooseVC.doctorId = convertIntToString(_model.docInfo.userId);
        chooseVC.doctInfo = _model.docInfo;
        [self openNav:chooseVC sound:nil];
        
    }else if(sender.tag == 333){
        // 所有文章
        ZZDoctorChapterController *chatpterVC = [[ZZDoctorChapterController alloc] init];
        chatpterVC.docInfo = _model.docInfo;
        [self openNav:chatpterVC sound:nil];
    }
    else if(sender.tag == 444){
        showDesc = !showDesc;
        [_listTable reloadData];
    }else if(sender.tag == 555){
        showWenjuan = !showWenjuan;
        [_listTable reloadData];
    }
    
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _questions = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-48)];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierHeader bundle:nil] forCellReuseIdentifier:cellIdentifierHeader];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierQS bundle:nil] forCellReuseIdentifier:cellIdentifierQS];
    
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
    
    _colloctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_colloctBtn setImage:[UIImage imageNamed:@"doctor_follow"] forState:UIControlStateNormal];
    [_colloctBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_colloctBtn setFrame:CGRectMake(0, ScreenHeight-40, 105, 40)];
    [_colloctBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_colloctBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_colloctBtn.titleLabel setFont:ListDetailFont];
    _colloctBtn.tag = 111;
    [_colloctBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_colloctBtn];
    
    
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
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_docId) forKey:@"docId"];
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_FindDoctorInfoByUserId param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(dict && dict[@"retData"]){
            if(is_null(_model)){
                _model = [ZZUserHomeModel new];
            }
            _model.docInfo = [[ZZUserInfo alloc] initWithMyDict:dict[@"retData"]];
            isLook = [convertToString(dict[@"retData"][@"isLook"]) intValue];
            if(isLook > 0){
                [_colloctBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_colloctBtn setEnabled:NO];
            }
            [self createJianjie];
            
            [_listArray removeAllObjects];
            [_questions removeAllObjects];
            NSArray *arr = dict[@"retData"][@"news"];
            if(arr && arr.count>0){
                for (NSDictionary *item in arr) {
                    [_listArray addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
                }
                
                [self removePlaceholderView];
            }
            NSArray *qs = dict[@"retData"][@"wenjuan"];
            if(qs && qs.count){
                for (NSDictionary *item in qs) {
                    [_questions addObject:[[ZZQSListModel alloc] initWithMyDict:item]];
                }
            }
            [_listTable reloadData];
            [self removePlaceholderView];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}




#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4 + _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){// 头部信息
        return 0;
    }else if(section == 1){// 简介
        if(showDesc){
         
            return 50 + _descView.frame.size.height;
        }
        return 50;
    }else if(section == 2){// 问卷
        return 50;
    }else if(section == 3){// 文章
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
        [otherBtn setTitle:@"专家简介" forState:UIControlStateNormal];
        [otherBtn setFrame:CGRectMake(0,10, ScreenWidth, 40)];
        [otherBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        [otherBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        [otherBtn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        [otherBtn.titleLabel setFont:ListDetailFont];
        [otherBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = 444;
        [view addSubview:otherBtn];
        
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 10, 20, 20)];
        [imgview setContentMode:UIViewContentModeScaleAspectFit];
        [otherBtn addSubview:imgview];
        if(showDesc){
            [imgview setImage:[UIImage imageNamed:@"icon_down"]];
            [view addSubview:_descView];
            [view setFrame:CGRectMake(0, 0, ScreenWidth, 50 + _descView.frame.size.height)];
        }else{
            [imgview setImage:[UIImage imageNamed:@"icon_arrow"]];
            [view setFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        }
        return view;
    }
    if(section==2){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [otherBtn setTitle:@"医生问卷" forState:UIControlStateNormal];
        [otherBtn setFrame:CGRectMake(0,10, ScreenWidth, 40)];
        [otherBtn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        [otherBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
        [otherBtn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        [otherBtn.titleLabel setFont:ListDetailFont];
        [otherBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = 555;
        [otherBtn addBottomBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:0.75f];
        [view addSubview:otherBtn];
        
        
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 10, 20, 20)];
        [imgview setImage:[UIImage imageNamed:@"btn_more"]];
        [imgview setContentMode:UIViewContentModeScaleAspectFit];
        [otherBtn addSubview:imgview];
        if(showWenjuan){
            [imgview setImage:[UIImage imageNamed:@"icon_down"]];
        }else{
            [imgview setImage:[UIImage imageNamed:@"icon_arrow"]];
        }
        
        return view;
    }
    if(section==3){
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
    if(section == 2){
        if(showWenjuan){
            return _questions.count;
        }
        return 0;
    }
    if(section == 3){
        return 0;
    }
   
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ZZDoctorHeaderCell *cell = (ZZDoctorHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierHeader];
        if (cell == nil) {
            cell = [[ZZDoctorHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierHeader];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell dataToView:_model.docInfo];
//        [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
        return cell;
    }
    
    if(indexPath.section == 2){
        ZZQSListCell *cell = (ZZQSListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierQS];
        if (cell == nil) {
            cell = [[ZZQSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierQS];
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ZZQSListModel *m = [_questions objectAtIndex:indexPath.row];
        [cell.labTitle setText:m.quesName];
        [cell.labTitle setTextColor:UIColorFromRGB(TextSizeNineColor)];
        [cell.labTitle setFont:ListDetailFont];
        //        [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
        return cell;
    }
    
    
    ZZChapterModel *newsModel = _listArray[indexPath.section-4];
    ZZChapterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.chapterModel = newsModel;
    
    [cell setOnItemClickBlock:^(ZZChapterCellClickTag tag){
        if(tag == ZZChapterCellClickTagSend){
            // 分享
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
                
                [self.listTable reloadData];
                
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
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
   
    
    
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
    if(indexPath.section == 0){        
        return 245.0f;
    }
    if(indexPath.section == 2){
        return 44.0f;
    }
    return 120.0f;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){
        ZZQSListModel *m = [_questions objectAtIndex:indexPath.row];
        ASQController *detail = [[ASQController alloc] init];
        detail.model = m;
        detail.docId = _docId;
        detail.type = ASQTYPEWJ;
        [self openNav:detail sound:@""];
    }
    
    if(indexPath.section >= 4){
        ZZChapterModel *newsModel = [_listArray objectAtIndex:indexPath.section-4];
        
        ZZChapterDetailController *NewsDetailC = [[ZZChapterDetailController alloc] init];
        NewsDetailC.model = newsModel;
        [self.navigationController pushViewController:NewsDetailC animated:YES];
    }
    
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < _listArray.count){
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
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


-(void) createJianjie{
    _descView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth,0)];
    [_descView addTopBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:0.75f];
    [_descView setBackgroundColor:UIColor.whiteColor];
    CGFloat y = 10;
    y = y + [self createTextLabel:@"医学教育背景" type:1 y:y] + 10;
    y = y + [self createTextLabel:_model.docInfo.medicalBackground type:2 y:y] + 10;
    [self createLineView:y pv:_descView];
    y = y + 10;
    
    y = y + [self createTextLabel:@"学术研究成果" type:1 y:y] + 10;
    y = y + [self createTextLabel:_model.docInfo.academicResearch type:2 y:y] + 10;
    [self createLineView:y pv:_descView];
    y = y + 10;
    y = y + [self createTextLabel:@"医生寄语" type:1 y:y] + 10;
    y = y + [self createTextLabel:_model.docInfo.doctorWrote type:2 y:y] + 10;
    [self createLineView:y pv:_descView];
    y = y + 1;
    [_descView setFrame:CGRectMake(0, 50, ScreenWidth, y)];
}

-(CGFloat ) createTextLabel:(NSString *) text type:(int) type y:(CGFloat ) y{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, y, ScreenWidth-32, 0)];
    [lab setText:text];
    lab.numberOfLines = 0;
    [lab setTextColor:UIColorFromRGB(TextDarkColor)];
    if(type == 2){
        [lab setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    }
    [lab setFont:ListDetailFont];
    CGSize s = [ZZCoreTools autoHeightOfLabel:lab with:ScreenWidth - 30];
    [_descView addSubview:lab];
    return s.height;
}

-(void)createLineView:(CGFloat )y pv:(UIView *) v{
    UIImageView *linev = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, .75f)];
    [linev setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [v addSubview:linev];
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
