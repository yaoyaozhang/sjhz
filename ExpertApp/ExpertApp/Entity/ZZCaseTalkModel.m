//
//  ZZCaseTalkModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/26.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseTalkModel.h"

@implementation ZZCaseTalkModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    if(self){
        _talkId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end
