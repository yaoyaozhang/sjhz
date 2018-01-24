//
//  ASQController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZQSModel.h"

typedef NS_ENUM(NSInteger,ASQTYPE) {
    ASQTYPELB = 1, // 量表
    ASQTYPEWJ = 2, // 问卷
    
};

@interface ASQController : BaseController

@property(nonatomic,assign) ASQTYPE type;
@property(nonatomic,assign) int docId;
@property(nonatomic,assign) int userId;
@property(nonatomic,strong) ZZQSListModel *model;

@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);

@end
