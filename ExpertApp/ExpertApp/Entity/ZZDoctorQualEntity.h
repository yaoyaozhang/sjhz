//
//  ZZDoctorQualEntity.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/30.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface ZZDoctorQualEntity : ZZBaseModel

// 医生ID
@property(nonatomic,strong) NSString *docId;
// 用户基本信息Id
@property(nonatomic,strong) NSString *userId;
// 医生姓名
@property(nonatomic,strong) NSString *docName;
// 科室Id
@property(nonatomic,strong) NSString *departmentId;
// 科室
@property(nonatomic,strong) NSString *departmentName;
// 医院
@property(nonatomic,strong) NSString *hospital;
// 职称Id
@property(nonatomic,strong) NSString *titleId;
// 职称名字
@property(nonatomic,strong) NSString *titleName;
// 擅长
@property(nonatomic,strong) NSString *accomplished;
// 证书
@property(nonatomic,strong) NSString *certificateUrl1;
// 证书
@property(nonatomic,strong) NSString *certificateUrl2;
// 证书
@property(nonatomic,strong) NSString *certificateUrl3;
// 医生头像
@property(nonatomic,strong) NSString *imageUrl;
// 所在地区
@property(nonatomic,strong) NSString *location;
// 标签
@property(nonatomic,strong) NSString *dcLabel;
// 审核状态
@property(nonatomic,strong) NSString *auditState;

@end
