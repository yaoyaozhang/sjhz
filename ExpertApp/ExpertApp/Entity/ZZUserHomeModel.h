//
//  ZZUserHomeModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"
#import "ZZChapterModel.h"

/**
 医生列表数据
 */
@interface ZZUserHomeModel : ZZBaseModel

@property(nonatomic,strong) ZZUserInfo *docInfo;
@property(nonatomic,strong) ZZChapterModel *chpater;

@end
