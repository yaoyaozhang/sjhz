//
//  ZZUserHomeModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZUserHomeModel.h"

@implementation ZZUserHomeModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self = [[ZZUserHomeModel alloc] init];
    if(self){
        _docInfo = [[ZZUserInfo alloc] initWithMyDict:dict];
        _chpater = [[ZZChapterModel alloc] initWithMyDict:dict];
    }
    return self;
}

@end
