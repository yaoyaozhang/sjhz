//
//  ZZChapterCommentModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterCommentModel.h"

@implementation ZZChapterCommentModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        if(_deptCid == 0 && dict[@"son"]){
            NSArray *arr = dict[@"son"];
            if(arr && arr.count>0){
                _child = [[NSMutableArray alloc] init];
                for (NSDictionary *item in arr) {
                    if(item[@"cid"]==0){
                        continue;
                    }
                    [_child addObject:[[ZZChapterCommentModel alloc] initWithMyDict:item]];
                }
            }
        }
            
    }
    return self;
}

@end
