//
//  ZZNickController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/10/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
typedef NS_ENUM(NSInteger,ZZUserEidtType) {
    ZZUserEidtTypeNick = 0,
    ZZUserEidtTypeSC   = 1,
};

@interface ZZNickController : BaseController

@property(nonatomic,assign) ZZUserEidtType type;

@end
