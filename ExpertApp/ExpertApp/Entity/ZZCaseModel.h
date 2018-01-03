//
//  ZZCaseModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZCaseModel : ZZBaseModel

@property(nonatomic,assign) int caseId;
@property(nonatomic,strong) NSString *caseName;//病例名称
@property(nonatomic,strong) NSString *name;//姓名
@property(nonatomic,assign) int sex;//性别
@property(nonatomic,strong) NSString* sexName;//性别

@property(nonatomic,assign) int age;//年龄
@property(nonatomic,strong) NSString *city;//所在城市
@property(nonatomic,assign) double weight;//体重 kg
@property(nonatomic,assign) int height;//身高 cm

@property(nonatomic,strong) NSString *sbp;//收缩压
@property(nonatomic,strong) NSString *dbp;//舒张压

@property(nonatomic,strong) NSString *pastMedicalHistory;//既往病史
@property(nonatomic,strong) NSString *parentMedicalHistory;//父母病史
@property(nonatomic,strong) NSString * hospitalLevel;//曾诊治医院级别
@property(nonatomic,strong) NSString * sysptionDescription;//症状描述
@property(nonatomic,strong) NSString * concomitantSysptiomDescription;//伴随症状描述
@property(nonatomic,strong) NSString * usedDrugs;//使用过药物
@property(nonatomic,strong) NSString * inspectionDateUrl;//检查资料,多个用逗号隔开
@property(nonatomic,strong) NSString * graceQuestion;//慧诊问题
@property(nonatomic,strong) NSString * remark;//备注
@property(nonatomic,assign) int userId;//
@property(nonatomic,strong) NSString *createTime;//
@property(nonatomic,assign) int isDel;//
@property(nonatomic,assign) int showDoctor;//0可见
@property(nonatomic,assign) int showUser;//0可见
@property(nonatomic,assign) int state;//病例狀態 0创建并支付、1、待處理、2、正在處理、3、已處理完成


- (NSArray *)getParentproperties;

-(NSMutableArray *) getArrlist;


@end
