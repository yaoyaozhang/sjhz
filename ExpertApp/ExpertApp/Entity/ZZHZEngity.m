//
//  ZZHZEngity.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZHZEngity.h"

@implementation ZZHZEngity

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        _caseId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

-(NSString *)getStateName{
    // 0.创建，1处理，2在讨论，3已完成，4在评价
    switch (_state) {
        case 0:
            return @"待处理";
            break;
        case 1:
            return @"正在处理";
            break;
            
        case 2:
            return @"讨论中";
            break;
        case 3:
            return @"已完成";
            break;
        case 4:
            return @"已评价";
            break;
        default:
            return @"删除";
            break;
    }
    return @"";
}

@end
