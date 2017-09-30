//
//  ZZRequsetInterface.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZHttpConstants.h"
#import "ZZHttpInterface.h"

@interface ZZRequsetInterface : NSObject


/**
 *  异步Get请求
 *
 *  @param stringURL URL
 *  @param startBlock 开始
 *  @param finishBlock 完成(失败或成功都会执行)
 *  @param completeBlock 成功
 *  @param failBlock 失败
 *  @param progressBlock 上传或下载进度(不总是调用)
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
 *  @param stringURL url
 *  @param dict post参数，暂未处理文件
 *  @param timeOut 超时时长
 *  @param startBlock   开始
 *  @param finishBlock  完成
 *  @param completeBlock    成功
 *  @param failBlock 失败
 */
+(void)post:(NSString *) stringURL
      param:(NSMutableDictionary *) dict
    timeOut:(CGFloat) timeOut
      start:(StartBlock) startBlock
     finish:(FinishBlock) finishBlock
   complete:(CompleteBlock) completeBlock
       fail:(FailBlock) failBlock
   progress:(ProgressBlock) progressBlock;

@end
