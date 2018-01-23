//
//  AddSymptomDescController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZSymptomModel.h"


@interface AddSymptomDescController : BaseController

@property(nonatomic,strong) ZZSymptomModel *model;


@property(nonatomic,strong) NSMutableDictionary *preParams;

@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);

@end
