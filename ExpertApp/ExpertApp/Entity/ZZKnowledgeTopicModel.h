//
//  ZZKnowledgeTopicModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/5/3.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"
#import "ZZChapterModel.h"

@interface ZZKnowledgeTopicModel : ZZBaseModel

@property(nonatomic,strong) NSString *className;
@property(nonatomic,strong) NSString *classUrl;
@property(nonatomic,assign) int sid;
@property(nonatomic,assign) int classNumber;
@property(nonatomic,assign) int classPrice;
@property(nonatomic,strong) NSString *startTime;
@property(nonatomic,strong) NSString *endTime;
@property(nonatomic,assign) int isFree;
@property(nonatomic,assign) int states;
@property(nonatomic,assign) int docId;
@property(nonatomic,assign) float score;



// 适用人群
@property(nonatomic,strong) NSString *adaptUser;
// 课程说明
@property(nonatomic,strong) NSString *introduce;
// 简介
@property(nonatomic,strong) NSString *synopsis;



@property(nonatomic,strong) NSMutableArray *wenzhang;

@end
