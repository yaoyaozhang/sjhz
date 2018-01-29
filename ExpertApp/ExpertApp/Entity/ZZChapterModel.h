//
//  ZZChapterModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZChapterModel : ZZBaseModel

// ID
@property(nonatomic,assign) int nid;
// 标题
@property(nonatomic,strong) NSString *title;
// 内容
@property(nonatomic,strong) NSString *content;
// 作者
@property(nonatomic,strong) NSString *author;
// 关键字
@property(nonatomic,strong) NSString *keyWords;
// 点击次数
@property(nonatomic,assign) int chickNum;
// 点赞次数
@property(nonatomic,assign) int chickLikeNum;
// 图片
@property(nonatomic,strong) NSString *picture;
// 创建时间
@property(nonatomic,strong) NSString *createTime;
// 创建人
@property(nonatomic,assign) int authorId;
// 修改时间
@property(nonatomic,strong) NSString *updateTime;
// 修改人
@property(nonatomic,strong) NSString *updateUser;


// 类别，0不显示，1语音，2视频，
@property(nonatomic,assign) int showVideo;


@property(nonatomic,assign) int commentNum;




/**
 是否收藏
 */
@property(nonatomic,assign) BOOL collect;

// 类别
@property(nonatomic,assign) int newsType;


@property(nonatomic,strong) NSMutableArray *pics;


@end
