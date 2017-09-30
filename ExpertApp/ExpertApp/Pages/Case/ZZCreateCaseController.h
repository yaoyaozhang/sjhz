//
//  ZZCreateCaseController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZCaseModel.h"

@interface ZZCreateCaseController : BaseController

@property(nonatomic,strong) NSString *docId;

@property(nonatomic,strong) NSString  *pCaseId;

@property(nonatomic,strong) ZZCaseModel *editModel;

@end
