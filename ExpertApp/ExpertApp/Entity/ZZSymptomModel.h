//
//  ZZSymptomModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZSymptomModel : ZZBaseModel

@property(nonatomic,assign) int symptomId;//症状名称
@property(nonatomic,strong) NSString * sname;//症状名称
@property(nonatomic,assign) int bansui;//症状名称


@property(nonatomic,assign) int checked;//是选择的内容


@end



@interface ZZSymptomWTModel : ZZBaseModel

@property(nonatomic,assign) int symptomWtId;//问题id

@property(nonatomic,strong) NSString * quesName;//问题原始字符串
@property(nonatomic,strong) NSString * quesOptions;//问题原始字符串

@property(nonatomic,strong) NSMutableArray *quesOptionArr;//问题使用的数组

@property(nonatomic,assign) int symid;//症状名称

//1 单 2多 3时间
@property(nonatomic,assign) int type;//问题类型
@property(nonatomic,assign) BOOL checked;//问题类型

@end
