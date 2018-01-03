//
//  ZZCreatePatientController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCreatePatientController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"


#import "ZZAlertview.h"
#import "ZCActionSheetView.h"

#import "ZCTextPlaceholderView.h"
#import "ZZCreateCaseBaseCell.h"
#import "ZZCreateCaseCell.h"
#import "ZZCreateCaseMulCell.h"

#define cellIdentifierG @"ZZCreateCaseCell"
#define cellIdentifierM @"ZZCreateCaseMulCell"

#import "NirKxMenu.h"

#import "ZZMyHZListController.h"
#import "PGDatePicker.h"



@interface ZZCreatePatientController ()<ZCActionSheetViewDelegate,ZZCreateCaseDeleate,PGDatePickerDelegate>{
    
    CGPoint        contentoffset;// 记录list的偏移量
    
    UIButton *addBtn;
    
    NSString *inspectionDateUrl;
    
    UIButton *btnHSLevel;
    
    // 1 地区，2关系
    int menuType;
}


@property(nonatomic,strong) ZZPatientModel *editModel;


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,assign)BOOL   isEdit;

@property(nonatomic,strong)UITextField           * tempFiled1;
@property(nonatomic,strong)UITextField           * tempFiled2;
@property(nonatomic,strong)ZCTextPlaceholderView * tempTextView;

@property(nonatomic,strong) UIImagePickerController *imagepicker;

@end

@implementation ZZCreatePatientController

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

-(void)refreshViewData:(BOOL) isRefresh{
    
    [_listArray removeAllObjects];
    //    NSDictionary *dict = [ZCJSONDataTools getObjectData:_model];
    // dictType 字段类型
    // valueType 数据类型
    [_listArray addObjectsFromArray:[_editModel getArrlist]];
    if(isRefresh){
        [_listTable reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 屏蔽橡皮筋功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [self createTitleMenu];
    self.menuRightButton.hidden = YES;
    [self.menuLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    if(_patientId>0){
        _isEdit = YES;
        [self.menuTitleButton setTitle:@"编辑患者信息" forState:UIControlStateNormal];
        
    }else{
        _isEdit = NO;
        _editModel = [ZZPatientModel new];
        
        [self.menuTitleButton setTitle:@"添加新患者" forState:UIControlStateNormal];
    }
    
    _listArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self refreshViewData:YES];
    
    [self getDetail];
}

-(void)getDetail{
    if(_patientId>0){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_patientId) forKey:@"id"];
        [ZZRequsetInterface post:API_serHealthById param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            _editModel = [[ZZPatientModel alloc] initWithMyDict:dict[@"retData"]];
            
            [self refreshViewData:YES];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}


-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        //        if (_editModel) {
        //            ZZAlertview *alertView = [[ZZAlertview alloc] initWithTitle:@"是否放弃创建病例" cancel:@"放弃" comfirm:@"继续编辑"];
        //            [alertView setActionClickBlock:^(NSInteger tag) {
        //                if(tag == 0){
        //                    [self goBack:nil];
        //                }
        //            }];
        //            alertView.tag = 3001;
        //            [alertView show];
        //
        //        }else{
        [self goBack:nil];
        //        }
        return;
    }
    if(sender.tag == 111){
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        [param setObject:convertIntToString([ZZDataCache getInstance].getLoginUser.userId) forKey:@"userId"];
        for(NSDictionary *item in _listArray){
            int isoption = [item[@"isOption"] intValue];
            NSString *dictName = convertToString(item[@"dictName"]);
            NSString *dictValue = convertToString(item[@"dictValue"]);
            
            if(isoption!=0 && [@"" isEqual:dictValue]){
                [self.view makeToast:[NSString stringWithFormat:@"%@不能为空！",item[@"dictDesc"]]];
                return;
            }
            
            int dictType = [item[@"dictType"] intValue];
            if(dictType == ZZEditControlTypeDoubleTextField){
                NSArray *arr = [dictValue componentsSeparatedByString:@","];
                if(arr.count>1){
                    [param setObject:convertToString(arr[0]) forKey:@"sbp"];
                    [param setObject:convertToString(arr[1]) forKey:@"dbp"];
                }else{
                    [param setObject:@"0" forKey:@"sbp"];
                    [param setObject:@"0" forKey:@"dbp"];
                }
            }else if(dictType == ZZEditControlTypeButton){
                [param setObject:item[@"dictValue"] forKey:dictName];
            }else{
                [param setObject:convertToString(item[@"dictValue"]) forKey:dictName];
            }
        }
        param[@"patients"] = convertIntToString(_editModel.patients);
        
        
        //
        NSString *api = API_saveHealth;
        if(_isEdit){
            // 病例名称
            [param setObject:convertIntToString(_patientId) forKey:@"id"];
        }
        
        [ZZRequsetInterface post:api param:param timeOut:HttpPostTimeOut start:^{
            [SVProgressHUD showWithStatus:@"加载中...."];
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
        
            if(_ZZCreateResultBlock){
                _ZZCreateResultBlock(1);
            }
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
}


-(void)noticeNoMoreData:(NSNotification *) info{
    [_listTable reloadData];
}

-(void)tapHideKeyboard{
    if(!is_null(_tempTextView)){
        [_tempTextView resignFirstResponder];
        _tempTextView = nil;
    }else if(!is_null(_tempFiled1)){
        [_tempFiled1 resignFirstResponder];
        _tempFiled1  = nil;
    }else if(!is_null(_tempFiled2)){
        [_tempFiled2 resignFirstResponder];
        _tempFiled2 = nil;
    }else{
        [self allHideKeyBoard];
    }
    
}

- (void) hideKeyboard {
    [self tapHideKeyboard];
    
    if(contentoffset.x != 0 || contentoffset.y != 0){
        // 隐藏键盘，还原偏移量
        [_listTable setContentOffset:contentoffset];
    }
}




-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:nil];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight - 40)];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierG bundle:nil] forCellReuseIdentifier:cellIdentifierG];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierM bundle:nil] forCellReuseIdentifier:cellIdentifierM];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.cancelsTouchesInView = NO;
    [_listTable addGestureRecognizer:gestureRecognizer];
    
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [addBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [addBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [addBtn setTitle:@"保存" forState:UIControlStateNormal];
    addBtn.tag = 111;
    [addBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
}



#pragma mark UITableView delegate Start

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self hideKeyboard];
    [self allHideKeyBoard];
}

// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [label setFont:ListTimeFont];
    [label setText:@"此信息仅您和医生可见,务必填写真实信息,带*为必填项"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [view addSubview:label];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZCreateCaseBaseCell *cell = nil;
    // 0，特殊行   1 单行文本 2 多行文本 3 日期 4 时间 5 数值 6 下拉列表 7 复选框 8 单选框 9 级联字段
    NSDictionary *itemDict = _listArray[indexPath.row];
    int type = [itemDict[@"dictType"] intValue];
    if(type == ZZEditControlTypeTextView){
        cell = (ZZCreateCaseMulCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierM];
        if (cell == nil) {
            cell = [[ZZCreateCaseMulCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierM];
        }
    }else{
        cell = (ZZCreateCaseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierG];
        if (cell == nil) {
            cell = [[ZZCreateCaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierG];
        }
    }
    
    
    cell.tempModel = _editModel;
    cell.tempDict = itemDict;
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell dataToView:itemDict];
    
    
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
    
    
    NSDictionary *itemDict = _listArray[indexPath.section][@"arr"][indexPath.row];
    
    if([itemDict[@"propertyType"] intValue]==3){
        return;
    }
    
//    NSString *dictName = itemDict[@"dictName"];
    
    
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



#pragma mark UITableViewCell 行点击事件处理

-(void)didKeyboardWillShow:(NSIndexPath *)indexPath view1:(ZCTextPlaceholderView *)textview view2:(UITextField *)textField view3:(UITextField *) ttextfield2{
    _tempTextView = textview;
    _tempFiled1 = textField;
    _tempFiled2 = ttextfield2;
    
    //获取当前cell在tableview中的位置
    CGRect rectintableview=[_listTable rectForRowAtIndexPath:indexPath];
    
    //获取当前cell在屏幕中的位置
    CGRect rectinsuperview = [_listTable convertRect:rectintableview fromView:[_listTable superview]];
    
    contentoffset = _listTable.contentOffset;
    
    if ((rectinsuperview.origin.y+50 - _listTable.contentOffset.y)>200) {
        
        [_listTable setContentOffset:CGPointMake(_listTable.contentOffset.x,((rectintableview.origin.y-_listTable.contentOffset.y)-150)+  _listTable.contentOffset.y) animated:YES];
        
    }
}


-(void)onCaseValueChanged:(id)changeModel type:(ZZEditControlType)type dict:(NSDictionary *)dict obj:(id)object{
    _editModel = (ZZPatientModel *)changeModel;
    // 城市
    if([@"city" isEqual:dict[@"dictName"]]){
        menuType  = 1;
        [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
            if(status == 0){
                [SVProgressHUD dismiss];
                
                [self btnShowMenu:object];
            }
            if(status == 1){
                [SVProgressHUD show];
            }
            if(status == 2){
                [SVProgressHUD showErrorWithStatus:@"加载配置信息错误"];
            }
        }];
    }else if([@"patients" isEqual:dict[@"dictName"]]){
        menuType = 2;
        [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
            if(status == 0){
                [SVProgressHUD dismiss];
                
                [self btnShowMenu:object];
            }
            if(status == 1){
                [SVProgressHUD show];
            }
            if(status == 2){
                [SVProgressHUD showErrorWithStatus:@"加载配置信息错误"];
            }
        }];
    }
    else if([@"birth" isEqual:dict[@"dictName"]]){
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.delegate = self;
        [datePicker show];
        datePicker.datePickerMode = PGDatePickerModeDate;
    }else{
        [self refreshViewData:NO];
    }
}



