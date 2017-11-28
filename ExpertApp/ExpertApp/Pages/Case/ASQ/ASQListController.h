//
//  ASQListController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/15.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger,ASQPageType) {
    
    ASQPageTypeLiangBiao = 1,
    ASQPageTypeWenJuan   = 2,
    
};

@interface ASQListController : BaseController

@property(nonatomic,assign) int userId;


@property(nonatomic,assign) ASQPageType type;

@end
