//
//  ZZNewsModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/10/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZNewsModel : ZZBaseModel

@property(nonatomic,strong) NSString *context; // 医生张新耀已经接单
@property(nonatomic,assign) int userId;//": "7",
@property(nonatomic,strong) NSString *createTime;//": 1507800722000,
@property(nonatomic,assign) int  newsId;//": 1


/**
 state 1 已读
 */
@property(nonatomic,assign) int  state;//": 1



@end
