//
//  ZZDiseaseModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/10.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"
#import "ZZPatientModel.h"
#import "ZZSymptomModel.h"
#import "ZZSymptomExtModel.h"


@interface ZZDiseaseModel : ZZBaseModel

@property(nonatomic,strong) ZZPatientModel * health;//档案
@property(nonatomic,strong) NSMutableArray * diseaseList;//图片地址
@property(nonatomic,strong) ZZSymptomExtModel * disease;//图片地址
@property(nonatomic,strong) NSMutableArray * answer;//图片地址


@property(nonatomic,strong) ZZSymptomModel * symptom;//症状



@end

