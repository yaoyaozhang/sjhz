//
//  ZZKnowledgeUserController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/5/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZTJListModel.h"

@interface ZZKnowledgeUserController : BaseController

@property(nonatomic,strong) ZZTJListModel *model;


/**
 
 */
@property (nonatomic, copy) NSString *newsType;

@end
