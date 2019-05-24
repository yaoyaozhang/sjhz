//
//  ZZKnowledgeCollegeListController.h
//  ExpertApp
//
//  Created by 张新耀 on 2019/5/22.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZKnowledgeCollegeListController : BaseController

@property(nonatomic,strong)UIViewController *preVC;

// 1、MSEP-CPX学院，2.长者运动学院
@property(nonatomic,assign)NSInteger dataType;

-(void)toggleData;

@end

NS_ASSUME_NONNULL_END
