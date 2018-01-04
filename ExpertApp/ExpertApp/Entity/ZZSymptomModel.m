//
//  ZZSymptomModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomModel.h"

@implementation ZZSymptomModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        _symptomId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end


@implementation  ZZSymptomWTModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        _symptomWtId = [convertToString(dict[@"id"]) intValue];
        _quesOptions = [_quesOptions stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        _quesOptions = [_quesOptions stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        _quesOptionArr  = [[NSMutableArray alloc] init];
        
        [_quesOptionArr addObjectsFromArray:[convertToString(_quesOptions) componentsSeparatedByString:@";"]];
        
    }
    return self;
}

@end
