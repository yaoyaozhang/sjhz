//
//  ZZCaseDetailController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZCaseModel.h"
#import "ZZSportCaseEntity.h"

@interface ZZCaseDetailController : BaseController

@property(nonatomic,assign) BOOL    formDoctor;


@property(nonatomic,assign) int     caseId;
@property(nonatomic,assign) int     caseType;



@property(nonatomic,strong) ZZCaseModel *editModel;
@property(nonatomic,strong) ZZSportCaseEntity *sportModel;

@end
