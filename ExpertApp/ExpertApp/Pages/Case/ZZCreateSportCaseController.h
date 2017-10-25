//
//  ZZCreateSportCaseController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZSportCaseEntity.h"

@interface ZZCreateSportCaseController : BaseController

@property(nonatomic,strong) NSString *docId;

@property(nonatomic,strong) NSString  *pCaseId;

@property(nonatomic,strong) ZZSportCaseEntity *editModel;


@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);

@end