-(void)btnShowMenu:(UIButton *) button{
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:menuType==1?KEY_CONFIG_REGION:KEY_CONFIG_RELATION];
    if(arr==nil || arr.count==0){
        return;
    }
    
    btnHSLevel = button;
    
    //配置一：基础配置
    KxMenu.titleFont = ListDetailFont;
    
    //    //配置二：拓展配置
    OptionalConfiguration options;
    options.arrowSize = 0.0f;
    options.marginXSpacing = 7;
    options.marginYSpacing = 9;
    options.seperatorLineHasInsets = 25;
    options.menuCornerRadius = 0.0f;
    options.maskToBackground = true;
    options.shadowOfMenu = false;
    options.hasSeperatorLine = true;
    options.seperatorLineHasInsets = false;
    
    Color txtColor = {0,0,0};
    Color bgColor = {1,1,1};
    options.textColor = txtColor;
    options.menuBackgroundColor = bgColor;
    NSMutableArray *menuItems=[[NSMutableArray alloc] init];
    
    
    for (ZZDictModel *item in arr) {
        KxMenuItem *item1 =[KxMenuItem menuItem:item.name
                                          image:[UIImage imageNamed:@""]
                                            tag:1
                                         objTag:item
                                         target:self
                                         action:@selector(pushMenuItem:)];
        [item1 setForeColor:[UIColor blackColor]];
        [menuItems addObject:item1];
    }
    
    
    [KxMenu setTitleFont:ListDetailFont];
    CGRect rect = [self.view convertRect:button.frame fromView:button.superview];
    
    //    CGRect rect = [button.superview convertRect:button.frame toView:self.view];
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems withOptions:options];
}

/**
 *  menu 点击事件
 *
 *  @param sender
 */
-(void) pushMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem*) sender;
    
    if(menuType == 1){
     
        _editModel.city = item.title;
    }else{
        ZZDictModel *obj = item.objTag;
        _editModel.patients = obj.baseId;
        _editModel.patientName = obj.name;
    }
    [btnHSLevel setTitle:item.title forState:UIControlStateNormal];
    
    
}


#pragma PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    _editModel.birth = [NSString stringWithFormat:@"%zd-%02zd-%02zd",dateComponents.year,dateComponents.month,dateComponents.day];
    [self refreshViewData:YES];
}

-(void)dealloc{
    
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

