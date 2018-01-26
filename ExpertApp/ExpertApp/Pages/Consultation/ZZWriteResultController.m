//
//  ZZWriteResultController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZWriteResultController.h"
#import "UIView+Extension.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "ZZDoctorCell.h"
#define cellIdentifier @"ZZDoctorCell"
#import "ZCTextPlaceholderView.h"

#import "ZZInviteDoctorController.h"
#import "ZZSearchResultController.h"
#import "ZZTipsAlertView.h"

@interface ZZWriteResultController ()<UITextViewDelegate,ZZDoctorCellDelegate>{
    ZZUserInfo *loginUser;
}

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong) ZCTextPlaceholderView *resultView;
@property(nonatomic,strong) ZCTextPlaceholderView *tjView;
@property(nonatomic,strong) UIView *headerView;

@end

@implementation ZZWriteResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:@"填写会诊结果" forState:UIControlStateNormal];
    
    [self createTableView];
    
}

-(void)tapHideKeyboard{
    [_resultView resignFirstResponder];
    [_tjView resignFirstResponder];
}


-(void)addOrCommitClick:(UIButton *) sender{
    if(sender.tag == 3){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_model.diseaseId) forKey:@"diseaseId"];
        [dict setObject:convertIntToString(_model.symId) forKey:@"symId"];
        [ZZRequsetInterface post:API_getUserPom param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            NSString *result = convertToString(dict[@"retData"][@"result"]);
            if(result.length > 0){
//                NSString *bssym = dict[@"retData"][@"bssym"];
                NSString *cText = [NSString stringWithFormat:@"你的症状可以考虑为<a href=\"sjhz://1234\">%@</a>疾病,如果想获取更多医学资料请点击“是”，如果不需要点击“否”。",result];
                ZZTipsAlertView *tipView = [[ZZTipsAlertView alloc] initWithTitle:@"提示" message:cText cancel:@"否" comfirm:@"是"];
                [tipView setBlock:^(NSInteger buttonTag, NSString *text) {
                    if(convertToString(text).length > 0){
                        ZZSearchResultController *vc = [[ZZSearchResultController alloc] init];
                        vc.searchText = result;
                        [self openNav:vc sound:nil];
                    }
                    else{
                        ZZSearchResultController *vc = [[ZZSearchResultController alloc] init];
                        [self openNav:vc sound:nil];
                    }
                }];
                [tipView show];
            }else{
                ZZSearchResultController *vc = [[ZZSearchResultController alloc] init];
                vc.searchText = result;
                [self openNav:vc sound:nil];
            }
           
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    if(sender.tag == 1){
        // 推荐朋友
        ZZInviteDoctorController *vc = [[ZZInviteDoctorController alloc] init];
        vc.isRecommend = YES;
        [vc setResultBlock:^(NSMutableDictionary *dict){
            if(dict){
                for (NSString *key in dict.allKeys) {
                    [_listArray addObject:dict[key]];
                }
                [_listTable reloadData];
            }
        }];
        [self openNav:vc sound:nil];
    }
    if(sender.tag == 2){
        // 发布会诊结果
        if(is_null(_resultView.text)){
            [self.view makeToast:@"会诊结果不能为空！"];
            return;
        }
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_model.caseId) forKey:@"id"];
        [dict setObject:convertToString(_resultView.text) forKey:@"result"];
        [dict setObject:convertToString(_tjView.text) forKey:@"tjOutDoc"];
        
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];

        NSString *tjInUser = @"";
        if(_listArray && _listArray.count>0){
            for (ZZUserInfo *item in _listArray) {
                tjInUser = [tjInUser stringByAppendingFormat:@",%d",item.userId];
            }
            if(tjInUser.length>0){
                tjInUser = [tjInUser substringFromIndex:1];
            }
        }
        [dict setObject:tjInUser forKey:@"tjInDoc"];
        [ZZRequsetInterface post:API_WriteCaseResult param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if((_model.state == 0 || _model.state==1 || _model.state==2) && _model.firstDoc){
                _model.state = 3;
            }
            _model.caseResult = _resultView.text;
            _model.writeDoc = loginUser.userId;
            _model.docName = loginUser.userName;
            if(_ResultBlock){
                _ResultBlock(_model);
            }
            [self.view makeToast:@"非常感谢，问诊已经完成!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self goBack:nil];
            });
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-40)];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;

    _listTable.tableHeaderView = [self createTableHeaderView];
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [_listTable addGestureRecognizer:gestureRecognizer];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [addBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [addBtn setTitle:@"提交" forState:UIControlStateNormal];
    addBtn.tag = 2;
    [addBtn addTarget:self action:@selector(addOrCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}


#pragma mark UITableView delegate Start
-(UIView *)createTableHeaderView{
    if(_headerView){
        return _headerView;
    }
    _headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 375)];
    _headerView.autoresizesSubviews = YES;
    [_headerView setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    
    
    UIView *whiteBg = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 230)];
    [whiteBg setBackgroundColor:[UIColor whiteColor]];
    [_headerView addSubview:whiteBg];
    
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth-90, 21)];
    [label1 setFont:ListDetailFont];
    [label1 setText:@"填写会诊结果"];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setTextColor:UIColorFromRGB(TextBlackColor)];
    [whiteBg addSubview:label1];
    
    UIButton *addBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn1 setFrame:CGRectMake(ScreenWidth-95, 12.5, 80, 25)];
    [addBtn1 setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [addBtn1 setTitle:@"医生助手" forState:0];
    [addBtn1 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [addBtn1.titleLabel setFont:ListDetailFont];
    [addBtn1 setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [addBtn1 setTitleColor:UIColorFromRGB(TextWhiteColor) forState:0];
    addBtn1.layer.cornerRadius = 4.0f;
    addBtn1.layer.masksToBounds = YES;
    addBtn1.tag = 3;
    [addBtn1 addTarget:self action:@selector(addOrCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBg addSubview:addBtn1];
    
    _resultView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, 45, ScreenWidth-30, 170)];
    [_resultView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [_resultView setPlaceholder:@"填写会诊结果"];
    [_resultView setTextColor:UIColorFromRGB(TextDarkColor)];
    _resultView.delegate = self;
    [whiteBg addSubview:_resultView];
    
    
    UIView *whiteBg1 = [[UIView alloc] initWithFrame:CGRectMake(0, 255, ScreenWidth, 120)];
    [whiteBg1 setBackgroundColor:[UIColor whiteColor]];
    [_headerView addSubview:whiteBg1];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth-90, 21)];
    [label setFont:ListDetailFont];
    [label setText:@"推荐您的朋友"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:UIColorFromRGB(TextBlackColor)];
    [whiteBg1 addSubview:label];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(ScreenWidth-40, 15, 25, 25)];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addBtn.tag = 1;
    [addBtn addTarget:self action:@selector(addOrCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteBg1 addSubview:addBtn];
    
    _tjView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, 45, ScreenWidth-30, 60)];
    [_tjView setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    [_tjView setPlaceholder:@"填写或选择您已经添加的医生朋友"];
    _tjView.layer.cornerRadius = 4.0f;
    _tjView.layer.masksToBounds = YES;
    [whiteBg1 addSubview:_tjView];
    
    return _headerView;

}
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listArray==nil){
        return 0;
    }
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDoctorCell *cell = (ZZDoctorCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZDoctorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
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
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    if(_listArray.count < indexPath.row){
        return cell;
    }
    
    ZZUserInfo *model=[_listArray objectAtIndex:indexPath.row];
    cell.cellType = ZZDoctorCellTypeDel;
    cell.delegate = self;
    [cell dataToView:model];
    
    
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self tapHideKeyboard];
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

-(void)onDoctorCellClick:(ZZDoctorCellType)type model:(ZZUserInfo *)model{
    if(type == ZZDoctorCellTypeDel){
        [_listArray removeObject:model];
        [_listTable reloadData];
    }
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
