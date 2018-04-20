//
//  ZZTJListModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/19.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"
#import "ZZChapterModel.h"

@interface ZZTJListModel : ZZBaseModel

@property(nonatomic,strong) NSString *className;
@property(nonatomic,assign) int sid;
@property(nonatomic,strong) NSMutableArray *wenzhang;

@end
