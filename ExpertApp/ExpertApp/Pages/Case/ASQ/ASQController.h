//
//  ASQController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSInteger,ASQTYPE) {
    ASQTYPEWJ = 1, // 问卷
    ASQTYPELB = 2, // 量表
    
};

@interface ASQController : BaseController

@property(nonatomic,assign) ASQTYPE type;
@property(nonatomic,assign) int docId;

@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);

@end
