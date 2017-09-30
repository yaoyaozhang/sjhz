//
//  ZZNSSessionRequestImpl.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZHttpConstants.h"

@interface ZZNSSessionRequestImpl : NSObject

+(ZZNSSessionRequestImpl *)getZCNSURLSession;

/**
 *  异步Get请求
 *
 *  @param stringURL
 *  @param startBlock
 *  @param finishBlock
 *  @param completeBlock
 *  @param failBlock
 *  @param progressBlock 可以为nil
 */
+(void)get:(NSString *) stringURL
     start:(StartBlock) startBlock
    finish:(FinishBlock) finishBlock
  complete:(CompleteBlock) completeBlock
      fail:(FailBlock) failBlock
  progress:(ProgressBlock) progressBlock;

/**
 *  异步post请求
 *
 *  @param stringURL
 *  @param dict post参数，暂未处理文件
 *  @param startBlock
 *  @param finishBlock
 *  @param completeBlock
 *  @param failBlock
 *  @param progressBlock 可以为nil
 */
-(void)startPost:(NSString *) stringURL
           param:(NSDictionary *) dict
         timeOut:(CGFloat) timeout
           start:(StartBlock) startBlock
          finish:(FinishBlock) finishBlock
        complete:(CompleteBlock) completeBlock
            fail:(FailBlock) failBlock
        progress:(ProgressBlock) progressBlock;


@end
