//
//  ZZRewardController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
typedef NS_ENUM(NSInteger,ZZRewardType) {
    ZZRewardTypeChapter=1,
    ZZRewardTypeDoctor=2,
    ZZRewardTypeHZ=3,
};

@interface ZZRewardController : BaseController

@property(nonatomic,assign) ZZRewardType type;
@property(nonatomic,strong) id rewardModel;

@end
