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
        _user = [[ZZUserInfo alloc] initWithMyDict:dict];
        
        _news  = [[NSMutableArray alloc] init];
        
        NSArray *arr = dict[@"news"];
        if(arr!=nil && arr.count>0){
            for (NSDictionary *item in arr ) {
                ZZChapterModel *model = [[ZZChapterModel alloc] initWithMyDict:item];
                [_news addObject:model];
                
            }
        }
    }
    return self;
}


@end
