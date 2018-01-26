//
//  ZZPatientSymptomController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/9.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZPatientSymptomController.h"


#import "ZZCreateCaseController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"


#import "ZZAlertview.h"
#import "ZCActionSheetView.h"

#import "ZCTextPlaceholderView.h"
#import "ZZCreateCaseBaseCell.h"
#import "ZZCaseDetailMulCell.h"
#import "ZZCaseDtailCell.h"
#import "ZZHZResultController.h"

#define cellIdentifierG @"ZZCaseDetailMulCell"
#define cellIdentifierM @"ZZCaseDtailCell"
#import "ZZAddPicCell.h"

#define cellIdentifierPic @"ZZAddPicCell"

#import "ZZSymptomDetailCell.h"
#define cellIdentifierWt @"ZZSymptomDetailCell"

#import "NirKxMenu.h"
#import "ZZDiseaseModel.h"

#import "ZZSymptomAlertView.h"


@interface ZZPatientSymptomController (){
    ZZDiseaseModel *detailModel;
}


@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;

@end

@implementation ZZPatientSymptomController


-(void)refreshViewData:(BOOL) isRefresh{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_entity.caseId) forKey:@"id"];
//    [dict setObject:convertIntToString(_entity.diseaseId) forKey:@"diesId"];
//    [dict setObject:convertIntToString(_caseType) forKey:@"type"];
    [ZZRequsetInterface post:API_symptonInterrogation param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        detailModel = [[ZZDiseaseModel alloc] initWithMyDict:dict[@"retData"]];
        [self showDetailView];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}


