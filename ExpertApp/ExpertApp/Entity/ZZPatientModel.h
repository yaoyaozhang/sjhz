//
//  ZZPatientModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZPatientModel : ZZBaseModel

@property(nonatomic,assign) int patientId;

@property(nonatomic,strong) NSString * name;//姓名
@property(nonatomic,assign) int sex;//性别

//展示数据
@property(nonatomic,strong) NSString * sexName;//性别

@property(nonatomic,strong) NSString * birth;//出生日期
@property(nonatomic,strong) NSString * city;//城市
@property(nonatomic,assign) int sbp;//收缩压
@property(nonatomic,assign) int dbp;//舒张压
@property(nonatomic,assign) int weight;//体重
@property(nonatomic,assign) int height;//身高
@property(nonatomic,strong) NSString * pastHistory;//既往病史
@property(nonatomic,strong) NSString * parentsHistory;//父母病史
@property(nonatomic,strong) NSString * phone;//下面
@property(nonatomic,assign) int patients;//和本人关系
@property(nonatomic,strong) NSString *patientName;//和本人关系


-(NSMutableArray *)getArrlist;

@end
