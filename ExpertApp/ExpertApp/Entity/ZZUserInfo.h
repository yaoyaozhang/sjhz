//
//  ZZUserInfo.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZUserInfo : ZZBaseModel

// 用户ID
@property(nonatomic,assign) int userId;
// 手机号
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *token;
// 用户名
@property(nonatomic,strong) NSString *userName;
// 密码
@property(nonatomic,strong) NSString *passWord;
// 第三方标志
@property(nonatomic,strong) NSString *thirdId;
// 是否援疆
@property(nonatomic,assign) int isYj;
// 教育背景
@property(nonatomic,strong) NSString *yjBackGround;
// 真实姓名
@property(nonatomic,strong) NSString *name;
// 证明人
@property(nonatomic,strong) NSString *witness;
// 创建时间
@property(nonatomic,strong) NSString *createDate;
// 免费次数
@property(nonatomic,assign) int tcNumber;
// 是否删除
@property(nonatomic,assign) int isDel;
// 是否是医生
@property(nonatomic,assign) int isDoctor;


// 0无关系，1from+to, 2 to+from,  3互相关注
@property(nonatomic,assign) int state;
@property(nonatomic,strong) NSString *context;


/**
 是否被选中
 */
@property(nonatomic,assign) BOOL isChecked;




@property(nonatomic,strong) NSString *docName;//": "李丹",
@property(nonatomic,strong) NSString *departmentName;//": "全部科室",
@property(nonatomic,strong) NSString *hospital;//": "海淀妇幼",
// 头像
@property(nonatomic,strong) NSString *imageUrl;//": "url:/upload/uhead/2017-09-06/demoUploadimage1001504693326.jpg",
@property(nonatomic,strong) NSString *location;//": "中部地区",
@property(nonatomic,strong) NSString *accomplished;//": "放假放假，皮肤病",
@property(nonatomic,strong) NSString *orderNumber;//": 0,
@property(nonatomic,strong) NSString *titleName;//": "高级职称,第二高级"


@property(nonatomic,strong) NSString *certificateUrl1;//": "高级职称,第二高级"


@property(nonatomic,assign) int     articleNum;//: 文章量
@property(nonatomic,assign) int     fansNum;//: 粉丝数



@end
