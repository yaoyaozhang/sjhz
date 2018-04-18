//
//  ZZKnowledgeSearchResultController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"

typedef void(^ZZResultSearchBlcok)(NSString *link);

@interface ZZKnowledgeSearchResultController : BaseController

@property(nonatomic,copy) ZZResultSearchBlcok block;

-(void)loadResult:(NSString *) text;

@end
