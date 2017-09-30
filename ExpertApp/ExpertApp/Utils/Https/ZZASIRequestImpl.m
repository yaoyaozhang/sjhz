//
//  ZZASIRequestImpl.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZASIRequestImpl.h"
#import <ASIHTTPRequest.h>
#import <ASIFormDataRequest.h>

@implementation ZZASIRequestImpl


+(void)get:(NSString *) stringURL
     start:(StartBlock) startBlock
    finish:(FinishBlock) finishBlock
  complete:(CompleteBlock) completeBlock
      fail:(FailBlock) failBlock
  progress:(ProgressBlock) progressBlock {
    NSString *userAgent=[NSString stringWithFormat:@"ios(%@,%f,%f)",@"com.sjhz.mobile.app",ScreenWidth,ScreenHeight];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(stringURL!=nil){
        if([stringURL rangeOfString:@"?"].length>0){
            stringURL=[NSString stringWithFormat:@"%@&from=3&version=%@",stringURL,version];
        }else{
            stringURL=[NSString stringWithFormat:@"%@?from=3&version=%@",stringURL,version];
        }
    }
    
    [ZCLogUtils logHeader:LogHeader debug:@"%@",stringURL];
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]];
    __block ASIHTTPRequest *brRequest = request;
    //    [request addRequestHeader:@"FROM" value:@"mobile"];
    [request setTimeOutSeconds:HttpGetTimeOut];
    [request setUserAgentString:userAgent];
    //（不支持长连接）
    // 防止重复提交
    request.shouldAttemptPersistentConnection = NO;
    
    
    [request setCompletionBlock:^{
        if([brRequest didUseCachedResponse])
        {
            //使用http缓存
        }
        
        @try {
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:brRequest.responseData options:NSJSONReadingMutableLeaves error:nil];
            NSString *code=[dict objectForKey:@"retCode"];
            if(code!=nil && [code intValue]==1){
                completeBlock(dict);
            }else{
                NSString *desc=[dict objectForKey:@"retMsg"];
                if(desc==nil || [@"" isEqual:desc]){
                    desc=HttpNetWorkError;
                }
                failBlock(brRequest,desc,nil);
            }
        }
        @catch (NSException *exception) {
            failBlock(brRequest,exception.reason,nil);
        }
        @finally {
            finishBlock(brRequest,brRequest.responseData);
        }
    }];
    
    [request setFailedBlock:^{
        if(brRequest.responseStatusCode==408){
            failBlock(brRequest,HttpNetWorkTimeOut,brRequest.error);
        }else{
            failBlock(brRequest,HttpNetWorkError,brRequest.error);
        }
        
        finishBlock(brRequest,brRequest.responseData);
    }];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        if(progressBlock){
            CGFloat p=size*1.0f/total;
            progressBlock(p);
        }
    }];
    
    [request startAsynchronous];
    
    
    //开始请求
    if(startBlock){
        startBlock();
    }
}

+(void)post:(NSString *) stringURL
      param:(NSDictionary *) dict
    timeOut:(CGFloat)timeout
      start:(StartBlock) startBlock
     finish:(FinishBlock) finishBlock
   complete:(CompleteBlock) completeBlock
       fail:(FailBlock) failBlock
   progress:(ProgressBlock)progressBlock{
    
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    
    ASIFormDataRequest *postRequest=[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:stringURL]];
    
    __block ASIFormDataRequest *brRequest = postRequest;
    //    [postRequest addRequestHeader:@"FROM" value:@"mobile"];
    [postRequest setTimeOutSeconds:timeout];
    [postRequest setUserAgentString:HttpUserAgent];
    [postRequest setShowAccurateProgress:YES];
    
    //（不支持长连接）
    // 防止重复提交
    postRequest.shouldAttemptPersistentConnection = NO;
    
    for (NSString *key in dict.allKeys) {
        NSString *value=dict[key];
        
        // 判断是否为文件
        if(checkFileIsExsis(value) && value.length>2){
            [postRequest addFile:value forKey:key];
        }else{
            [postRequest addPostValue:[dict objectForKey:key] forKey:key];
        }
    }
    [postRequest addPostValue:@"3" forKey:@"from"];
    [postRequest addPostValue:@"1.0" forKey:@"version"];
    
    [postRequest setCompletionBlock:^{
        if([brRequest didUseCachedResponse])
        {
            //使用http缓存
            [ZCLogUtils logHeader:LogHeader debug:@"使用缓存了啊"];
        }
        
        //        [ZCLogUtils logHeader:LogHeader debug:@"%@",[[NSString alloc] initWithData:brRequest.responseData encoding:NSUTF8StringEncoding]];
        @try {
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:brRequest.responseData options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *code=[dict objectForKey:@"retCode"];
            if(code!=nil && [code intValue]==1){
                completeBlock(dict);
            }else{
                NSString *desc=[dict objectForKey:@"retMsg"];
                if(desc==nil || [@"" isEqual:desc]){
                    desc=HttpNetWorkError;
                }
                failBlock(brRequest,desc,nil);
            }
        }
        @catch (NSException *exception) {
            failBlock(brRequest,HttpNetWorkError,nil);
        }
        @finally {
            finishBlock(brRequest,brRequest.responseData);
        }
    }];
    [postRequest setFailedBlock:^{
        if(brRequest.responseStatusCode==408){
            failBlock(brRequest,HttpNetWorkTimeOut,brRequest.error);
        }else{
            failBlock(brRequest,HttpNetWorkError,brRequest.error);
        }
        
        finishBlock(brRequest,brRequest.responseData);
    }];
    
    
    [postRequest setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        if(progressBlock){
            CGFloat p=size*1.0f/total;
            progressBlock(p);
        }
    }];
    [postRequest setUploadSizeIncrementedBlock:^(long long size) {
        [ZCLogUtils logHeader:LogHeader debug:@"%lld---%lld",size,brRequest.contentLength];
    }];
    
    [postRequest startAsynchronous];
    
    //开始请求
    if(startBlock){
        startBlock();
    }
}

@end
