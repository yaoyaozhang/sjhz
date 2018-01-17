//
//  ZZDiscussController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDiscussController.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZCTextPlaceholderView.h"

#import "ZZDiscussCell.h"
#define cellIdentifier @"ZZDiscussCell"

#import "ZZWriteResultController.h"
#import "ZZPatientSymptomController.h"
#import "ZZMyHZListController.h"
#import "ZZRemarkUserController.h"


@interface ZZDiscussController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isReLook;
    
    UITapGestureRecognizer *tapRecognizer;
    
    ZZUserInfo *loginUser;
    
    
    CGFloat keyboardHeight;
}

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)UIView           *headerView;
@property(nonatomic,strong)UIView           *footerView;
@property(nonatomic,strong)ZCTextPlaceholderView       *textView;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZDiscussController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"会诊中" forState:UIControlStateNormal];
    
    [self.menuRightButton setTitle:@"刷新" forState:UIControlStateNormal];
    self.menuRightButton.hidden = NO;
    
    [self createTableView];
}


-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if(sender.tag == RIGHT_BUTTON){
        [self loadMoreData:YES];
    }
}




-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight - 120)];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    _listTable.tableHeaderView = [self createHeaderView];
    
    [self setTableSeparatorInset];
    
    
    [self createFooterView];
    
    [self handleKeyboard];
    
    [self loadMoreData:NO];
}



