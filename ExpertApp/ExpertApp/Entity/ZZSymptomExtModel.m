//
//  ZZSymptomExtModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomExtModel.h"

@implementation ZZSymptomExtModel


-(NSMutableArray *)getExtList{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    
    [arr1 addObject:@{@"code":@"6",
                      @"dictName":@"symdescription",
                      @"dictDesc":@"症状补充",
                      @"placeholder":@"请选择",
                      @"dictValue":convertToString(_symdescription),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"1",
                      @"dictName":@"hospitalGrade",
                      @"dictDesc":@"曾诊治医院级别",
                      @"placeholder":@"请选择",
                      @"dictValue":convertToString(_hospitalGrade),
                      @"dictType":convertIntToString(ZZEditControlTypeChoose),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"2",
                      @"dictName":@"useDrugs",
                      @"dictDesc":@"使用过药物",
                      @"placeholder":@"点击输入",
                      @"dictValue":convertToString(_useDrugs),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"3",
                      @"dictName":@"illness",
                      @"dictDesc":@"病情主述",
                      @"placeholder":@"希望得到哪些帮助和建议",
                      @"dictValue":convertToString(_illness),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [arr1 addObject:@{@"code":@"4",
                      @"dictName":@"remark",
                      @"dictDesc":@"备注",
                      @"placeholder":@"可将CT报告dicom格式的报告上传至百度云分享链接",
                      @"dictValue":convertToString(_remark),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"5",
                      @"dictName":@"addPic",
                      @"dictDesc":@"添加图片",
                      @"placeholder":@"",
                      @"dictValue":is_null(_picList)?@"":_picList,
                      @"dictType":convertIntToString(ZZEditControlTypeAddPic),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    return arr1;
}

-(NSMutableArray *)getSportExt{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    
    
    
    [arr1 addObject:@{@"code":@"1",
                      @"dictName":@"oxygen",
                      @"dictDesc":@"最大摄氧量",
                      @"placeholder":@"VO2max",
                      @"dictValue":convertToString(_oxygen),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"2",
                      @"dictName":@"heartRate",
                      @"dictDesc":@"无氧阀心率",
                      @"placeholder":@"HRat",
                      @"dictValue":convertToString(_heartRate),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    [arr1 addObject:@{@"code":@"3",
                      @"dictName":@"maxHeartRate",
                      @"dictDesc":@"最大实测极限心率",
                      @"placeholder":@"HRMax",
                      @"dictValue":convertToString(_maxHeartRate),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"2",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"4",
                      @"dictName":@"lungTime",
                      @"dictDesc":@"运动心肺检测时间",
                      @"placeholder":@"CPXtime",
                      @"dictValue":convertToString(_lungTime),
                      @"dictType":convertIntToString(ZZEditControlTypeTextField),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    
    [arr1 addObject:@{@"code":@"5",
                      @"dictName":@"remark",
                      @"dictDesc":@"备注",
                      @"placeholder":@"可将CT报告dicom格式的报告上传至百度云分享链接",
                      @"dictValue":convertToString(_remark),
                      @"dictType":convertIntToString(ZZEditControlTypeTextView),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    
    [arr1 addObject:@{@"code":@"6",
                      @"dictName":@"addPic",
                      @"dictDesc":@"添加图片",
                      @"placeholder":@"",
                      @"dictValue":is_null(_picList)?@"":_picList,
                      @"dictType":convertIntToString(ZZEditControlTypeAddPic),
                      @"valueType":@"1",
                      @"isOption":@"0",
                      }];
    return arr1;
}

@end

@implementation ZZSymptomExtPicModel

@end
