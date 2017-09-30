//
//  ZZDiscussController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZHZEngity.h"

@interface ZZDiscussController : BaseController

@property(nonatomic,strong) ZZHZEngity *model;

@property(nonatomic,strong) NSMutableDictionary *checkDoctors;

@end
