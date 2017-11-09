//
//  ZZCaseModel.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseModel.h"
#import <objc/runtime.h>


@implementation ZZCaseModel
-(NSString *)getSexName{
    return _sex==1?@"男":@"女";
}


- (NSArray *)getParentproperties
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


-(NSMutableArray *)getArrlist{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    [arr1 addObject:@{@"code":@"1",
                      @"dictName":@"caseName",
                      @"dictDesc":@"病例名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_caseName),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"2",
                      @"dictName":@"name",
                      @"dictDesc":@"姓名",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_name),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"3",
                      @"dictName":@"sexName",
                      @"dictDesc":@"性别",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertIntToString(_sex),
                      @"dictType":convertIntToString(ZZEditControlTypeSex),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"4",
                      @"dictName":@"age",
                      @"dictDesc":@"年龄",
                      @"placeholder":@"岁",
                      @"dictValue":_age==0?@"":convertIntToString(_age),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"5",
                      @"dictName":@"city",
                      @"dictDesc":@"所在城市",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_city),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"6",
                      @"dictName":@"weight",
                      @"dictDesc":@"体重",
                      @"placeholder":@"kg",
                      @"dictValue":_weight==0?@"":convertIntToString(_weight),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"7",
                      @"dictName":@"height",
                      @"dictDesc":@"身高",
                      @"placeholder":@"cm",
                      @"dictValue":_height==0?@"":convertIntToString(_height),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"8",
                      @"dictName":@"xueya",
                      @"dictDesc":@"血压",
                      @"placeholder":@"mmkg",
                      @"dictValue":[NSString stringWithFormat:@"%@,%@",convertToString(_sbp),convertToString(_dbp)],
                      @"dictType":convertIntToString(ZZEditControlTypeDoubleTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"9",
                      @"dictName":@"postMedicalHistory",
                      @"dictDesc":@"既往病史",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_postMedicalHistory),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"10",
                      @"dictName":@"parentMedicalHistory",
                      @"dictDesc":@"父母病史",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_parentMedicalHistory),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"11",
                      @"dictName":@"hospitalLevel",
                      @"dictDesc":@"曾诊治医院级别",
                      @"placeholder":@"请选择",
                      @"dictValue":convertToString(_hospitalLevel),
                      @"dictType":convertIntToString(ZZEditControlTypeChoose),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"12",
                      @"dictName":@"sysptionDescription",
                      @"dictDesc":@"症状描述",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_sysptionDescription),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [arr1 addObject:@{@"code":@"13",
                      @"dictName":@"concomitantSysptiomDescription",
                      @"dictDesc":@"伴随症状描述",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_concomitantSysptiomDescription),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"14",
                      @"dictName":@"usedDrugs",
                      @"dictDesc":@"使用过药物",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_usedDrugs),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [arr1 addObject:@{@"code":@"15",
                      @"dictName":@"inspectionDateUrl1",
                      @"dictDesc":@"检查资料",
                      @"placeholder":@"选择文件",
                      @"dictValue":convertToString(_inspectionDateUrl1),
                      @"dictType":convertIntToString(ZZEditControlTypeButton),
                      @"valueType":@"1",
                      @"isOption":@"1",
                      }];
    [arr1 addObject:@{@"code":@"16",
                      @"dictName":@"graceQuestion",
                      @"dictDesc":@"会诊问题",
                      @"placeholder":@"希望得到哪些帮助和建议",
                      @"dictValue":convertToString(_graceQuestion),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];

    
    [arr1 addObject:@{@"code":@"17",
                      @"dictName":@"remark",
                      @"dictDesc":@"备注",
                      @"placeholder":@"可将CT报告dicom格式的报告上传至百度云分享链接",
                      @"dictValue":convertToString(_remark),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"1",
                      }];
    return arr1;
}

@end
