//
//  ZZSettingHelpController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSettingHelpController.h"
#import "UIView+Extension.h"

#import "ZZSettingCell.h"
#define cellIdentifier @"ZZSettingCell"

#import "ZZSettingUserCell.h"
#define cellIdentifierUser @"ZZSettingUserCell"

#import "ZZLoginController.h"
#import "ZZAlertview.h"

#import "ZZPushSettingController.h"
#import "SVWebViewController.h"


@interface ZZSettingHelpController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSArray          *listArray;

@end

@implementation ZZSettingHelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"设置与帮助" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = NO;
    
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
    
    UIButton *footerButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [footerButton setFrame:CGRectMake(0, ScreenHeight-44, ScreenWidth, 44)];
    [footerButton setBackgroundColor:[UIColor whiteColor]];
    [footerButton addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [footerButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [footerButton setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [self.view addSubview:footerButton];
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
}

-(void)loginOut{
    ZZAlertview *alertview = [[ZZAlertview alloc]initWithTitle:@"确定退出登录吗？" cancel:@"取消" comfirm:@"确定"];
    
    [alertview setActionClickBlock:^(NSInteger tag) {
        if(tag == 1){
            [[ZZDataCache getInstance] loginOut];
            
            ZZLoginController * login = [[ZZLoginController alloc] initWithNibName:@"ZZLoginController" bundle:nil];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:login];
            nav.navigationBarHidden=YES;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            [window setRootViewController:nav];
        }
    }];
    [alertview show];
    
    
}


/**
 加载更多
 */
-(void)loadMoreData{
   
    _listArray = @[@{@"code":@"1",@"icon":@"",@"text":@"消息通知"},
                      @{@"code":@"2",@"icon":@"",@"text":@"清除缓存"},
                      @{@"code":@"3",@"icon":@"",@"text":@"协议声明"}];
    
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
    ZZSettingCell *cell = (ZZSettingCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    [cell dataToView:_listArray[indexPath.section]];
    
    
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
    
    int code =  [_listArray[indexPath.section][@"code"] intValue];
    
    if(code == 1){
        ZZPushSettingController *vc = [[ZZPushSettingController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(code == 2){
        [[ZZDataCache getInstance] cleanCache];
        [SVProgressHUD showInfoWithStatus:@"清理完成"];
    }
    if(code == 3){
        SVWebViewController *sv = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        [self openNav:sv sound:nil];
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
