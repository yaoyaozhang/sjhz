//
//  ZZAcountController.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZAcountController.h"


#import "UIView+Extension.h"

#import "ZZAcountInfoCell.h"
#define cellIdentifier @"ZZAcountInfoCell"

#import "ZZAcountTypeCell.h"
#define cellIdentifierType @"ZZAcountTypeCell"

#import "ZZMyIntegralController.h"
#import "ZZChoosePatientController.h"
#import "ZZKnowledgeTopicModel.h"

@interface ZZAcountController ()<UITableViewDelegate,UITableViewDataSource,ZZAcountTypeCellDelegate>{
    ZZUserInfo *user;
    
    BOOL isLoading;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSArray          *listArray;

@end

@implementation ZZAcountController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"结算台" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = NO;
    
    user = [[ZZDataCache getInstance] getLoginUser];
    [self createTableView];
    [self loadMoreData];
    
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        
        [super buttonClick:sender];
    }
    
    if(sender.tag == 222){
        // 支付积分
        if(isLoading){
            return;
        }
        isLoading = YES;
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertIntToString(_type) forKey:@"type"];
        [dict setObject:convertIntToString(user.userId) forKey:@"userId"];
        [dict setObject:convertToString(_otherId) forKey:@"souId"];
        
        [ZZRequsetInterface post:API_createOrderByUserId param:dict timeOut:HttpGetTimeOut start:^{
            [SVProgressHUD show];
            
        } finish:^(id response, NSData *data) {
            [SVProgressHUD dismiss];
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            isLoading = NO;
        } complete:^(NSDictionary *dict) {
            
            // 已支付
            if(_type == ZZAcountDoctor){
                // 咨询
                ZZChoosePatientController *chooseVC = [[ZZChoosePatientController alloc] init];
                chooseVC.doctorId = convertToString(_otherId);
                chooseVC.doctInfo = _objModel;
                [self openNav:chooseVC sound:nil];
            }else{
                [self.view makeToast:@"本课程已支付成功，请返回视频页面重新点击观看！" duration:2.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 去看视频
                    [self goBack:nil];
                });
            }
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}


- (void)onCellItemClick:(id)sender{
    ZZMyIntegralController *vc = [[ZZMyIntegralController alloc] init];
    
    [self openNav:vc sound:nil];
}

-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable = [self.view createTableView:self cell:cellIdentifier];
    
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-48)];
    if(ZC_iPhoneX){
        [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-48-38)];
    }
    
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierType bundle:nil] forCellReuseIdentifier:cellIdentifierType];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    
    if (iOS7) {
        
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [otherBtn setFrame:CGRectMake(0, ScreenHeight-48-(ZC_iPhoneX?34:0), ScreenWidth, 48)];
    [otherBtn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [otherBtn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [otherBtn.titleLabel setFont:ListDetailFont];
    [otherBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    otherBtn.tag = 222;
    [self.view addSubview:otherBtn];
    
}

/**
 加载更多
 */
-(void)loadMoreData{
    _listArray = @[@{@"code":@"1",@"icon":@"",@"text":@"您选择的服务"},
                   @{@"code":@"2",@"icon":@"",@"text":@"选择支付方式"},
                   @{@"code":@"3",@"icon":@"",@"text":@"您购买的商品是虚拟内容服务，购买不支持退订、转让、退换，请斟酌确认。"}];
    [_listTable reloadData];
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _listArray.count;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 2){
        return 64;
    }
    return 44;
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat sh = 44;
    if(section == 2){
        sh = 64;
    }
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, sh)];
    [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-15, sh)];
    [label setFont:ListDetailFont];
    label.numberOfLines = 0;
    [label setText:_listArray[section][@"text"]];
    
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:UIColorFromRGB(TextBlackColor)];
    if(section == 2){
        [label setTextColor:UIColorFromRGB(TextLightDarkColor)];
    }
    [view addSubview:label];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    
    if(section == 1){
        return 1;
    }
    return 0;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        ZZAcountInfoCell *cell = (ZZAcountInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[ZZAcountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell dataToView:self.item];
        if(_type == ZZAcountDoctor){
            ZZUserInfo *docInfo = _objModel;
            [cell.labTitle setText:[NSString stringWithFormat:@"%@-%@",docInfo.docName,docInfo.accomplished]];
        }else if(_type == ZZAcountDoctorVideo){
            ZZKnowledgeTopicModel *model = _objModel;
            [cell.labTitle setText:[NSString stringWithFormat:@"%@",model.className]];
        }
        return cell;
    }
    ZZAcountTypeCell *cell = (ZZAcountTypeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierType];
    if (cell == nil) {
        cell = [[ZZAcountTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierType];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell dataToView:self.item];
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
    
    //int code =  [_listArray[indexPath.section][@"code"] intValue];
    
    
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
