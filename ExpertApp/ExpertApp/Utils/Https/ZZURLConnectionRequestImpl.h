//
//  ZZURLConnectionRequestImpl.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZZHttpConstants.h"

@interface ZZURLConnectionRequestImpl : NSObject

+(ZZURLConnectionRequestImpl *)getZCNSURLConnection;

/**
 *  异步Get请求
 */
+(void)get:(NSString *) stringURL
     start:(StartBlock) startBlock
    finish:(FinishBlock) finishBlock
  complete:(CompleteBlock) completeBlock
      fail:(FailBlock) failBlock;

/**
 *  异步post请求
 */
-(void)post:(NSString *) stringURL
           param:(NSDictionary *) dict
         timeOut:(CGFloat) timeOut
           start:(StartBlock) startBlock
          finish:(FinishBlock) finishBlock
        complete:(CompleteBlock) completeBlock
            fail:(FailBlock) failBlock
        progress:(ProgressBlock) progressBlock;

@end
