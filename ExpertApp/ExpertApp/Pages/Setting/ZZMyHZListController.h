//
//  ZZMyHZListController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZHZEngity.h"

@interface ZZMyHZListController : BaseController

@property(nonatomic,strong) ZZHZEngity *model;
@property(nonatomic,assign) int userId;

@property(nonatomic,assign) BOOL isFromDoc;

@end
