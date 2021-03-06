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
// 医生标签
@property(nonatomic,strong) NSString *dclabel;

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

// 用户个人积分
@property(nonatomic,assign) int score;

// 我的邀请码
@property(nonatomic,strong) NSString *invtCode;





// 0无关系，1 fromUserId=自己?已关注:对方关注我 2 互相关注
@property(nonatomic,assign) int state;
// 当state=1时，发起关注方
@property(nonatomic,assign) int fromUserid;
@property(nonatomic,assign) int toUserId;

@property(nonatomic,strong) NSString *context;
@property(nonatomic,strong) NSString *lableName;
@property(nonatomic,strong) NSString *userRemark;


/**
 是否被选中
 */
@property(nonatomic,assign) BOOL isChecked;




@property(nonatomic,strong) NSString *docName;//": "李丹",
@property(nonatomic,strong) NSString *departmentName;//": "全部专业",
@property(nonatomic,strong) NSString *hospital;//": "海淀妇幼",
// 头像
@property(nonatomic,strong) NSString *imageUrl;//": "url:/upload/uhead/2017-09-06/demoUploadimage1001504693326.jpg",
@property(nonatomic,strong) NSString *location;//": "中部地区",
@property(nonatomic,strong) NSString *accomplished;//": "放假放假，皮肤病",
@property(nonatomic,strong) NSString *titleName;//": "高级职称,第二高级"
@property(nonatomic,assign) int       titleId;//": "高级职称,第二高级"

// 背景
@property(nonatomic,strong) NSString *medicalBackground;
// 擅长
@property(nonatomic,strong) NSString *academicResearch;
// 寄语
@property(nonatomic,strong) NSString *doctorWrote;




@property(nonatomic,strong) NSString *certificateUrl1;//": "高级职称,第二高级"


@property(nonatomic,assign) int     orderNumber;//": 问诊量
@property(nonatomic,assign) int     articleNum;//: 文章量
@property(nonatomic,assign) int     fansNumber;//: 粉丝数

// 自定义名称
@property(nonatomic,strong) NSString *signName;
// 封面
@property(nonatomic,strong) NSString *signUrl;


// 加好友时的，留言数据
@property(nonatomic,strong) NSMutableArray *tempLeaves;



@end
