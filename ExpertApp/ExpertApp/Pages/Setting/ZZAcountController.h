//
//  ZZAcountController.h
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZZAcountContentType) {
    ZZAcountDoctor       = 1, // 会诊
    ZZAcountDoctorVideo  = 2, // 精品课
};

@interface ZZAcountController : BaseController

@property(nonatomic,assign)ZZAcountContentType type;


// 医生或课程id
@property(nonatomic,assign)NSString *otherId;

// 医生或课程对象，用于跳转启动页面
@property(nonatomic,strong) id objModel;

//{"can":0,"sorce":200,"xfei":200}
// can = 0积分不够，1已支付，2积分足够
@property(nonatomic,strong)NSDictionary *item;


@end

NS_ASSUME_NONNULL_END
