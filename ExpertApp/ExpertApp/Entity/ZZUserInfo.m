//
//  ZZUserInfo.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZUserInfo.h"

@implementation ZZUserInfo

-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    if(self){
        if([@"" isEqual:convertToString(_imageUrl)] || ![convertToString(_imageUrl) hasPrefix:@"http"]){
            if(_isDoctor){
                _imageUrl = [NSString stringWithFormat:@"%@/%@",API_HOST,@"upload/uhead/doctor.png"];
            }else{
                _imageUrl = [NSString stringWithFormat:@"%@/%@",API_HOST,@"upload/uhead/user.png"];
            }
        }
    }
    return self;
}

@end
