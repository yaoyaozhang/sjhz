//
//  ZZAddSymptomController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZAddSymptomController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "AddSymptomDescController.h"

#import "ZZSymptomWTListView.h"

#import "ZZSymptomCell.h"
#define cellIdentifier @"ZZSymptomCell"

@interface ZZAddSymptomController ()<ZZSymptomCellDelegate>{
    
    NSString *symptomTitle;
    NSString *bsSymptomTitle;
    NSMutableDictionary *wentiMap;
    NSMutableArray *tempArray;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)NSMutableArray   *symptomArray;
@property(nonatomic,strong)NSMutableArray   *checkArray;
@property(nonatomic,strong)NSMutableArray   *bsArray;

@end

@implementation ZZAddSymptomController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"常见症状" forState:0];
    
    symptomTitle = @"点击下面的症状马上为你检查疾病";
    bsSymptomTitle = @"是否还有其他不适伴随症状";
    
    
    [self createTableView];
    
    
    [self loadMoreData];
}

-(void)createTableView{
    _bsArray = [[NSMutableArray alloc] init];
    _checkArray = [[NSMutableArray alloc] init];
    _symptomArray = [[NSMutableArray alloc] init];
    
    _listArray = [[NSMutableArray alloc] init];
    
    _listTable=[self.view createTableView:self cell:nil];
    [_listTable registerClass:[ZZSymptomCell class] forCellReuseIdentifier:cellIdentifier];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight - 40)];
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    
    [self setTableSeparatorInset];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitle:@"下一步" forState:0];
    [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(0,ScreenHeight - 40, ScreenWidth, 40)];
    [self.view addSubview:btn];
}


-(void)addClick:(UIButton *) btn{
    
    if(_checkArray.count == 0){
        [self.view makeToast:@"请选择症状"];
        return;
    }
    
    
    int symptomId = 0;
    NSString *symptomName=@"";
    NSString *bsSymptom=@"";
    NSString *bsSymptomWT=@"";
    ZZSymptomModel *firstModel = [_checkArray firstObject];
    for (int i=0;i<_checkArray.count;i++) {
        ZZSymptomModel *item =_checkArray[i];
        if(i==0){
            symptomId = item.symptomId;
            symptomName = item.sname;
        }else{
            bsSymptom = [bsSymptom stringByAppendingFormat:@"%@;",item.sname];
        }
    }
    if(bsSymptom.length > 1){
        bsSymptom = [bsSymptom substringToIndex:bsSymptom.length - 1];
    }
    
    if(wentiMap){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for(NSString *ikey in wentiMap.allKeys){
           // 输入框内容
           [arr addObject:@{@"id":ikey,@"v":wentiMap[ikey]}];
        }
        bsSymptomWT = [ZCLocalStore DataTOjsonString:arr];
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_patient.patientId) forKey:@"patientId"];
    [dict setObject:@(_docId) forKey:@"docId"];
    [dict setObject:@(symptomId) forKey:@"symptomId"];
    if(firstModel.bansui == 1){
        [dict setObject:bsSymptom forKey:@"bsSymptom"];
    }else{
        [dict setObject:@"" forKey:@"bsSymptom"];
    }
    [dict setObject:convertToString(symptomName) forKey:@"symptomName"];
    [dict setObject:bsSymptomWT forKey:@"wt"];
    
    
    
    AddSymptomDescController *desc = [[AddSymptomDescController alloc] init];
    desc.model = firstModel;
    desc.preParams = dict;
    [desc setZZCreateResultBlock:_ZZCreateResultBlock];
    [self openNav:desc sound:nil];
}

/**
 加载更多
 */
