//
//  ZZPatientModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZPatientModel.h"

@implementation ZZPatientModel


-(id)initWithMyDict:(NSDictionary *)dict{
    self= [super initWithMyDict:dict];
    if(self){
        _patientId = [convertToString(dict[@"id"]) intValue];
    }
    return self;
}




-(NSString *)getSexName{
    return _sex==1?@"男":@"女";
}

-(NSString *)gePatientName{
    
    if(_patients>0){
        
        NSMutableArray *arr = [[ZZDataCache getInstance] getConfigArrByType:KEY_CONFIG_RELATION];
        for (ZZDictModel *item in arr) {
            if(item.baseId == _patients){
                return item.name;
            }
        }
    }
    
    return @"";
}



-(NSMutableArray *)getArrlist{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    [arr1 addObject:@{@"code":@"1",
                      @"dictName":@"name",
                      @"dictDesc":@"姓名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_name),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"2",
                      @"dictName":@"sex",
                      @"dictDesc":@"性别",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertIntToString(_sex),
                      @"dictType":convertIntToString(ZZEditControlTypeSex),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"3",
                      @"dictName":@"birth",
                      @"dictDesc":@"年龄",
                      @"placeholder":@"选择日期",
                      @"dictValue":convertToString(_birth).length==0?@"":convertToString(_birth),
                      @"dictType":convertIntToString(ZZEditControlTypeChoose),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"4",
                      @"dictName":@"city",
                      @"dictDesc":@"所在城市",
                      @"placeholder":@"请输入城市",
                      @"dictValue":convertToString(_city),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"5",
                      @"dictName":@"weight",
                      @"dictDesc":@"体重",
                      @"placeholder":@"kg",
                      @"dictValue":_weight==0?@"":convertIntToString(_weight),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"6",
                      @"dictName":@"height",
                      @"dictDesc":@"身高",
                      @"placeholder":@"cm",
                      @"dictValue":_height==0?@"":convertIntToString(_height),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"7",
                      @"dictName":@"xueya",
                      @"dictDesc":@"血压",
                      @"placeholder":@"mmkg",
                      @"dictValue":[NSString stringWithFormat:@"%@,%@",convertIntToString(_sbp),convertIntToString(_dbp)],
                      @"dictType":convertIntToString(ZZEditControlTypeDoubleTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"8",
                      @"dictName":@"pastHistory",
                      @"dictDesc":@"既往病史",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_pastHistory),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"9",
                      @"dictName":@"parentsHistory",
                      @"dictDesc":@"父母病史",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_parentsHistory),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"10",
                      @"dictName":@"patients",
                      @"dictDesc":@"与患者关系",
                      @"placeholder":@"请选择",
                      @"dictValue":[self gePatientName],
                      @"dictType":convertIntToString(ZZEditControlTypeChoose),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"11",
                      @"dictName":@"phone",
                      @"dictDesc":@"手机号",
                      @"placeholder":@"",
                      @"dictValue":convertToString(_phone),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    return arr1;
}

@end
