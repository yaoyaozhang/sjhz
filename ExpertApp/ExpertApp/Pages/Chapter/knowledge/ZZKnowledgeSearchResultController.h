//
//  ZZKnowledgeSearchResultController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"

typedef void(^ZZResultSearchBlcok)(NSString *link);
typedef void(^ZZOpenVCBlock)(UIViewController *vc);

@interface ZZKnowledgeSearchResultController : BaseController

@property(nonatomic,assign) int searchType;

@property(nonatomic,copy) ZZResultSearchBlcok block;
@property(nonatomic,copy) ZZOpenVCBlock openBlock;

-(void)loadResult:(NSString *) text;

@end
