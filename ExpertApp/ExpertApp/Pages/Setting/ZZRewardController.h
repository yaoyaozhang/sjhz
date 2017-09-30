//
//  ZZRewardController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
typedef NS_ENUM(NSInteger,ZZRewardType) {
    ZZRewardTypeDoctor=1,
    ZZRewardTypeChapter=2,
};

@interface ZZRewardController : BaseController

@property(nonatomic,assign) ZZRewardType type;
@property(nonatomic,strong) id rewardModel;

@end
