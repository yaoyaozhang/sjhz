//
//  ZZDoctorDetailController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZUserHomeModel.h"

@interface ZZDoctorDetailController : BaseController

@property(nonatomic,assign) int docId;
@property(nonatomic,strong) ZZUserHomeModel *model;


@end
