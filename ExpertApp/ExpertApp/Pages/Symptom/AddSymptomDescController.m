//
//  AddSymptomDescController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "AddSymptomDescController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZSymptomExtModel.h"

#import "ZZAlertview.h"
#import "ZCActionSheetView.h"

#import "ZCTextPlaceholderView.h"
#import "ZZCreateCaseBaseCell.h"
#import "ZZCreateCaseCell.h"
#import "ZZCreateCaseMulCell.h"
#import "ZZAddPicCell.h"

#define cellIdentifierG @"ZZCreateCaseCell"
#define cellIdentifierM @"ZZCreateCaseMulCell"
#define cellIdentifierPic @"ZZAddPicCell"

#import "NirKxMenu.h"

#import "AlertUtil.h"



@interface AddSymptomDescController ()<ZCActionSheetViewDelegate,ZZCreateCaseDeleate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    CGPoint        contentoffset;// 记录list的偏移量
    
    UIButton *addBtn;
    
    NSString *inspectionDateUrl;
    
    UIButton *btnHSLevel;
    
    NSString *curUpTitle;
    
    // 1 地区，2关系
    int menuType;
}


@property(nonatomic,strong) ZZSymptomExtModel *editModel;


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,assign)BOOL   isEdit;

@property(nonatomic,strong)UITextField           * tempFiled1;
@property(nonatomic,strong)UITextField           * tempFiled2;
@property(nonatomic,strong)ZCTextPlaceholderView * tempTextView;

@property(nonatomic,strong) UIImagePickerController *imagepicker;

@end

@implementation AddSymptomDescController

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
    if(_model.recovery){
         [_listArray addObjectsFromArray:[_editModel getSportExt]];
    }else{
         [_listArray addObjectsFromArray:[_editModel getExtList]];
    }
    
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

    
    _editModel = [ZZSymptomExtModel new];
    
    if(!_model.recovery){
        [self.menuTitleButton setTitle:@"病症描述" forState:UIControlStateNormal];
        
    }else{
        [self.menuTitleButton setTitle:@"上传数据" forState:UIControlStateNormal];
    }
    
    _listArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    
    [self refreshViewData:YES];
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
            }else if(dictType == ZZEditControlTypeAddPic){
                if(!is_null(_editModel.picList) && _editModel.picList.count > 0){
                    NSString *pics = [NSString stringWithFormat:@""];
                    NSString *picsName = [NSString stringWithFormat:@""];
                    for (int  i = 0; i < [_editModel.picList count] ; i ++ ) {
                        ZZSymptomExtPicModel *model = _editModel.picList[i];
                        pics  = [pics stringByAppendingFormat:@",%@",model.url];
                        picsName  = [picsName stringByAppendingFormat:@",%@",model.type];
                        
                    }
                    
                    [param setObject:[pics substringFromIndex:1] forKey:@"pics"];
                    [param setObject:[picsName substringFromIndex:1]forKey:@"picNames"];
                }
            }else{
                [param setObject:convertToString(item[@"dictValue"]) forKey:dictName];
            }

            
        }
        
        for (NSString *key in _preParams.allKeys) {
            [param setObject:_preParams[key] forKey:key];
        }
        [param setObject:@"0" forKey:@"state"];
        [param setObject:@"1" forKey:@"firstDoc"];
        [param setObject:@"0" forKey:@"caseDept"];
        
        [ZZRequsetInterface post:API_saveSymptonWt param:param timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            if([@"0" isEqual:dict[@"retCode"]]){
                if(_ZZCreateResultBlock){
                    _ZZCreateResultBlock(1);
                }
                
                if(self.navigationController.viewControllers.count > 2){
                    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
                }else{
                    [self goBack:nil];
                }
            }
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
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
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierPic bundle:nil] forCellReuseIdentifier:cellIdentifierPic];
    
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
    }
    else if(type == ZZEditControlTypeAddPic){
        cell = (ZZAddPicCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierPic];
        if (cell == nil) {
            cell = [[ZZAddPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPic];
        }
    }
    else{
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
    _editModel = (ZZSymptomExtModel *)changeModel;
    // 城市
    if([@"hospitalGrade" isEqual:dict[@"dictName"]]){
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
    }else if(type == ZZEditControlTypeDelImag){
        UIButton *btn = object;
        NSInteger index = btn.tag;
        [_editModel.picList removeObjectAtIndex:index];
        
        [self refreshViewData:YES];
    }else if(type == ZZEditControlTypeAddPic){
        NSArray *arr = @[@"验血",@"验尿",@"CT",@"心电图",@"头部",@"躯干",@"其它"];
        if(_model.recovery){
            arr = @[@"心肺运动试验",@"心电图",@"背部站立照"];
            [[AlertUtil shareInstance] showSheet:@"选择分类" message:@"" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
                if(buttonTag >= 0){
                    curUpTitle = arr[buttonTag];
                    [self didAddImage];
                }
            } buttonTitles:@"心肺运动试验",@"心电图",@"背部站立照", nil];
        }else{
            [[AlertUtil shareInstance] showSheet:@"选择分类" message:@"" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
                if(buttonTag >= 0){
                    curUpTitle = arr[buttonTag];
                    [self didAddImage];
                }
            } buttonTitles:@"验血",@"验尿",@"CT",@"心电图",@"头部",@"躯干",@"其它", nil];
        }
        
    }else{
        [self refreshViewData:NO];
    }
}