-(void)showDetailView{
    [_listArray removeAllObjects];
    [_listArray addObject:@{@"code":@"1",
                      @"dictName":@"name",
                      @"dictDesc":@"姓名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(detailModel.health.name),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [_listArray addObject:@{@"code":@"2",
                      @"dictName":@"sexName",
                      @"dictDesc":@"性别",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertIntToString(detailModel.health.sex),
                      @"dictType":convertIntToString(ZZEditControlTypeSex),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [_listArray addObject:@{@"code":@"3",
                      @"dictName":@"age",
                      @"dictDesc":@"年龄",
                      @"placeholder":@"岁",
                      @"dictValue":convertToString(detailModel.health.birth),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [_listArray addObject:@{@"code":@"4",
                      @"dictName":@"city",
                      @"dictDesc":@"所在城市",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(detailModel.health.city),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [_listArray addObject:@{@"code":@"5",
                      @"dictName":@"weight",
                      @"dictDesc":@"体重",
                      @"placeholder":@"kg",
                      @"dictValue":detailModel.health.weight==0?@"":convertIntToString(detailModel.health.weight),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [_listArray addObject:@{@"code":@"7",
                      @"dictName":@"height",
                      @"dictDesc":@"身高",
                      @"placeholder":@"cm",
                      @"dictValue":detailModel.health.height==0?@"":convertIntToString(detailModel.health.height),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];

    [_listArray addObject:@{@"code":@"8",
                      @"dictName":@"xueya",
                      @"dictDesc":@"血压",
                      @"placeholder":@"mmkg",
                      @"dictValue":[NSString stringWithFormat:@"%@,%@",convertIntToString(detailModel.health.sbp),convertIntToString(detailModel.health.dbp)],
                      @"dictType":convertIntToString(ZZEditControlTypeDoubleTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    if(detailModel.symptom.recovery==1){
        [_listArray addObject:@{@"code":@"9",
                                @"dictName":@"oxygen",
                                @"dictDesc":@"最大摄氧量",
                                @"placeholder":@"VO2max",
                                @"dictValue":convertToString(detailModel.disease.oxygen),
                                @"dictType":convertIntToString(ZZEditControlTypeTextField),
                                @"valueType":@"2",
                                @"isOption":@"0",
                                }];
        
        [_listArray addObject:@{@"code":@"10",
                          @"dictName":@"heartRate",
                          @"dictDesc":@"无氧阀心率",
                          @"placeholder":@"HRat",
                          @"dictValue":convertToString(detailModel.disease.heartRate),
                          @"dictType":convertIntToString(ZZEditControlTypeTextField),
                          @"valueType":@"2",
                          @"isOption":@"0",
                          }];
        [_listArray addObject:@{@"code":@"11",
                          @"dictName":@"maxHeartRate",
                          @"dictDesc":@"最大实测极限心率",
                          @"placeholder":@"HRMax",
                          @"dictValue":convertToString(detailModel.disease.maxHeartRate),
                          @"dictType":convertIntToString(ZZEditControlTypeTextField),
                          @"valueType":@"2",
                          @"isOption":@"0",
                          }];
    
        [_listArray addObject:@{@"code":@"12",
                          @"dictName":@"lungTime",
                          @"dictDesc":@"运动心肺检测时间",
                          @"placeholder":@"CPXtime",
                          @"dictValue":convertToString(detailModel.disease.lungTime),
                          @"dictType":convertIntToString(ZZEditControlTypeTextField),
                          @"valueType":@"1",
                          @"isOption":@"0",
                          }];
        if(convertToString(_entity.caseName).length == 0){
            
            _entity.caseName = @"运动评估";
        }
    }else{
        NSString *textDesc = [NSString stringWithFormat:@"%@ 伴随 %@",convertToString(detailModel.symptom.sname),convertToString(detailModel.symptom.bssym)];
        [_listArray addObject:@{@"code":@"20",
                                @"dictName":@"disease",
                                @"dictDesc":@"患者症状",
                                @"placeholder":textDesc,
                                @"dictValue":detailModel.answer,
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
        if(convertToString(_entity.caseName).length == 0){
            _entity.caseName = textDesc;
        }
        
        [_listArray addObject:@{@"code":@"14",
                                @"dictName":@"pastHistory",
                                @"dictDesc":@"既往病史",
                                @"placeholder":@"",
                                @"dictValue":convertToString(detailModel.health.pastHistory),
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
        [_listArray addObject:@{@"code":@"14",
                                @"dictName":@"parentsHistory",
                                @"dictDesc":@"父母病史",
                                @"placeholder":@"",
                                @"dictValue":convertToString(detailModel.health.parentsHistory),
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
        [_listArray addObject:@{@"code":@"13",
                                @"dictName":@"hospitalGrade",
                                @"dictDesc":@"曾诊治医院级别",
                                @"placeholder":@"hospitalGrade",
                                @"dictValue":convertToString(detailModel.disease.hospitalGrade),
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
        [_listArray addObject:@{@"code":@"14",
                                @"dictName":@"useDrugs",
                                @"dictDesc":@"使用药物",
                                @"placeholder":@"",
                                @"dictValue":convertToString(detailModel.disease.useDrugs),
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
        [_listArray addObject:@{@"code":@"15",
                                @"dictName":@"illness",
                                @"dictDesc":@"主诊述求",
                                @"placeholder":@"",
                                @"dictValue":convertToString(detailModel.disease.illness),
                                @"dictType":convertIntToString(ZZEditControlTypeTextView),
                                @"valueType":@"1",
                                @"isOption":@"0",
                                }];
    }
   
    
    [_listArray addObject:@{@"code":@"16",
                      @"dictName":@"cardiogram",
                      @"dictDesc":@"检查资料",
                      @"placeholder":@"选择文件",
                      @"dictValue":detailModel.diseaseList,
                      @"dictType":convertIntToString(ZZEditControlTypeAddPic),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [_listArray addObject:@{@"code":@"17",
                            @"dictName":@"remark",
                            @"dictDesc":@"备注",
                            @"placeholder":@"",
                            @"dictValue":convertToString(detailModel.disease.remark),
                            @"dictType":convertIntToString(ZZEditControlTypeTextView),
                            @"valueType":@"1",
                            @"isOption":@"0",
                            }];
    [_listTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 屏蔽橡皮筋功能
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [self createTitleMenu];
    
    [self.menuLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.menuTitleButton setTitle:@"会诊详情" forState:UIControlStateNormal];
    
    [self.menuRightButton setTitle:@"会诊结果" forState:0];
    
    _listArray = [[NSMutableArray alloc] init];
    
    [self createTableView];
    if(is_null(_entity)){
        self.menuRightButton.hidden = YES;
        
    }else{
        self.menuRightButton.hidden = NO;
        
        [self refreshViewData:YES];
    }
}



-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [self goBack:nil];
        
        return;
    }
    if(sender.tag == RIGHT_BUTTON){
        if(_entity.state < 3){
            NSString *warning = @"";
            if(_entity.state == 0){
                warning = @"您的会诊请求正在等待医生处理！";
            }else if(_entity.state == 1){
                warning = @"医生已接收到你的会诊申请，请耐心等待会诊结果！";
            }else{
                warning = @"医生正在为你会诊，请耐心等待会诊结果！";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"会诊状态" message:warning delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else if(_entity.state == 3 || _entity.state == 4){
            ZZHZResultController *vc = [[ZZHZResultController alloc] init];
            vc.model = _entity;
            [self openNav:vc sound:nil];
        }
    }
    if(sender.tag == 111){
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:0];
        
        
        //
        NSString *api = API_SaveSportCase;
        
        
        [ZZRequsetInterface post:api param:param timeOut:HttpPostTimeOut start:^{
            [SVProgressHUD showWithStatus:@"加载中...."];
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
            [self goBack:nil];
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
}




-(void)createTableView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    _listTable=[self.view createTableView:self cell:nil];
    [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight)];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierG bundle:nil] forCellReuseIdentifier:cellIdentifierG];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierM bundle:nil] forCellReuseIdentifier:cellIdentifierM];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierPic bundle:nil] forCellReuseIdentifier:cellIdentifierPic];
    [_listTable registerNib:[UINib nibWithNibName:cellIdentifierWt bundle:nil] forCellReuseIdentifier:cellIdentifierWt];
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    [self setTableSeparatorInset];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(0, ScreenHeight - 40, ScreenWidth, 40)];
    [addBtn setBackgroundColor:[UIColor whiteColor]];
    [addBtn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [addBtn setTitle:@"马上抢单" forState:UIControlStateNormal];
    addBtn.tag = 111;
    [addBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    if(_formDoctor){
        [_listTable setFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight-NavBarHeight-40)];
        [self.view addSubview:addBtn];
    }
    
}



#pragma mark UITableView delegate Start

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self hideKeyboard];
    //    [self allHideKeyBoard];
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
    [view setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [label setFont:ListTimeFont];
    [label setText:@"请您仔细阅读会诊信息"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:UIColorFromRGB(BgTitleColor)];
    [view addSubview:label];
    return view;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZCaseDetailBaseCell *cell = nil;
    // 0，特殊行   1 单行文本 2 多行文本 3 日期 4 时间 5 数值 6 下拉列表 7 复选框 8 单选框 9 级联字段
    NSDictionary *itemDict = _listArray[indexPath.row];
    int type = [itemDict[@"dictType"] intValue];
    if(type == ZZEditControlTypeAddPic){
        ZZAddPicCell *cell = (ZZAddPicCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierPic];
        if (cell == nil) {
            cell = [[ZZAddPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierPic];
        }
        
        ((ZZAddPicCell *) cell).isDetail = YES;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        [cell dataToView:itemDict];
        return cell;
    } else if([itemDict[@"code"] intValue] == 20){
        ZZSymptomDetailCell *cell = (ZZSymptomDetailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierWt];
        if (cell == nil) {
            cell = [[ZZSymptomDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierWt];
        }
        
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        [cell dataToView:itemDict];
        return cell;
    }else if(type == ZZEditControlTypeTextView || type == ZZEditControlTypeButton){
        cell = (ZZCaseDetailMulCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierG];
        if (cell == nil) {
            cell = [[ZZCaseDetailMulCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierG];
        }
    }else{
        cell = (ZZCaseDtailCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifierM];
        if (cell == nil) {
            cell = [[ZZCaseDtailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifierM];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
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
    if([itemDict[@"code"] intValue] == 20){
        ZZSymptomAlertView *alert = [[ZZSymptomAlertView alloc] initWithTitle:@"症状详情" dict:itemDict cancel:@"关闭" comfirm:@""];
        [alert show];
    }
    
    
    if([itemDict[@"propertyType"] intValue]==3){
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
