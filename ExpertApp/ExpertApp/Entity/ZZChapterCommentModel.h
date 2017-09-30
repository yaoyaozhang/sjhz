//
//  ZZChapterCommentModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZChapterCommentModel : ZZBaseModel

@property(nonatomic,assign) int cid;
@property(nonatomic,assign) int nid;//": 1,
@property(nonatomic,assign) int uid;//": 1,
@property(nonatomic,strong) NSString * content;//": "2",
@property(nonatomic,strong) NSString * name;//": "杨磊",
@property(nonatomic,assign) int deptCid;//": "0",
@property(nonatomic,strong) NSMutableArray *child;


@end