-(void)headerButtonClick:(UIButton *) btn{
    // 1 病例，2相关诊断 3结论 4、同意 5、发布评论
    if(btn.tag == 1){
        ZZPatientSymptomController *vc = [[ZZPatientSymptomController alloc] init];
        vc.formDoctor = NO;
        vc.entity = _model;
        [self openNav:vc sound:nil];
    }
    
    if(btn.tag == 2){
        ZZMyHZListController *vc = [[ZZMyHZListController alloc] init];
        vc.model = _model;
        [self openNav:vc sound:nil];
    }
    
    if(btn.tag == 3){
        ZZRemarkUserController *vc = [[ZZRemarkUserController alloc] init];
        vc.type = 1;
        ZZUserInfo *info=[ZZUserInfo new];
        info.userId = _model.userId;
        vc.myFriend = info;
        [self openNav:vc sound:nil];
    }
    
    if(btn.tag == 4){
        ZZWriteResultController *vc = [[ZZWriteResultController alloc] init];
        vc.model = _model;
        [vc setResultBlock:^(ZZHZEngity *reModel){
            _model = reModel;
            [_listTable reloadData];
            if(_model.state > 2){
                [self goBack:nil];
            }
        }];
        [self openNav:vc sound:nil];
    }
    
   
    
    if(btn.tag == 5 || btn.tag == 6){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(btn.tag == 5){
            if([@"" isEqual:convertToString(_textView.text)]){
                [self.view makeToast:@"还没有填写讨论内容呢！"];
                return;
            }
            
            [dict setObject:@"0" forKey:@"docAgree"];
            [dict setObject:convertToString(_textView.text) forKey:@"context"];
        }else{
            [dict setObject:@"1" forKey:@"docAgree"];
            if(_model.firstDoc==1){
                [dict setObject:@"11" forKey:@"docAgree"];
                
            }
            [dict setObject:[NSString stringWithFormat:@"%@同意了%@的会诊结果",loginUser.docName,_model.docName] forKey:@"context"];
        }
        
        [dict setObject:convertIntToString(_model.caseId) forKey:@"id"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"docId"];
        
        _textView.text = @"";
        
        [ZZRequsetInterface post:API_SaveTalkCase param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dictResult) {
            if(btn.tag == 4){
                btn.hidden = YES;
                if(_model.firstDoc){
                    [self.view makeToast:@"您作为主诊大夫同意了会诊结果，会诊完成！"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            ZZCaseTalkModel *model = [ZZCaseTalkModel new];
            model.talkId = 0;
            model.userId = loginUser.userId;
            model.context = dict[@"context"];
            model.docName = loginUser.docName;
            model.imgUrl = loginUser.imageUrl;
            model.createTime = dateTransformString(FormateTime, [NSDate date]);
            [_listArray addObject:model];
            
            [_listTable reloadData];
            [self scrollTableToBottom];
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
    
}


/**
 加载更多
 */
-(void)loadMoreData:(BOOL) scrool{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_model.caseId) forKey:@"id"];
    [ZZRequsetInterface post:API_GetCaseTalk param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        [_listArray removeAllObjects];
        if(arr && arr.count>0){
            for (NSDictionary *item in arr) {
                [_listArray addObject:[[ZZCaseTalkModel alloc] initWithMyDict:item]];
                
            }
            [_listTable reloadData];
            if(scrool){
                [self scrollTableToBottom];
            }
        }
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
        if(![@"" isEqual:convertToString(_model.caseResult)]){
            return [ZZCoreTools getHeightContain:convertToString(_model.caseResult) font:ListDetailFont Width:ScreenWidth - 30] + 40 + 45;
        }
        return 0;
    }else{
        return 1.0f;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==0){
        if(![@"" isEqual:convertToString(_model.caseResult)]){
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
            [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
            
            CGFloat y = 0;
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 0)];
            [label setFont:ListDetailFont];
            [label setText:convertToString(_model.caseResult)];
            [label setTextAlignment:NSTextAlignmentLeft];
            [label setTextColor:UIColorFromRGB(TextBlackColor)];
            CGFloat lh = [ZZCoreTools getHeightContain:label.text font:ListDetailFont Width:ScreenWidth - 30];
            [label setFrame:CGRectMake(15, 15, ScreenWidth-30, lh)];
            [label setBackgroundColor:[UIColor clearColor]];
            label.numberOfLines = 0;
            [view addSubview:label];
            
            y = CGRectGetMaxY(label.frame) + 10;
//            if(_model.writeDoc != loginUser.userId){
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//                btn.tag = 6;
//                [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
//                btn.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
//                btn.layer.borderWidth = 1.0f;
//                btn.layer.cornerRadius = 4.0f;
//                btn.layer.masksToBounds = YES;
//                [btn.titleLabel setFont:ListDetailFont];
//                [btn setTitle:@"同意" forState:UIControlStateNormal];
//                [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
//                [btn setFrame:CGRectMake(ScreenWidth - 75, CGRectGetMaxY(label.frame)+10, 60, 30)];
//                [view addSubview:btn];
//
//                y = y + 40;
//            }
            [view setFrame:CGRectMake(0, 0, ScreenWidth, y)];
            
            
            return view;
        }
        return nil;
        
        
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDiscussCell *cell = (ZZDiscussCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZDiscussCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
    
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    [cell dataToView:[_listArray objectAtIndex:indexPath.row]];
    
    
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
    [_textView resignFirstResponder];
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}


-(void)scrollTableToBottom{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_listArray.count>0){
                [self removePlaceholderView];
            }
            
            CGFloat ch=_listTable.contentSize.height;
            CGFloat h=_listTable.bounds.size.height;
            
            //        NSLog(@"当前滚动的高度：%f,%f",ch,h);
            CGRect tf         = _listTable.frame;
            CGFloat x = tf.size.height-_listTable.contentSize.height;
            CGFloat botH = 0;
            if (ZC_iPhoneX && keyboardHeight >0) {
                botH = 34;
            }
            
            if(x > 0){
                if(x<keyboardHeight){
                    tf.origin.y = NavBarHeight - (keyboardHeight - x);
                }
            }else{
                
                tf.origin.y   = NavBarHeight - keyboardHeight + botH;
            }
            
            _listTable.frame  = tf;
            if(ch > h){
                
                [_listTable setContentOffset:CGPointMake(0, ch-h) animated:NO];
            }
        });
    });
    
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


