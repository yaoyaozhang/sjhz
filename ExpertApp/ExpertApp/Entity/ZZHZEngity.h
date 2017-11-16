//
//  ZZHZEngity.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZHZEngity : ZZBaseModel

@property(nonatomic,assign) int tid;

@property(nonatomic,assign) int caseId;//": 10,

// 0.创建，1处理，2在讨论，3已完成，4在评价
@property(nonatomic,assign) int state;//": 0,
@property(nonatomic,strong) NSString *caseName;//": "putong1",
@property(nonatomic,strong) NSString *createTime;//": "2017-09-25 14:10:02",
@property(nonatomic,strong) NSString *caseQuestion;//": "Meiyou kangaroo l zaishuo",
@property(nonatomic,strong) NSString *caseResult;//": null,
@property(nonatomic,assign) int  type;//": "1"

// 是否首诊医生 1是 0否
@property(nonatomic,assign) int firstDoc;



/**
 填写结果医生
 */
@property(nonatomic,strong)NSString *docName;


/**
 填写结果医生ID
 */
@property(nonatomic,assign) int writeDoc;


@property(nonatomic,assign) int caseDept;//": 10,


@property(nonatomic,assign) int userId;


-(NSString *)getStateName;

@end
