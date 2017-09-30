//
//  ZZSportCaseEntity.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSportCaseEntity.h"

@implementation ZZSportCaseEntity




-(NSMutableArray *)getArrlist{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    [arr1 addObject:@{@"code":@"1",
                      @"dictName":@"caseName",
                      @"dictDesc":@"病例名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(self.caseName),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"2",
                      @"dictName":@"name",
                      @"dictDesc":@"姓名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(self.name),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"3",
                      @"dictName":@"sexName",
                      @"dictDesc":@"性别",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertIntToString(self.sex),
                      @"dictType":convertIntToString(ZZEditControlTypeSex),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"4",
                      @"dictName":@"age",
                      @"dictDesc":@"年龄",
                      @"placeholder":@"岁",
                      @"dictValue":self.age==0?@"":convertIntToString(self.age),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"5",
                      @"dictName":@"city",
                      @"dictDesc":@"所在城市",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(self.city),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"6",
                      @"dictName":@"weight",
                      @"dictDesc":@"体重",
                      @"placeholder":@"kg",
                      @"dictValue":self.weight==0?@"":convertIntToString(self.weight),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"7",
                      @"dictName":@"height",
                      @"dictDesc":@"身高",
                      @"placeholder":@"cm",
                      @"dictValue":self.height==0?@"":convertIntToString(self.height),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"8",
                      @"dictName":@"xueya",
                      @"dictDesc":@"血压",
                      @"placeholder":@"mmkg",
                      @"dictValue":[NSString stringWithFormat:@"%@,%@",convertToString(self.sbp),convertToString(self.dbp)],
                      @"dictType":convertIntToString(ZZEditControlTypeDoubleTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"9",
                      @"dictName":@"oxygen",
                      @"dictDesc":@"最大摄氧量",
                      @"placeholder":@"VO2max",
                      @"dictValue":convertToString(_oxygen),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"10",
                      @"dictName":@"heartRate",
                      @"dictDesc":@"无氧阀心率",
                      @"placeholder":@"HRat",
                      @"dictValue":convertToString(_heartRate),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"11",
                      @"dictName":@"maxHeartRate",
                      @"dictDesc":@"最大实测极限心率",
                      @"placeholder":@"HRMax",
                      @"dictValue":convertToString(_maxHeartRate),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"12",
                      @"dictName":@"lungTime",
                      @"dictDesc":@"运动心肺检测时间",
                      @"placeholder":@"CPXtime",
                      @"dictValue":convertToString(_lungTime),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [arr1 addObject:@{@"code":@"13",
                      @"dictName":@"cardiogram",
                      @"dictDesc":@"上传普通心电图",
                      @"placeholder":@"选择文件",
                      @"dictValue":convertToString(_cardiogram),
                      @"dictType":convertIntToString(ZZEditControlTypeButton),
                      @"valueType":@"1",
                      @"isOption":@"1",
                      }];
    
    [arr1 addObject:@{@"code":@"14",
                      @"dictName":@"sportExercise",
                      @"dictDesc":@"上传运动平板 运动心肺",
                      @"placeholder":@"选择文件",
                      @"dictValue":convertToString(_sportExercise),
                      @"dictType":convertIntToString(ZZEditControlTypeButton),
                      @"valueType":@"1",
                      @"isOption":@"1",
                      }];
    
    
    [arr1 addObject:@{@"code":@"15",
                      @"dictName":@"backStand",
                      @"dictDesc":@"背部站立照",
                      @"placeholder":@"选择文件",
                      @"dictValue":convertToString(_backStand),
                      @"dictType":convertIntToString(ZZEditControlTypeButton),
                      @"valueType":@"1",
                      @"isOption":@"1",
                      }];
    
    
    [arr1 addObject:@{@"code":@"16",
                      @"dictName":@"caseQuestion",
                      @"dictDesc":@"会诊问题",
                      @"placeholder":@"希望得到哪些帮助和建议",
                      @"dictValue":convertToString(_caseQuestion),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    return arr1;
}
@end
