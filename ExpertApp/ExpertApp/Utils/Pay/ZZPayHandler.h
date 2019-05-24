//
//  ZZPayHandler.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ZZPayType) {
    ZZPayTypeZFB = 1,
    ZZPayTypeWX  = 2,
};

@interface ZZPayHandler : NSObject



/**
 支付
 
 @param userId 用户ID
 @param payType 1支付宝，2微信
 @param type 1，文章，2 会诊，3打赏,4购买积分
 @param otherId 关联的ID
 @param price 支付价格
 @param desc 付款描述
 @param resultBlock 支付结果
 @return
 */
+(void) startJumppay:(int ) userId payType:(ZZPayType) payType type:(int) type otherId:(NSString *)otherId desc:(NSString *) desc prict:(CGFloat) price result:(void(^)(int code,NSString *msg)) payResult;

@end
