//
//  ZZWriteResultController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZHZEngity.h"

@interface ZZWriteResultController : BaseController

@property(nonatomic,strong) ZZHZEngity *model;


@property(nonatomic,strong) void (^ResultBlock)(ZZHZEngity *resultModel);

@end
