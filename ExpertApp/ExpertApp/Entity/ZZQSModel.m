//
//  ZZQSModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZQSModel.h"

@implementation ZZQSModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    
    if(self){
        _quesAnswer = [[NSMutableArray alloc] init];
        if(_quesType == 4){
            if(convertToString(_answerValue).length >0){
                NSArray *iarr = [_answerValue componentsSeparatedByString:@","];
                for (NSString *itemStr in iarr) {
                    if(!is_null(itemStr)){
                        ZZQSAnswerModel *m = [ZZQSAnswerModel new];
                        m.tag = @"";
                        m.context = itemStr;
                        [_quesAnswer addObject:m];
                    }
                }
            }
        }else{
            NSArray *arr = dict[@"quesAnswer"];
            for (NSDictionary *qitem in arr) {
                ZZQSAnswerModel *m = [[ZZQSAnswerModel alloc] initWithMyDict:qitem];
                [_quesAnswer addObject:m];
            }
        }
    }
    return self;
}

@end


@implementation ZZQSAnswerModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    
    if(self){
        _aid = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end

@implementation ZZQSListModel
-(id)initWithMyDict:(NSDictionary *)dict{
    self = [super initWithMyDict:dict];
    if(self){
        _wenjuanId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}

@end
