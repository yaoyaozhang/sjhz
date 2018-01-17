//
//  ZZDiseaseModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/10.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZDiseaseModel.h"

@implementation ZZDiseaseModel

-(id)initWithMyDict:(NSDictionary *)dict{
    self = [[ZZDiseaseModel alloc] init];
    if(self){
        _disease = [[ZZSymptomExtModel alloc] initWithMyDict:dict[@"disease"]];
        _symptom = [[ZZSymptomModel alloc] initWithMyDict:dict[@"symptom"]];
        _health = [[ZZPatientModel alloc] initWithMyDict:dict[@"health"]];
        
        _diseaseList = [[NSMutableArray alloc] init];
        NSArray *arr = dict[@"diseaseList"];
        if(!is_null(arr)){
            for (NSDictionary *item in arr) {
                [_diseaseList addObject:[[ZZSymptomExtPicModel alloc] initWithMyDict:item]];
            }
        }
        
        _answer = [[NSMutableArray alloc] init];
        NSArray *arr2 = dict[@"answer"];
        if(!is_null(arr2)){
            for (NSDictionary *item in arr2) {
                [_answer addObject:[[ZZSymptomWTModel alloc] initWithMyDict:item]];
            }
        }
    }
    return self;
}
@end

