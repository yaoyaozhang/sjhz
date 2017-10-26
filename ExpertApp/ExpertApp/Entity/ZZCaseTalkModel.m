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
        
        if([@"" isEqual:convertToString(_imgUrl)]){
            
            _imgUrl = [NSString stringWithFormat:@"%@/%@",API_HOST,@"upload/uhead/doctor.png"];
            
        }else if(![convertToString(_imgUrl) hasPrefix:@"http"]){
            _imgUrl = [NSString stringWithFormat:@"%@%@",API_HOST,_imgUrl];
        }
    }
    return self;
}

@end
