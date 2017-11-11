//
//  ZZCaseTalkModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/26.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZCaseTalkModel : ZZBaseModel


@property(nonatomic,assign) int talkId;//": 5,

@property(nonatomic,assign) int userId;//": "7",

@property(nonatomic,strong) NSString *context;//": "Hhhhhh",

@property(nonatomic,strong) NSString * docName;//": "李丹",
@property(nonatomic,strong) NSString * createTime;//": "李丹",


@property(nonatomic,strong) NSString * imgUrl;//": "url:/upload/uhead/2017-09-06/demoUploadimage1001504693326.jpg"

@end
