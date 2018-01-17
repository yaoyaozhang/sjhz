//
//  ZZSymptomExtModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZSymptomExtModel : ZZBaseModel


@property(nonatomic,strong) NSString *oxygen;//最大摄氧量
@property(nonatomic,strong) NSString *heartRate;//无氧阀心率
@property(nonatomic,strong) NSString *maxHeartRate;//最大实测极限心率
@property(nonatomic,strong) NSString *lungTime;//运动心肺监测时间

@property(nonatomic,assign) int  healthId;//健康档案id

@property(nonatomic,strong) NSString * hospitalGrade;//曾诊治医院级别
@property(nonatomic,strong) NSString * useDrugs;//使用过药物
@property(nonatomic,strong) NSString * illness;//慧诊问题
@property(nonatomic,strong) NSString *symdescription;//慧诊问题

@property(nonatomic,strong) NSString * remark;//备注


@property(nonatomic,strong) NSMutableArray * picList;//图片地址


-(NSMutableArray *)getExtList;

-(NSMutableArray *)getSportExt;

@end


// 图片
@interface ZZSymptomExtPicModel : ZZBaseModel

@property(nonatomic,strong) NSString * diseaseId;//备注
@property(nonatomic,strong) NSString * type;//备注
@property(nonatomic,strong) NSString * url;//备注

@end
