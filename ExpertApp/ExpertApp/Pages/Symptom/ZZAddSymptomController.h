//
//  ZZAddSymptomController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZPatientModel.h"

@interface ZZAddSymptomController : BaseController

@property(nonatomic,strong) ZZPatientModel *patient;
@property(nonatomic,assign) int docId;

@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);


@end
