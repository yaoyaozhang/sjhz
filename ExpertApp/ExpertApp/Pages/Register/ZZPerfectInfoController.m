//
//  ZZPerfectInfoController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/17.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZPerfectInfoController.h"
#import "ZCTextPlaceholderView.h"
#import "NirKxMenu.h"
#import "MyButton.h"
#import "ZCActionSheetView.h"

typedef NS_ENUM(NSInteger,ZZControlTag) {
    ZZControlTagTextName = 11,
    ZZControlTagHispital = 12,
    ZZControlTagZhicheng = 13,
    ZZControlTagShancang = 15,
    ZZControlTagArea     = 16,
    ZZControlTagLabel    = 17,
    ZZControlTagHeader   = 18,
    ZZControlTagZhengsu  = 19,
    ZZControlTagKeshi    = 20,
    ZZControlTagBindPhone= 21,
};

@interface ZZPerfectInfoController ()<ZCActionSheetViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    CGFloat y;
    
    NSMutableDictionary *keshiMap;
    MyButton *btnCheckBQ;
    
    
    ZZDictModel *zhengchenModel;
    ZZDictModel *areaModel;
    UIButton *btnArrow;
    
    
    UIButton *btnUpload;
    NSString *heaerUrl;
    NSString *zhengsuUrl;
    
    ZZUserInfo *loginUser;
}
@property(nonatomic,strong) UIImagePickerController *imagepicker;

@end

@implementation ZZPerfectInfoController

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

// 隐藏键盘
-(void)downKeyBoard:(id)sender{
    [self allHideKeyBoard];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        
        return YES;
        
    }
    
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [_contentScrollView setBackgroundColor:[UIColor clearColor]];
    
    [_btnCommit setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [_btnCommit setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(downKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    
    
    keshiMap = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self findBaseInfo];
    
    if(_isEdit){
        loginUser = [[ZZDataCache getInstance] getLoginUser];
        [_btnCommit setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        [_btnCommit setTitle:@"提交审核" forState:UIControlStateNormal];
    }
}


-(void)findBaseInfo{
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        if(status == 0){
            [SVProgressHUD dismiss];
            [self createPageView];
        }
        if(status == 1){
            [SVProgressHUD showWithStatus:@"初始化基础信息"];
        }
        if(status == 2){
            [SVProgressHUD showErrorWithStatus:@"加载配置信息错误"];
            [self createPageView];
        }
    }];
}

