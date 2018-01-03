//
//  ZZCreatePatientController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"

#import "ZZPatientModel.h"

@interface ZZCreatePatientController : BaseController

@property(nonatomic,assign) int patientId;


@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);

@end
