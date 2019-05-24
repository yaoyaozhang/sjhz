//
//  ZZKnowledgeSearchController.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZTJListModel.h"

@interface ZZKnowledgeSearchController : BaseController


/**
 0，搜索，1:文章、2专题、3医生
 */
@property(nonatomic,assign) int searchType;


@property(nonatomic,strong) NSString *searchText;

@end
