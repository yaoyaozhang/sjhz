//
//  ASQController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ASQController.h"

#import "UIView+Extension.h"

#import "ZZSQBaseCell.h"

#import "ZZSQTextCell.h"
#import "ZZChooseCell.h"
#define cellIdentifier @"ZZSQTextCell"
#define cellIdentifierChoose @"ZZChooseCell"

@interface ASQController ()<ZZSQBaseCellDelegate>{
    UITextField *tempField;
    CGPoint contentOffset;
    NSString * wenTiId;
    NSString *wenTiName;
    
    NSMutableDictionary *values;
    UIView *bottomView;
}
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;


@end

@implementation ASQController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    if(_type == ASQTYPELB){
        [self.menuTitleButton setTitle:@"量表" forState:UIControlStateNormal];
    }else{
        [self.menuTitleButton setTitle:@"问卷" forState:UIControlStateNormal];
    }
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setTitle:@"跳过" forState:UIControlStateNormal];
    
//    self.menuRightButton.hidden = NO;
//    [self.menuRightButton setTitle:@"刷新" forState:UIControlStateNormal];
    
    [self createTableView];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [_listTable addGestureRecognizer:gestureRecognizer];
    
    if(_model && _model.wenjuanId>0){
        wenTiId = convertIntToString(_model.wenjuanId);
        [self.menuTitleButton setTitle:convertToString(_model.quesName) forState:UIControlStateNormal];
        
    }
    [self loadMoreData];
}



-(UIView *)createBottomView{
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
    [bottomView setBackgroundColor:UIColor.clearColor];
    
    UIButton  *saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saleButton.tag = 111;
    [saleButton setTitle:@"提交" forState:UIControlStateNormal];
    
    
    [saleButton setFrame:CGRectMake(30, 10, ScreenWidth - 60, 35)];
    [saleButton setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [saleButton setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [saleButton.titleLabel setFont:ListTitleFont];
    [saleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:saleButton];
    return bottomView;
    
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        if(_ZZCreateResultBlock){
            _ZZCreateResultBlock(1);
        }
        [self goBack:nil];
    }
    if(sender.tag == 111){
        if(values.count  < _listArray.count){
            [self.view makeToast:@"请填写完整结果！"];
            return;
        }
        NSMutableArray *ans = [NSMutableArray arrayWithCapacity:0];
        for (NSString *key in values.allKeys) {
            NSDictionary *item = values[key];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            for(NSString *ikey in item.allKeys){
                if([ikey hasPrefix:@"value"]){
                    // 输入框内容
                    [arr addObject:@{@"id":key,@"v":convertToString(item[ikey]),@"s":@""}];
                }else{
                    // 选项内容
                    ZZQSAnswerModel *model = item[ikey];
                    [arr addObject:@{@"id":ikey,@"v":convertToString(model.context),@"s":convertToString(model.tag)}];
                }
            }
            [ans addObject:@{@"qid":key,@"answer":arr}];
        }
        NSString *text = [ZCLocalStore DataTOjsonString:ans];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:text forKey:@"values"];
        [dict setObject:wenTiId forKey:@"wenjuanId"];
        [dict setObject:convertIntToString(_type) forKey:@"type"];
        ZZUserInfo *login = [ZZDataCache getInstance].getLoginUser;
        [dict setObject:convertIntToString(login.userId) forKey:@"userId"];
        [ZZRequsetInterface post:API_saveWenJuan param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if(_ZZCreateResultBlock){
                _ZZCreateResultBlock(1);
            }
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [self.view makeToast:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
        
        
        
    }
}



-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    values = [[NSMutableDictionary alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierChoose bundle:nil] forCellReuseIdentifier:cellIdentifierChoose];
    
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
//    
//    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    footer.stateLabel.hidden=YES;
//    _listTable.footer=footer;
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
}


/**
 加载更多
 */
//-(void)loadMoreData{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    if(_model && _model.wenjuanId>0){
//        [dict setObject:convertIntToString(_model.wenjuanId) forKey:@"id"];
//    }
//    [dict setObject:convertIntToString(_docId) forKey:@"userId"];
//
//    [dict setObject:convertToString(_type) forKey:@"type"];
//
//    [ZZRequsetInterface post:API_serachWenJuan param:dict timeOut:HttpGetTimeOut start:^{
//
//    } finish:^(id response, NSData *data) {
//        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    } complete:^(NSDictionary *dict) {
//        wenTiId = convertToString(dict[@"retData"][@"wenTiId"]);
//        [self.menuTitleButton setTitle:convertToString(dict[@"retData"][@"wenTiName"]) forState:UIControlStateNormal];
//
//        NSArray *arr = dict[@"retData"][@"wenTiContext"];
//        for (NSDictionary *item in arr) {
//            [_listArray addObject:[[ZZQSModel alloc] initWithMyDict:item]];
//        }
//        [_listTable reloadData];
//    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
//
//    } progress:^(CGFloat progress) {
//
//    }];
//}


/**
 加载更多
 */
-(void)loadMoreData{
    ZZUserInfo *user = [ZZDataCache getInstance].getLoginUser;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(user.userId) forKey:@"userId"];
    [dict setObject:convertIntToString(_model.wenjuanId) forKey:@"quesId"];
    [dict setObject:convertIntToString((int)_type) forKey:@"type"];
    [ZZRequsetInterface post:API_findWenjuanDetail param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        wenTiId = convertToString(dict[@"retData"][@"wenTiId"]);
        [self.menuTitleButton setTitle:convertToString(dict[@"retData"][@"wenTiName"]) forState:UIControlStateNormal];
        
        NSArray *arr = dict[@"retData"][@"wenTiContext"];
        for (NSDictionary *item in arr) {
            ZZQSModel *m =[[ZZQSModel alloc] initWithMyDict:item];
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:4];
            for(ZZQSAnswerModel *item in m.quesAnswer){
                [temp setObject:item forKey:convertIntToString(item.aid)];
            }
            NSArray *alist = [m.answerId componentsSeparatedByString:@","];
            if(alist && alist.count>0){
                for (int i=0; i<alist.count; i++) {
                    [self onCellClick:[temp objectForKey:convertToString(alist[i])] type:m.quesType with:m];
                }
            }
            [_listArray addObject:m];
        }
        
        _listTable.tableFooterView = [self createBottomView];
        
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}




