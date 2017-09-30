//
//  ZZInviteDoctorController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZHZEngity.h"

@interface ZZInviteDoctorController : BaseController

@property(nonatomic,strong) ZZHZEngity *model;

@property(nonatomic,assign) BOOL isRecommend;
@property(nonatomic,assign) BOOL isInvited;

@property(nonatomic,strong) void (^ResultBlock)(NSMutableDictionary *checkDoctors);

@end
