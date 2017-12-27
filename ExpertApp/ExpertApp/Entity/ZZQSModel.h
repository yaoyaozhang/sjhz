//
//  ZZQSModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZQSModel : ZZBaseModel

@property(nonatomic,strong) NSMutableArray *quesAnswer;

@property(nonatomic,assign) int quesId;

@property(nonatomic,strong) NSString *quesNum;

// 1、单选，2多选，3数字
@property(nonatomic,assign) int       quesType;
@property(nonatomic,strong) NSString *quesWt;

@property(nonatomic,strong) NSDictionary *values;

@property(nonatomic,strong) NSString *answerId;
@property(nonatomic,strong) NSString *answerValue;

@end





@interface ZZQSAnswerModel : ZZBaseModel


@property(nonatomic,assign) int aid;
@property(nonatomic,strong) NSString *context;
@property(nonatomic,strong) NSString *tag;

@property(nonatomic,assign) int wentiId;

@property(nonatomic,assign) BOOL isSelected;



@end



@interface ZZQSListModel : ZZBaseModel


@property(nonatomic,assign) int wenjuanId;
@property(nonatomic,strong) NSString *quesName;
@property(nonatomic,strong) NSString *createTime;


@end
