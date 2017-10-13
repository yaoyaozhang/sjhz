//
//  ZZNewsListController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/10/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger,ZZNewsType) {
    ZZNewsTypeCase = 1,
    ZZNewsTypeSystem = 2,
};

@interface ZZNewsListController : BaseController

@property(nonatomic,assign) ZZNewsType newType;

@end
