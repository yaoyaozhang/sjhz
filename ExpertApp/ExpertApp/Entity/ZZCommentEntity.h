//
//  ZZCommentEntity.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZCommentEntity : ZZBaseModel

// 评论ID
@property(nonatomic,assign) int cid;
// 新闻ID
@property(nonatomic,assign) int nid;
// 评论人ID
@property(nonatomic,assign) int uid;
// 评论内容
@property(nonatomic,strong) NSString *content;
// 类型[1、新闻评论,2、关注,3、收藏,4、点赞]
@property(nonatomic,assign) int commentType;
// 备注
@property(nonatomic,strong) NSString *remark;
// 附加字段1
@property(nonatomic,strong) NSString *additional1;
// 附加字段2
@property(nonatomic,strong) NSString *additional2;
// 创建时间
@property(nonatomic,strong) NSString *createTime;

@end
