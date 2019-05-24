//
//  ZZKnowledgeCellDelegate.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/24.
//  Copyright © 2018年 sjhz. All rights reserved.
//
@protocol ZZKnowledgeItemsCellDelegate<NSObject>

// type 1 播放, 2查看更多 ,3 详情 ,4 更多功能
-(void)onItemClick:(id) model type:(int ) type obj:(NSMutableArray *) arr;

@end
