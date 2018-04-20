//
//  ZZTJListModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/19.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZTJListModel.h"

@implementation ZZTJListModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        _sid = [convertToString(dict[@"sid"]) intValue];
        _className = convertToString(dict[@"className"]);
        
        _wenzhang  = [[NSMutableArray alloc] init];
        
        NSArray *arr = dict[@"wenzhang"];
        if(arr!=nil && arr.count>0){
            for (NSDictionary *item in arr ) {
                [_wenzhang addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
        }
    }
    return self;
}


@end