-(void)loadMoreData{
    [SVProgressHUD show];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:convertToString(@"") forKey:@"userId"];
    [ZZRequsetInterface post:API_symptonList param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [SVProgressHUD dismiss];
    } complete:^(NSDictionary *dict) {
        [_symptomArray removeAllObjects];
        NSArray *arr = dict[@"retData"];
        
        if(arr && arr.count>0){
            for (NSDictionary *item in arr) {
                [_symptomArray addObject:[[ZZSymptomModel alloc] initWithMyDict:item]];
            }
            [_listArray addObject:@{@"data":_symptomArray}];
            [_listTable reloadData];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 25;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, 25)];
        [label setFont:ListDetailFont];
        [label setText:@"gansha a"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromRGB(TextBlackColor)];
        [view addSubview:label];
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listArray.count > 1){
        ZZSymptomModel *model = [_checkArray firstObject];
        if(model.bansui == 0){
            return 1;
        }
        return 2;
    }
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZSymptomCell *cell = (ZZSymptomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZSymptomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    cell.delegate = self;
    
    if(indexPath.row == 1 ){
        
        [cell dataToView:bsSymptomTitle data:_listArray[indexPath.row]];
    }else{
        if(_checkArray.count > 0){
            [cell dataToView:@"" data:_listArray[indexPath.row]];
        }else{
            [cell dataToView:symptomTitle data:_listArray[indexPath.row]];
        }
    }
    
    return cell;
}

-(void)onItemClick:(ZZSymptomModel *)model type:(int)type index:(int)index{
    if(type == 1){
        // 编辑，或选项
        // 删除伴随症状
        if(model.symptomId == 0){
            [_checkArray removeObject:model];
            model.checked = NO;
            [_bsArray addObject:model];
        }else{
            // 删除主要症状
            [_checkArray removeAllObjects];
            [_bsArray removeAllObjects];
            [_listArray removeAllObjects];
            [_listArray addObject:@{@"data":_symptomArray}];
            wentiMap = nil;
        }
        [_listTable reloadData];
        
    }else if(type == 2){
        // 编辑，或选项
        if(model.symptomId == 0){
            // 伴随症状点击无效
            if(model.checked){
                [_checkArray removeObject:model];
                model.checked = NO;
                [_bsArray addObject:model];
            }else{
                [_bsArray removeObject:model];
                model.checked = YES;
                [_checkArray addObject:model];
            }
            [_listTable reloadData];
        }else{
            if(model.checked){
                ZZSymptomWTListView *view = [[ZZSymptomWTListView alloc] initWithSymptomView:model arr:tempArray check:wentiMap block:^(int type, id obj) {
                    wentiMap = obj;
                }];
                [view show];
            }else{
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:convertIntToString(model.symptomId) forKey:@"id"];
                [ZZRequsetInterface post:API_symptonWt param:dict timeOut:HttpGetTimeOut start:^{
                    
                } finish:^(id response, NSData *data) {
                    NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                } complete:^(NSDictionary *dict) {
                    
                    NSArray *arr = dict[@"retData"][@"went"];
                    
                    if(arr && arr.count>0){
                        tempArray = [NSMutableArray new];
                        for (NSDictionary *item in arr) {
                            [tempArray addObject:[[ZZSymptomWTModel alloc] initWithMyDict:item]];
                        }
                        ZZSymptomWTListView *view = [[ZZSymptomWTListView alloc] initWithSymptomView:model arr:tempArray check:wentiMap block:^(int type, id obj) {
                            wentiMap = obj;
                        }];
                        [view show];
                    }
                    
                    if(model.bansui == 1){
                        NSArray *bszz = dict[@"retData"][@"bszz"];
                        for (NSString *item in bszz) {
                            ZZSymptomModel *m = [ZZSymptomModel new];
                            m.sname = item;
                            m.checked = NO;
                            [_bsArray addObject:m];
                        }
                    }
                
                    model.checked = YES;
                    [_checkArray addObject:model];
                    
                    
                    [_listArray removeAllObjects];
                    
                    
                    [_listArray addObject:@{@"data":_checkArray,@"isCheck":@"1"}];
                    [_listArray addObject:@{@"data":_bsArray}];
                    [_listTable reloadData];
                
                } fail:^(id response, NSString *errorMsg, NSError *connectError) {
                    
                } progress:^(CGFloat progress) {
                    
                }];
            }
        }
    }
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
    
    
    
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