-(void)btnShowMenu:(UIButton *) button{
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:menuType==1?KEY_CONFIG_HSLEVEL:KEY_CONFIG_RELATION];
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
        _editModel.hospitalGrade = item.title;
        
    }
    [self refreshViewData:NO];
    [btnHSLevel setTitle:item.title forState:UIControlStateNormal];
    
    
}



///////////////////////////////////////////////////
// 添加图片

- (void)didAddImage{
    
    ZCActionSheetView *actionSheet = [[ZCActionSheetView alloc]initWithDelegate:self title:nil CancelTitle:@"取消" OtherTitles:@"拍照",@"从相册选择", nil];
    [actionSheet show];
}


- (void)actionSheet:(ZCActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            if ([ZZCoreTools isHasCaptureDeviceAuthorization]) {
                _imagepicker = nil;
                _imagepicker=[[UIImagePickerController alloc]init];
                _imagepicker.delegate= self;
                _imagepicker.allowsEditing=NO;
                _imagepicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    _imagepicker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self openWithPresent:_imagepicker animated:YES];
                });
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的手机相机" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
                
            }
            break;
        }
        case 2:
        {
            //                从相册选择
            
            if ([ZZCoreTools isHasPhotoLibraryAuthorization]) {
                
                _imagepicker = nil;
                _imagepicker=[[UIImagePickerController alloc]init];
                _imagepicker.delegate=self;
                _imagepicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                if ([_imagepicker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
                    [_imagepicker.navigationBar setBarTintColor:UIColorFromRGB(BgTitleColor)];
                    [_imagepicker.navigationBar setTranslucent:YES];
                    [_imagepicker.navigationBar setTintColor:[UIColor whiteColor]];
                }else{
                    [_imagepicker.navigationBar setBackgroundColor:UIColorFromRGB(BgTitleColor)];
                }
                
                [_imagepicker.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,TitleFont, NSFontAttributeName, nil]];
                
                
                _imagepicker.allowsEditing=NO;
                
                if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                    _imagepicker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self openWithPresent:_imagepicker animated:YES];
                });
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的手机相册" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
                
            }
            
            break;
        }
        default:
            break;
    }
    
}


#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:NO completion:^{
        
    }];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        // 原始图片
        UIImage * oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        //        发送图片
        if (oriImage) {
            NSData * imageData =UIImageJPEGRepresentation(oriImage, 0.5f);
            
            NSString * fname = [NSString stringWithFormat:@"/Expert/image100%ld.jpg",(long)[NSDate date].timeIntervalSince1970];
            checkPathAndCreate(getDocumentsFilePath(@"/Expert/"));
            NSString *fullPath=getDocumentsFilePath(fname);
            [imageData writeToFile:fullPath atomically:YES];
            
            CGFloat mb=imageData.length/1024/1024;
            if(mb>4){
                [self.view makeToast:@"图片大小需小于4M!" duration:1.0 position:@"center"];
                
                return;
            }
            [self updateloadFile:fullPath fileName:fname];
            
            [_listTable reloadData];
        }
        
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        // 原始图片
        UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (originImage) {
            NSData * imageData =UIImageJPEGRepresentation(originImage, 0.5f);
            
            NSString * fname = [NSString stringWithFormat:@"/expert/image100%ld.jpg",(long)[NSDate date].timeIntervalSince1970];
            checkPathAndCreate(getDocumentsFilePath(@"/expert/"));
            NSString *fullPath=getDocumentsFilePath(fname);
            [imageData writeToFile:fullPath atomically:YES];
            
            CGFloat mb=imageData.length/1024/1024;
            if(mb>4){
                [self.view makeToast:@"图片大小需小于4M!" duration:1.0 position:@"center"];
                
                return;
            }
            
            [self updateloadFile:fullPath fileName:fname];
            
        }
    }
}



#pragma mark -- 上传附件和图片
- (void)updateloadFile:(NSString *)filePath fileName:(NSString *)fileName{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    paramDic[@"file"] = filePath;
    paramDic[@"type"] = @"inspection";
    
    [ZZRequsetInterface post:API_UploadFile param:paramDic timeOut:HttpPostTimeOut start:^{
        [SVProgressHUD showWithStatus:@"上传中"];
    } finish:^(id response, NSData *data) {
        
    } complete:^(NSDictionary *dict) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        NSLog(@"%@",dict);
        if(is_null(_editModel.picList)){
            _editModel.picList = [[NSMutableArray alloc] init];
        }
        ZZSymptomExtPicModel *picModel = [ZZSymptomExtPicModel new];
        
        picModel.url  = convertToString(dict[@"retData"]);
        picModel.type = convertToString(curUpTitle);
        [_editModel.picList addObject:picModel];
        
        [self refreshViewData:YES];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
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
