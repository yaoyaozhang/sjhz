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
#import "ZZSQPicCell.h"

#define cellIdentifier @"ZZSQTextCell"
#define cellIdentifierChoose @"ZZChooseCell"
#define cellIdentifierPic @"ZZSQPicCell"
#import "AlertUtil.h"
#import "ZZShareView.h"

#import "ZCActionSheetView.h"

@interface ASQController ()<ZZSQBaseCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZCActionSheetViewDelegate>{
    UITextField *tempField;
    CGPoint contentOffset;
    NSString * wenTiId;
    NSString *wenTiName;
    
    NSMutableDictionary *values;
    UIView *bottomView;
    NSString *curUpTitle;
    ZZQSModel *curPicModel;
    
    NSString *resultText;
}
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@property(nonatomic,strong) UIImagePickerController *imagepicker;


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
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    
//    self.menuRightButton.hidden = NO;
//    [self.menuRightButton setTitle:@"刷新" forState:UIControlStateNormal];
    
    [self createTableView];
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:gestureRecognizer];
    
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
    
    if([self getLoginUser].isDoctor){
        [saleButton setTitle:@"查看结果" forState:UIControlStateNormal];
    }
    
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
        if(convertToString(_model.quesName).length>0){
            // 分享
            ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:(_type == ASQTYPEWJ)?ZZShareTypeWenJuan:ZZShareTypeLiangBiao vc:self];
            shareView.shareModel = _model;
            [shareView show];
        }else{
            [self.view makeToast:@"数据加载中，请稍候再试！"];
        }
        
    }
    if(sender.tag == 111){
        if([self getLoginUser].isDoctor){
            if(_type == ASQTYPELB){
                
            [[AlertUtil shareInstance] showAlert:@"结果成功" message:resultText cancelTitle:nil titleArray:nil viewController:self confirm:^(NSInteger buttonTag) {
                
            }];
            return;
                
            }
        }
        if(values.count  < _listArray.count){
            [self.view makeToast:@"请填写完整结果！"];
            return;
        }
        NSMutableArray *ans = [NSMutableArray arrayWithCapacity:0];
        for(int i=0;i<_listArray.count;i++){
            ZZQSModel *pm = [_listArray objectAtIndex:i];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            if(pm.quesType == 4){
                for (ZZQSAnswerModel *mm in pm.quesAnswer) {
                    // 输入框内容
                    [arr addObject:@{@"n":convertIntToString(pm.quesType),@"id":convertIntToString(pm.quesId),@"v":convertToString(mm.context),@"s":convertToString(mm.tag)}];
                }
            }else{
                NSString *key = convertIntToString(pm.quesId);
                NSDictionary *item = values[key];
                
                for(NSString *ikey in item.allKeys){
                    if([ikey hasPrefix:@"value"]){
                        // 输入框内容
                        [arr addObject:@{@"n":pm.quesNum,@"id":key,@"v":convertToString(item[ikey]),@"s":@""}];
                    }else{
                        // 选项内容
                        ZZQSAnswerModel *model = item[ikey];
                        [arr addObject:@{@"n":pm.quesNum,@"id":ikey,@"v":convertToString(model.context),@"s":convertToString(model.tag)}];
                    }
                }
            }
            [ans addObject:@{@"qid":convertIntToString(pm.quesId),@"answer":arr}];
        }
        NSString *text = [ZCLocalStore DataTOjsonString:ans];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:text forKey:@"values"];
        [dict setObject:wenTiId forKey:@"wenjuanId"];
        [dict setObject:convertIntToString(_model.type) forKey:@"type"];
        ZZUserInfo *login = [ZZDataCache getInstance].getLoginUser;
        [dict setObject:convertIntToString(login.userId) forKey:@"userId"];
        [ZZRequsetInterface post:API_saveWenJuan param:dict timeOut:HttpGetTimeOut start:^{
           if(_type == ASQTYPELB){
             
               [SVProgressHUD showWithStatus:@"正在计算结果"];
           }else{
               [SVProgressHUD show];
           }
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
            if(_type == ASQTYPELB){
             
                NSString *restult = [NSString stringWithFormat:@"总分%@\n%@\n%@",dict[@"retData"][@"total"],dict[@"retData"][@"result"],dict[@"retData"][@"coreSouce"]] ;
                [[AlertUtil shareInstance] showAlert:@"提交成功" message:restult cancelTitle:@"再来一次" titleArray:@[@"确定"] viewController:self confirm:^(NSInteger buttonTag) {
                    if(buttonTag == 0){
                        if(_ZZCreateResultBlock){
                            _ZZCreateResultBlock(1);
                        }
                        [self goBack:nil];
                    }
                }];
            }else{
                [self.view makeToast:@"提交成功！"];
                if(_ZZCreateResultBlock){
                    _ZZCreateResultBlock(1);
                }
                [self goBack:nil];
            }
            
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
    
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierPic bundle:nil] forCellReuseIdentifier:cellIdentifierPic];
    
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
-(void)loadMoreData{
    ZZUserInfo *user = [ZZDataCache getInstance].getLoginUser;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_userId>0?_userId:user.userId) forKey:@"userId"];
    [dict setObject:convertIntToString(_model.wenjuanId) forKey:@"quesId"];
    [dict setObject:convertIntToString(_model.type) forKey:@"type"];
    [ZZRequsetInterface post:API_findWenjuanDetail param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(_type == ASQTYPELB){
            resultText=[NSString stringWithFormat:@"总分%@\n%@\n%@",dict[@"retData"][@"total"],dict[@"retData"][@"result"],dict[@"retData"][@"coreSouce"]] ;
        }
        wenTiId = convertToString(dict[@"retData"][@"wenTiId"]);
        [self.menuTitleButton setTitle:convertToString(dict[@"retData"][@"wenTiName"]) forState:UIControlStateNormal];
        _model.quesName = dict[@"retData"][@"wenTiName"];
        NSArray *arr = dict[@"retData"][@"wenTiContext"];
        if(arr.count>0){
            for (NSDictionary *item in arr) {
                ZZQSModel *m =[[ZZQSModel alloc] initWithMyDict:item];
                if(convertToString(m.answerId).length>0){
                    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithCapacity:4];
                    
                    for(ZZQSAnswerModel *item in m.quesAnswer){
                        [temp setObject:item forKey:convertIntToString(item.aid)];
                    }
                    NSArray *alist = [m.answerId componentsSeparatedByString:@","];
                    if(alist && alist.count>0){
                        for (int i=0; i<alist.count; i++) {
                            
                            if(m.quesType==3){
                                
                                [self onCellClick:m.answerValue type:m.quesType with:m];
                            }else if(m.quesType== 4){
                                [values setObject:m.quesAnswer forKey:convertIntToString(m.quesId)];
                            }else{
                                ZZQSAnswerModel *obj = [temp objectForKey:convertToString(alist[i])];
                                obj.isSelected = YES;
                                [self onCellClick:obj type:m.quesType with:m];
                            }
                            
                        }
                    }
                }
                [_listArray addObject:m];
            }
            
            if([self getLoginUser].isDoctor && _type == ASQTYPEWJ){
                _listTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            }else{
                _listTable.tableFooterView = [self createBottomView];
            }
            
            [_listTable reloadData];
            
        }else{
            [self.view makeToast:@"内容已过期!"];
        }
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
    }else if(model.quesType == 4){
        cell =  (ZZSQPicCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierPic];
        if (cell == nil) {
            cell = [[ZZSQPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPic];
        }
    }
    else{
        cell =  (ZZSQTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ZZSQTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
   
    if([self getLoginUser].isDoctor){
        cell.showType = 1;
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



-(ZZQSModel *)onCellClick:(id)obj type:(int)type with:(ZZQSModel *)questModel{
    
    // 4添加图片，5删除图片
    if(type == 4){
        curPicModel = questModel;
        curUpTitle =  @"";
        [self didAddImage];
        
//        NSArray *arr = @[@"心肺运动试验",@"心电图",@"背部站立照"];
//        [[AlertUtil shareInstance] showSheet:@"选择分类" message:@"" cancelTitle:@"取消" viewController:self confirm:^(NSInteger buttonTag) {
//            if(buttonTag >= 0){
//                curUpTitle = arr[buttonTag];
//                [self didAddImage];
//            }
//        } buttonTitles:@"心肺运动试验",@"心电图",@"背部站立照", nil];
    }else if(type == 5){
        [questModel.quesAnswer removeObject:obj];
        [values setObject:questModel.quesAnswer forKey:convertIntToString(questModel.quesId)];
        [_listTable reloadData];
    }else{
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
        
        
    }
    
    
    return questModel;
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
    
    [self allHideKeyBoard];
    
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
        ZZQSAnswerModel *picModel = [ZZQSAnswerModel new];
        picModel.tag = curUpTitle;
        picModel.context = convertToString(dict[@"retData"]);
        picModel.wentiId = 0;
        if(is_null(curPicModel.quesAnswer)){
            curPicModel.quesAnswer = [[NSMutableArray alloc] init];
        }
        [curPicModel.quesAnswer addObject:picModel];
        
        [values setObject:curPicModel.quesAnswer forKey:convertIntToString(curPicModel.quesId)];
        
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD showErrorWithStatus:errorMsg];
    } progress:^(CGFloat progress) {
        
    }];
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
