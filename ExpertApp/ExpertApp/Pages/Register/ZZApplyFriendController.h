//
//  ZZApplyFriendController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/10/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZApplyFriendController : BaseController

@property(nonatomic,assign) int toUserId;

@property (nonatomic, strong)  void(^ZZApplyFriendResultBlock) (int status);

@end
