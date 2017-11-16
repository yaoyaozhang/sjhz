//
//  ZZQSModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZQSModel.h"

@implementation ZZQSModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    
    if(self){
        _quesAnswer = [[NSMutableArray alloc] init];
        NSArray *arr = dict[@"quesAnswer"];
        for (NSDictionary *qitem in arr) {
            [_quesAnswer addObject:[[ZZQSAnswerModel alloc] initWithMyDict:qitem]];
        }
    }
    return self;
}

@end


@implementation ZZQSAnswerModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    
    if(self){
        _aid = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end

@implementation ZZQSListModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    if(self){
        _wenjuanId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end
