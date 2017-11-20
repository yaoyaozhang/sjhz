//
//  ZZEditUserController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZEditUserController.h"

#import "UIView+Extension.h"

#import "ZZEditUserCell.h"
#define cellIdentifier @"ZZEditUserCell"

#import <SDWebImage/UIImageView+WebCache.h>

#import "ZCActionSheetView.h"
#import <Toast/UIView+Toast.h>
#import "ZZFindPwdController.h"
#import "ZZNickController.h"
#import "ZZPerfectInfoController.h"
#import "ZZDoctorArchivesController.h"



@interface ZZEditUserController ()<UITableViewDelegate,UITableViewDataSource,ZZUserEditDelegate,UIImagePickerControllerDelegate,ZCActionSheetViewDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSArray          *listArray;
@property(nonatomic,strong)UIImagePickerController *imagepicker;

@property(nonatomic,strong)ZZUserInfo *loginUser;

@end

@implementation ZZEditUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"个人信息" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = NO;
    
    _loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    [self createTableView];
    [self loadMoreData];
    
    
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    
    if (iOS7) {
        
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
}

/**
 加载更多
 */
-(void)loadMoreData{
    
    _listArray = @[@{@"code":@"1",@"icon":@"",@"text":@"头像"},
                   @{@"code":@"2",@"icon":@"",@"text":@"昵称"},
                   @{@"code":@"3",@"icon":@"",@"text":@"手机号绑定"}];
    if(_loginUser.isDoctor){
        _listArray = @[@{@"code":@"1",@"icon":@"",@"text":@"头像"},
                       @{@"code":@"4",@"icon":@"",@"text":@"基本资料"},
                       @{@"code":@"5",@"icon":@"",@"text":@"擅长"},
                       @{@"code":@"6",@"icon":@"",@"text":@"背景资料"}];
    }
    
    [_listTable reloadData];
}


-(void)changeValue:(UISwitch *) sender{
    if(sender.tag == 0){
        
    }
    if(sender.tag == 1){
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_listTable reloadData];
}


#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section>0){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        //        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, 25)];
        //        [label setFont:ListDetailFont];
        //        [label setText:@"gansha a"];
        //        [label setTextAlignment:NSTextAlignmentLeft];
        //        [label setTextColor:UIColorFromRGB(TextBlackColor)];
        //        [view addSubview:label];
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZEditUserCell *cell = (ZZEditUserCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZEditUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    NSDictionary *dict = _listArray[indexPath.section];
    [cell initToDictView:dict info:_loginUser];
    
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
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
        return 80;
    }
    return 44;
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    int code =  [_listArray[indexPath.section][@"code"] intValue];
    if(code == 1){
        [self didAddImage];
    }
    if(code == 2){
        ZZNickController *vc = [[ZZNickController alloc] init];
        vc.type = ZZUserEidtTypeNick;
        [self openNav:vc sound:nil];
    }
    if(code == 5){
        
        ZZNickController *vc = [[ZZNickController alloc] init];
        vc.type = ZZUserEidtTypeSC;
        [self openNav:vc sound:nil];
    }
    if(code == 3){
        ZZFindPwdController *vc = [[ZZFindPwdController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(code == 4){
        ZZPerfectInfoController *vc = [[ZZPerfectInfoController alloc] init];
        vc.params = [[NSMutableDictionary alloc] init];
        vc.isEdit = YES;
        [self openNav:vc sound:nil];
    }
    
    if(code == 6){
        ZZDoctorArchivesController *vc = [[ZZDoctorArchivesController alloc] init];
        [self openNav:vc sound:nil];
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


-(void)onEditCellClick:(NSString *)tag{
    if([@"bound" isEqual:tag]){
        
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
    
    _loginUser.imageUrl = filePath;
    [_listTable reloadData];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    paramDic[@"file"] = filePath;
    paramDic[@"type"] = @"uhead";
    paramDic[@"userId"] = convertIntToString(_loginUser.userId);
    
    [ZZRequsetInterface post:API_UploadFile param:paramDic timeOut:HttpPostTimeOut start:^{
        [SVProgressHUD showWithStatus:@"上传中"];
    } finish:^(id response, NSData *data) {
        
    } complete:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
        _loginUser.imageUrl = convertToString(dict[@"retData"]);
        [[ZZDataCache getInstance] changeUserInfo:_loginUser];
        
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
