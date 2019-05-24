//
//  ZZCommentController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"
#import "ZZChapterModel.h"

@interface ZZCommentController : BaseController

@property(nonatomic,assign) int nid;

@property(nonatomic,strong) ZZChapterModel *model;

@property (nonatomic, strong)  void(^ZZResultBlock) (int status);

@end