-(void)createPageView{
    y = 88.0f;
    
    CGFloat space = 15.0f;
    
    y = y + [self createLabelValue:@"姓名" type:1 tag:ZZControlTagTextName holder:@""];
    y = y + space;
    y = y + [self createLabelValue:@"科室" type:5 tag:ZZControlTagKeshi holder:@""];
    y = y + space;
    y = y + [self createLabelValue:@"医院" type:1 tag:ZZControlTagHispital holder:@""];
    y = y + space;
    if(_isEdit){
        y = y + [self createLabelValue:@"手机号" type:1 tag:ZZControlTagBindPhone holder:@"绑定手机"];
        y = y + space;
    }
    y = y + [self createLabelValue:@"职称" type:4 tag:ZZControlTagZhicheng holder:@"选择职称"];
    y = y + space;
    
    y = y + [self createLabelValue:@"擅长" type:2 tag:ZZControlTagShancang holder:@""];
    y = y + space;
    y = y + [self createLabelValue:@"所在地区" type:4 tag:ZZControlTagArea holder:@"选择地区"];
    y = y + space;
    y = y + [self createLabelValue:@"选择标签" type:6 tag:ZZControlTagLabel holder:@""];
    y = y + space;
    if(!_isEdit){
        y = y + [self createLabelValue:@"头像设置" type:3 tag:ZZControlTagHeader holder:@"选择文件"];
        y = y + space;
        y = y + [self createLabelValue:@"医师职业证书" type:3 tag:ZZControlTagZhengsu holder:@"选择文件"];
        y = y + 30;
    }else{
        y = y + 15;
    }
    
    CGRect bf = _btnCommit.frame;
    bf.origin.y = y;
    [_btnCommit setFrame:bf];
    [self setViewBorder:_btnCommit];
    [_btnCommit setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    
    [_contentScrollView setContentSize:CGSizeMake(ScreenWidth, y + 75.0f)];
}


-(IBAction)btnClick:(UIButton *)sender{
    if(sender.tag == 1){
        [SVProgressHUD dismiss];
        [self goBack:nil];
    }
    
    if(sender.tag == 2){
        // 提交审核
        if(_params){
            if(keshiMap){
                NSString *ksIds = @"";
                NSString *ksNames = @"";
                for (NSString *key in keshiMap.allKeys) {
                    MyButton *btnCheckKS = keshiMap[key];
                    ZZDictModel *item = btnCheckKS.objTag;
                    ksIds = [ksIds stringByAppendingFormat:@",%d",item.baseId];
                    ksNames = [ksNames stringByAppendingFormat:@",%@",item.name];
                }
                if(ksIds.length>0){
                    ksIds = [ksIds substringFromIndex:1];
                    ksNames = [ksNames substringFromIndex:1];
                }
                [_params setObject:convertToString(ksIds) forKey:@"departmentId"];
                [_params setObject:convertToString(ksNames) forKey:@"departmentName"];
            }
            
            
            UITextField *textfield = [_contentScrollView viewWithTag:ZZControlTagHispital];
            [_params setObject:convertToString(textfield.text) forKey:@"hospital"];
            
            textfield = [_contentScrollView viewWithTag:ZZControlTagTextName];
            [_params setObject:convertToString(textfield.text) forKey:@"docName"];
            
            
            UITextView *textView = [_contentScrollView viewWithTag:ZZControlTagShancang];
            [_params setObject:convertToString(textView.text) forKey:@"accomplished"];
            
            
            if(btnCheckBQ){
                ZZDictModel *item  = btnCheckBQ.objTag;
                [_params setObject:convertToString(item.name) forKey:@"dclabel"];
            }
            if(zhengchenModel){
                [_params setObject:convertIntToString(zhengchenModel.baseId) forKey:@"titleId"];
                [_params setObject:convertToString(zhengchenModel.name) forKey:@"titleName"];
            }
            if(areaModel){
                [_params setObject:convertToString(areaModel.name) forKey:@"location"];
            }
            [_params setObject:convertToString(heaerUrl) forKey:@"userImageUrl"];
            [_params setObject:convertToString(heaerUrl) forKey:@"imageUrl"];
            [_params setObject:convertToString(zhengsuUrl) forKey:@"certificateUrl1"];
        }
        [ZZRequsetInterface post:API_Register param:_params timeOut:0 start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [ZCLocalStore addObject:_params[@"mobile"] forKey:KEY_LOGIN_USERNAME];
            [ZCLocalStore addObject:_params[@"passWord"] forKey:KEY_LOGIN_USERPWD];
            
            [[ZZDataCache getInstance] saveLoginUserInfo:dict[@"retData"] view:self.view];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
        
    }
}

-(void)btnClickUpload:(UIButton *) btn{
    btnUpload = btn;
    [self didAddImage];
}

-(void)btnShowMenu:(UIButton *) sender{
    NSString *configKey = @"";
    if(sender.tag == ZZControlTagArea){
        configKey = KEY_CONFIG_REGION;
    }
    if(sender.tag == ZZControlTagZhicheng){
        configKey = KEY_CONFIG_TITLE;
    }
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:configKey];
    if(arr==nil || arr.count==0){
        return;
    }
    
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
    

    btnArrow = sender;
    for (ZZDictModel *item in arr) {
        KxMenuItem *item1 =[KxMenuItem menuItem:item.name
                                          image:[UIImage imageNamed:@""]
                                            tag:(int)sender.tag
                                         objTag:item
                                         target:self
                                         action:@selector(pushMenuItem:)];
        [item1 setForeColor:[UIColor blackColor]];
        [menuItems addObject:item1];
    }
    
    
    [KxMenu setTitleFont:ListDetailFont];
    CGRect f = sender.frame;
    f.origin.y = f.origin.y - _contentScrollView.contentOffset.y;
    [KxMenu showMenuInView:self.view fromRect:f menuItems:menuItems withOptions:options];
}

/**
 *  menu 点击事件
 *
 *  @param sender
 */
-(void) pushMenuItem:(id)sender
{
    KxMenuItem *item = (KxMenuItem*) sender;
    if(item.intTag == ZZControlTagZhicheng){
        zhengchenModel = item.objTag;
    }else{
        areaModel = item.objTag;
    }
    
    [btnArrow setTitle:item.title forState:UIControlStateNormal];
    
    
}


/**
 创建行控件

 @param labelText
 @param type 1、单行文本 2、多行文本 ，3 按钮，4下拉，5、科室，6、标签
 @param tag
 */
-(CGFloat )createLabelValue:(NSString *)labelText type:(int) type tag:(int) tag holder:(NSString *) placeHolder{
    CGFloat lh = 0.0f;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, y, 0, 30)];
    [label setText:labelText];
    [label setTextColor:UIColorFromRGB(TextSizeNineColor)];
    [label setFont:ListDetailFont];
    [label setBackgroundColor:[UIColor clearColor]];
    CGSize size = [ZZCoreTools autoHeightOfLabel:label withHeight:30.0f];
    [_contentScrollView addSubview:label];
    CGFloat xx = 42 + size.width;
    CGFloat xw = ScreenWidth - 64 - 10 - size.width;
    if(type == 1){
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(xx, y, xw, 30)];
        [field setPlaceholder:convertToString(placeHolder)];
        field.layer.cornerRadius = 4.0f;
        field.layer.masksToBounds = YES;
        field.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
        field.layer.borderWidth = 1.0f;
        field.tag = tag;
        [field setBackgroundColor:[UIColor clearColor]];
        [field setFont:ListDetailFont];
        [_contentScrollView addSubview:field];
        if(_isEdit){
            if(ZZControlTagTextName == tag){
                [field setText:loginUser.name];
            }
            if(ZZControlTagHispital == tag){
                [field setText:loginUser.hospital];
            }
            
            if(ZZControlTagBindPhone == tag){
                [field setText:loginUser.phone];
            }
        }
        lh = 30;
    }
    else if(type == 2){
        ZCTextPlaceholderView *field = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(xx, y, xw, 80)];
        [field setPlaceholder:convertToString(placeHolder)];
        [self setViewBorder:field];
        field.tag = tag;
        [field setBackgroundColor:[UIColor clearColor]];
        [_contentScrollView addSubview:field];
        if(_isEdit){
            if(ZZControlTagShancang == tag){
                [field setText:loginUser.accomplished];
            }
        }
        lh = 80;
    }
    else if(type == 3 || type == 4){
        UIButton *field = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect bf = CGRectMake(xx, y, xw, 30);
        [field setFrame:bf];
        [self setViewBorder:field];
        field.tag = tag;
        [field.titleLabel setFont:ListDetailFont];
        [field setTitle:placeHolder forState:UIControlStateNormal];
        [field setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        [field setBackgroundColor:[UIColor clearColor]];
        [_contentScrollView addSubview:field];
        if(type == 4){
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(xw - 10, 12, 8, 8)];
            [arrow setImage:[UIImage imageNamed:@"search_dropdown"]];
            [field addSubview:arrow];
            
            [field addTarget:self action:@selector(btnShowMenu:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            [field addTarget:self action:@selector(btnClickUpload:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if(_isEdit){
            if(ZZControlTagZhicheng == tag){
                [field setTitle:loginUser.titleName forState:UIControlStateNormal];
            }
            
            if(ZZControlTagArea == tag){
                [field setTitle:loginUser.location forState:UIControlStateNormal];
            }
        }
        lh = 30;
    }
    else if(type == 5 || type == 6){
        lh = [self createItemButton:xw withType:type x:xx];
        if(lh == 0){
            lh = 30.0f;
        }
    }

    
    return lh;
}

-(void)onItemClick:(MyButton *)btn{
    ZZDictModel *model = btn.objTag;
    if([@"department" isEqual:model.type]){
        MyButton *btnCheckKS = [keshiMap objectForKey:model.name];
        if(btnCheckKS){
            [self setViewBorder:btnCheckKS];
            [btnCheckKS setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
            
            [keshiMap removeObjectForKey:model.name];
            return;
        }
        
        
        [self setViewCheckedBorder:btn];
        [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        
        [keshiMap setObject:btn forKey:model.name];
        
    }else{
        if(btnCheckBQ){
            if(btnCheckBQ.tag == btn.tag){
                return;
            }
            
            [self setViewBorder:btnCheckBQ];
            [btnCheckBQ setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        }
        
        
        [self setViewCheckedBorder:btn];
        [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        btnCheckBQ = btn;
    }
    
}

-(CGFloat )createItemButton:(CGFloat )xw withType:(int) type x:(CGFloat )sx{
    int column = 2;
    CGFloat cy = 0;
    
    // 标签科室
    NSString *configKey = KEY_CONFIG_DCLABEL;
    
    if(type == 5){
        column = 3;
        configKey = KEY_CONFIG_DEPARTMENT;
    }
    
    NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:configKey];
    CGFloat x = sx;
    CGFloat width = (xw - 10*(column-1))/column;
    
    for (int i = 0;i<arr.count; i++) {
        ZZDictModel *model = arr[i];
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        [self setViewBorder:btn];
        [btn setFrame:CGRectMake(x, y + cy, width, 30)];
        btn.tag = i;
        [btn.titleLabel setFont:ListDetailFont];
        btn.objTag = model;
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_contentScrollView addSubview:btn];
        if(_isEdit){
            // 科室
            if(type == 5){
                if([convertToString(loginUser.departmentName) rangeOfString:model.name].location !=NSNotFound)
                {
                    [self setViewCheckedBorder:btn];
                    [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
                    
                    [keshiMap setObject:btn forKey:model.name];
                }
                
            }
            // 标签
            if(type == 6){
//                if([convertToString(loginUser.departmentName) rangeOfString:model.name].location !=NSNotFound)
//                {
//                    [self setViewCheckedBorder:btn];
//                    [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
//                    
//                    [keshiMap setObject:btn forKey:model.name];
//                }
            }
            
        }
        
        x = x + width + 10;
        if((i+1)%column == 0 && i > 0){
            x = sx;
           
            cy = cy + 45.0f;
        }
    }
    if(arr.count % column>0){
        cy = cy + 45.0f;
    }
    if(cy > 0)
        cy = cy - 15.0f;
    
    return cy;
}

-(void) setViewBorder:(UIView *) field{
    field.layer.cornerRadius = 4.0f;
    field.layer.masksToBounds = YES;
    field.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    field.layer.borderWidth = 1.0f;
}


-(void) setViewCheckedBorder:(UIView *) field{
    field.layer.cornerRadius = 4.0f;
    field.layer.masksToBounds = YES;
    field.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    field.layer.borderWidth = 1.0f;
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
        }
        
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        // 原始图片
        UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (originImage) {
            NSData * imageData =UIImageJPEGRepresentation(originImage, 0.5f);
            
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
            
        }
    }
}



#pragma mark -- 上传附件和图片
- (void)updateloadFile:(NSString *)filePath fileName:(NSString *)fileName{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    paramDic[@"file"] = filePath;
    if(btnUpload.tag == ZZControlTagHeader){
        paramDic[@"type"] = @"uhead";
    }else{
        paramDic[@"type"] = @"certificate";
    }
    
    [ZZRequsetInterface post:API_UploadFile param:paramDic timeOut:HttpPostTimeOut start:^{
        [SVProgressHUD showWithStatus:@"上传中"];
    } finish:^(id response, NSData *data) {
        
    } complete:^(NSDictionary *dict) {
        [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        NSLog(@"%@",dict);
        
        if(btnUpload.tag == ZZControlTagHeader){
            heaerUrl = convertToString(dict[@"retData"]);
        }else{
            zhengsuUrl = convertToString(dict[@"retData"]);
        }
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
