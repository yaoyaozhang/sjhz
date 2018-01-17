//
//  ZZRSTableController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/15.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
typedef void(^ZZResultSearchBlcok)(NSString *link);

@interface ZZRSTableController : BaseController

@property(nonatomic,copy) ZZResultSearchBlcok block;

-(void)loadResult:(NSString *) text;

@end
