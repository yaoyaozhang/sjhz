//
//  ZZKnowledgeHomeController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZKnowledgeHomeController : BaseController

@property(nonatomic,strong)UIViewController *preVC;

- (void)beginNetRefreshData;

@end
