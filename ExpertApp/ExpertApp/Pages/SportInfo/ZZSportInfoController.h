//
//  ZZSportInfoController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZSportCaseEntity.h"

@interface ZZSportInfoController : BaseController

@property(nonatomic,strong) NSString *docId;

@property(nonatomic,strong) NSString  *pCaseId;

@property(nonatomic,strong) ZZSportCaseEntity *editModel;


@property (nonatomic, strong)  void(^ZZCreateResultBlock) (int status);
@end
