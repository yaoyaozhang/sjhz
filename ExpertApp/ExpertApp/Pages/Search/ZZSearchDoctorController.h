//
//  ZZSearchDoctorController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZDictModel.h"
typedef NS_ENUM(NSInteger,ZZSearchDoctorType) {
    ZZSearchDoctorTypeDefault  = 0,
    ZZSearchDoctorTypeHospital = 1,
    ZZSearchDoctorTypeDoctor   = 2,
};

@interface ZZSearchDoctorController : BaseController

@property(nonatomic,assign) ZZSearchDoctorType searchType;

@end