#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZSQBaseCell *cell = nil;
    ZZQSModel *model=[_listArray objectAtIndex:indexPath.section];
    if(model.quesType == 1 || model.quesType == 2){
        cell =  (ZZChooseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierChoose];
        if (cell == nil) {
            cell = [[ZZChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierChoose];
        }
    }else{
        cell =  (ZZSQTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ZZSQTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
   
    
//    cell.showType = 0;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
//    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    

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
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}



-(void)onCellClick:(id)obj type:(int)type with:(ZZQSModel *)questModel{
    NSMutableDictionary *dict = [values objectForKey:convertIntToString(questModel.quesId)];
    if(is_null(dict)){
        dict = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    if(type == 1){
        ZZQSAnswerModel *model = obj;
        [dict removeAllObjects];
        if(model.isSelected){
            [dict setObject:model forKey:convertIntToString(model.aid)];
        }
    }
    if(type == 2){
        ZZQSAnswerModel *model = obj;
        if(model.isSelected){
            [dict setObject:model forKey:convertIntToString(model.aid)];
        }else{
            [dict removeObjectForKey:convertIntToString(model.aid)];
        }
    }
    
    if(type == 3){
        NSString *text = obj;
        [dict removeAllObjects];
        [dict setObject:text forKey:@"value"];
    }
    questModel.values = dict;
    [values setObject:dict forKey:convertIntToString(questModel.quesId)];
    if(type != 3){
     
//        [_listTable reloadData];
    }
}


#pragma mark UITableViewCell 行点击事件处理

-(void)didKeyboardWillShow:(NSIndexPath *)indexPath view:(UITextField *)textfield{
    tempField = textfield;

    //获取当前cell在tableview中的位置
    CGRect rectintableview=[_listTable rectForRowAtIndexPath:indexPath];

    //获取当前cell在屏幕中的位置
    CGRect rectinsuperview = [_listTable convertRect:rectintableview fromView:[_listTable superview]];

    contentOffset = _listTable.contentOffset;

    if ((rectinsuperview.origin.y+50 - _listTable.contentOffset.y)>200) {

        [_listTable setContentOffset:CGPointMake(_listTable.contentOffset.x,((rectintableview.origin.y-_listTable.contentOffset.y)-150)+  _listTable.contentOffset.y) animated:YES];

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



- (void) hideKeyboard {
    
    [tempField becomeFirstResponder];
    tempField = nil;
    
    if(contentOffset.x != 0 || contentOffset.y != 0){
        // 隐藏键盘，还原偏移量
        [_listTable setContentOffset:contentOffset];
    }
}


- (void)allHideKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [self dismissAllKeyBoardInView:view];
        }
    }
}

-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([self dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
        
    }
    return NO;
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
