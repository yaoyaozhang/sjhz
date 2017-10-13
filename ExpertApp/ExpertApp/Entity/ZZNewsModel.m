//
//  ZZNewsModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNewsModel.h"

@implementation ZZNewsModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    if(self){
        _newsId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end