-(UIView *)createHeaderView{
    if(_headerView == nil){
        _headerView = [[UIView alloc] init];
        [_headerView setBackgroundColor:[UIColor clearColor]];
    }else{
        [_headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    NSString *tips = @"您作为非首诊医生，需要统一会结果后，会诊结果才能发送给用户。";
    if(_model.firstDoc){
        tips = @"您作为首诊医生，需要填写结果，待非首诊医生全部同意后，会诊结果才能发送给用户。";
    }
    UIView *tipView =  [self createTips:tips];
    [_headerView addSubview:tipView];
    
    
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@"阅读病例"];
    // 复诊
    if(isReLook){
        [titles addObject:@"相关病例记录"];
    }
    [titles addObject:@"个人资料"];
    // 有结果的
    if([@"" isEqual:convertToString(_model.caseResult)] && _model.firstDoc){
        [titles addObject:@"填写结论"];
    }
    CGFloat y = CGRectGetMaxY(tipView.frame);
    CGFloat x = 15;
    CGFloat xw = (ScreenWidth - 15*(titles.count+1))/titles.count;
    for(int i=0;i<titles.count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 4.0f;
        btn.layer.masksToBounds = YES;
        [btn.titleLabel setFont:ListDetailFont];
        [btn setFrame:CGRectMake(x, y + 15 , xw, 30)];
        if(i<2){
            btn.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
            btn.layer.borderWidth = 1.0f;
            [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
            [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        }else{
            [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
            [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        }
        
        btn.tag = i+1;
        if(i == 1 && !isReLook){
            btn.tag = 3;
        }
        if(i == 2 && !isReLook){
            btn.tag = 4;
        }
        x = x + xw + 15;
        [_headerView addSubview:btn];
    }
    
    [_headerView setFrame:CGRectMake(0, 0, ScreenWidth, y + 30 + 30)];
    
    return _headerView;
}


-(UIView *)createFooterView{
    
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight -NavBarHeight -120)];
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 120, ScreenWidth,120)];
    [_footerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_footerView];
    
//    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 60)];
//    [bgView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
//    [_footerView addSubview:bgView];
    
    
    _textView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, 8, ScreenWidth - 30, 44)];
    [_textView setBackgroundColor:[UIColor whiteColor]];
    [_textView setTextColor:UIColorFromRGB(TextBlackColor)];
    [_textView setFont:ListTitleFont];
    [_textView setPlaceholder:@"请填写讨论内容"];
    [_footerView addSubview:_textView];
    
    
    
    UIButton *btnSendComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSendComment setTitle:@"发送讨论内容" forState:UIControlStateNormal];
    [btnSendComment setFrame:CGRectMake(15, 70, ScreenWidth - 30, 40)];
    btnSendComment.layer.cornerRadius = 4.0f;
    btnSendComment.layer.masksToBounds = YES;
    btnSendComment.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    btnSendComment.layer.borderWidth = 1.0f;
    [btnSendComment setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [btnSendComment setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [btnSendComment addTarget:self action:@selector(headerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btnSendComment.tag = 5;
    [_footerView addSubview:btnSendComment];
    return _footerView;
}




//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    keyboardHeight = 0;
    CGRect f = _footerView.frame;
    f.origin.y = ScreenHeight - 120;
    _footerView.frame = f;
    
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight - 120)];
    
    [UIView commitAnimations];
    
    
    [self.view removeGestureRecognizer:tapRecognizer];
}



//键盘显示
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    // get a rect for the view frame
    {
        
        CGRect bf         = _footerView.frame;
        bf.origin.y       = ScreenHeight - 120 - keyboardHeight;
        _footerView.frame = bf;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    [self.view addGestureRecognizer:tapRecognizer];
}


- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

//屏幕点击事件
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [_textView resignFirstResponder];
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
