//
//  ZZSportCaseEntity.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseModel.h"

@interface ZZSportCaseEntity : ZZCaseModel

@property(nonatomic,strong) NSString *oxygen;//最大摄氧量
@property(nonatomic,strong) NSString *heartRate;//无氧阀心率
@property(nonatomic,strong) NSString *maxHeartRate;//最大实测极限心率
@property(nonatomic,strong) NSString *lungTime;//运动心肺监测时间
@property(nonatomic,strong) NSString *caseQuestion;//会诊问题
@property(nonatomic,strong) NSMutableArray *cardiogram;//普通心电图
@property(nonatomic,strong) NSMutableArray *sportExercise;//运动心肺
@property(nonatomic,strong) NSMutableArray *backStand;//站立照片

@end
