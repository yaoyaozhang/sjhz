//
//  ZZUserHomeModel.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

/**
 医生列表数据
 */
@interface ZZUserHomeModel : ZZBaseModel

@property(nonatomic,strong) NSString *createTime;//": 1501832166695,
@property(nonatomic,strong) NSString *titleNmae;//": "高级职称",
@property(nonatomic,strong) NSString *departmentName;//": "全部科室",
@property(nonatomic,strong) NSString *hospital;//": "全部科室",
@property(nonatomic,strong) NSString *docName;//": "李丹",
@property(nonatomic,strong) NSString *imageUrl;//": "url:/upload/uhead/2017-09-06/demoUploadimage1001504693326.jpg",

@property(nonatomic,assign) int     userId;//": "7",

// 擅长
@property(nonatomic,strong) NSString *accomplished;//": "7",


@property(nonatomic,strong) NSString *picture;//": "",
@property(nonatomic,strong) NSString *title;//": "中信收购麦当劳中国业务 估值160亿港元",
@property(nonatomic,assign) int     chickLikeNum;//": 0,
@property(nonatomic,assign) int     chickedNum;//": 79,
@property(nonatomic,assign) int     nid;//: 1
@property(nonatomic,assign) int     articleNum;//: 文章量
@property(nonatomic,assign) int     fansNum;//: 粉丝数


@property(nonatomic,assign) BOOL isChecked;


@end
