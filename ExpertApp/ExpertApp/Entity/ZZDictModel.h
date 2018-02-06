//
//  ZZDictModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZDictModel : ZZBaseModel
@property(nonatomic,assign) int      baseId;
@property(nonatomic,strong) NSString *code;//": "01",
@property(nonatomic,strong) NSString *createDate;//": null,
@property(nonatomic,strong) NSString *name;//": "甲状腺内分泌",
@property(nonatomic,strong) NSString *remark;//": "专业",
@property(nonatomic,strong) NSString *type;//": "department"
@end
