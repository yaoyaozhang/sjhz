//
//  ZZKnowledgeTopicModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/5/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeTopicModel.h"

@implementation ZZKnowledgeTopicModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        
        _wenzhang  = [[NSMutableArray alloc] init];
        
        
        if(convertToString(_classUrl).length == 0){
            _classUrl = convertToString(dict[@"picture"]);
        }
        
        NSArray *arr = dict[@"news"];
        if(arr==nil || arr.count == 0){
            arr = dict[@"wenzhang"];
        }
        if(arr!=nil && arr.count>0){
            for (NSDictionary *item in arr ) {
                [_wenzhang addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
            }
        }
    }
    return self;
}

@end
