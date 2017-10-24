//
//  ZZBaseModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"
#import <objc/runtime.h>

@implementation ZZBaseModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self=[super init];
    if(self){
        @try {
            for (NSString *key in [self properties]) {
                if (dict[key]) {
                    if(is_null(dict[key])){
                        [self setValue:convertToString(dict[key]) forKey:key];
                    }else{
                        [self setValue:dict[key] forKey:key];
                    }
                }else{
                    [self setValue:convertToString(@"") forKey:key];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return self;
}

- (NSArray *)properties
{
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:outCount];
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [arrayM addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    return arrayM;
}



@end
