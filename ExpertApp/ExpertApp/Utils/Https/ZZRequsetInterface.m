//
//  ZZRequsetInterface.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//
#import "ZZRequsetInterface.h"
#import "ZZASIRequestImpl.h"
#import "ZZNSSessionRequestImpl.h"
#import "ZZURLConnectionRequestImpl.h"
#import "ZCLocalStore.h"

@implementation ZZRequsetInterface



+(void)get:(NSString *) stringURL
     start:(StartBlock) startBlock
    finish:(FinishBlock) finishBlock
  complete:(CompleteBlock) completeBlock
      fail:(FailBlock) failBlock {
    [self get:stringURL start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:nil];
}

+(void)get:(NSString *)stringURL start:(StartBlock)startBlock finish:(FinishBlock)finishBlock complete:(CompleteBlock)completeBlock fail:(FailBlock)failBlock progress:(ProgressBlock)progressBlock{
    if(HttpRequestType == 1){
        [ZZASIRequestImpl get:stringURL start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:progressBlock];
    }else if(HttpRequestType == 2 ){
        [ZZURLConnectionRequestImpl get:stringURL start:startBlock finish:finishBlock complete:completeBlock fail:failBlock];
    }else if(HttpRequestType == 3 ){
        [ZZNSSessionRequestImpl get:stringURL start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:nil];
    }
}



+(void)post:(NSString *)stringURL
      param:(NSMutableDictionary *)params
    timeOut:(CGFloat) timeOut
      start:(StartBlock)startBlock
     finish:(FinishBlock)finishBlock
   complete:(CompleteBlock)completeBlock
       fail:(FailBlock)failBlock
   progress:(ProgressBlock)progressBlock{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if([stringURL hasPrefix:API_UploadFile]){
        dict = params;
    }else{
        [dict setObject:[ZCLocalStore DataTOjsonString:params] forKey:@"jsonValue"];
    }
    
    if(timeOut<=0){
        timeOut = HttpPostTimeOut;
    }
    if(HttpRequestType==1){
        [ZZASIRequestImpl post:stringURL param:dict timeOut:timeOut start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:progressBlock];
    }else if(HttpRequestType == 2 ){
        
        [[ZZURLConnectionRequestImpl getZCNSURLConnection] post:stringURL param:dict timeOut:timeOut start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:progressBlock];
    }else if(HttpRequestType == 3 ){
        [[ZZNSSessionRequestImpl getZCNSURLSession] startPost:stringURL param:dict timeOut:timeOut start:startBlock finish:finishBlock complete:completeBlock fail:failBlock progress:progressBlock];
    }
}

@end
