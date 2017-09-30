//
//  ZZURLConnectionRequestImpl.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZURLConnectionRequestImpl.h"

@interface ZZURLConnectionRequestImpl()<NSURLConnectionDataDelegate>{
    ProgressBlock _progressBlock;
    FinishBlock _finishBlock;
    CompleteBlock _completeBlock;
    FailBlock _failBlock;
    CGFloat _receivedSize;
    CGFloat _totalSize;
}
@property (nonatomic, strong) NSMutableData *receivedData;
@end


@implementation ZZURLConnectionRequestImpl

+(ZZURLConnectionRequestImpl *)getZCNSURLConnection{
    return [[self alloc] init];
}

-(id)init{
    self=[super init];
    if(self){
        _progressBlock = nil;
        _finishBlock = nil;
        _completeBlock = nil;
        _failBlock = nil;
        _receivedSize = 0;
        _totalSize    = 0;
        _receivedData = [NSMutableData data];
    }
    return self;
}


+(void)get:(NSString *) stringURL
     start:(StartBlock) startBlock
    finish:(FinishBlock) finishBlock
  complete:(CompleteBlock) completeBlock
      fail:(FailBlock) failBlock {
    //第一步，创建url
    NSString *escapedPath = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];
//        [ZCLogUtils logHeader:LogHeader debug:@"%@",escapedPath];
    NSLog(@"%@",escapedPath);
    //第二步，创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:HttpGetTimeOut];
    [request setValue:HttpUserAgent forHTTPHeaderField:@"User-Agent"];
    
    //第三步，连接服务器
    //获取一个主队列
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //判断后，在界面提示登录信息
        @try {
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *code=[dict objectForKey:@"retCode"];
            if(code!=nil && [code intValue]==0){
                completeBlock(dict);
            }else{
                NSString *desc=[dict objectForKey:@"retMsg"];
                if(desc==nil || [@"" isEqual:desc]){
                    desc=HttpNetWorkError;
                }
                failBlock(response,desc,nil);
            }
        }
        @catch (NSException *exception) {
            failBlock(response,exception.reason,nil);
        }
        @finally {
            finishBlock(response,data);
        }
        
    }];
    
    //开始请求
    if(startBlock){
        startBlock();
    }
}

-(void)post:(NSString *) stringURL
      param:(NSDictionary *) dict
    timeOut:(CGFloat) timeOut
      start:(StartBlock) startBlock
     finish:(FinishBlock) finishBlock
   complete:(CompleteBlock) completeBlock
       fail:(FailBlock) failBlock
   progress:(ProgressBlock) progressBlock{
    
    _finishBlock = finishBlock;
    _progressBlock = progressBlock;
    _failBlock = failBlock;
    _completeBlock = completeBlock;
    
    
    //第一步，创建url
    NSString *escapedPath = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];
        [ZCLogUtils logHeader:LogHeader debug:@"%@",escapedPath];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
    
    
    [dict setValue:@"1" forKey:@"from"];
    [dict setValue:@"1.0" forKey:@"version"];
    NSLog(@"%@\n%@",url,dict);
    
    // 设置请求体
    NSMutableData *body = [NSMutableData data];
    /***************文件参数***************/
    //设置post参数
    for (NSString *key in dict.allKeys) {
        NSString *value=dict[key];
        
        // 参数开始的标志
        [body appendData:UTF8Data(@"--YY\r\n")];
        // 判断是否为文件
        if(checkFileIsExsis(value)){
            // name : 指定参数名(必须跟服务器端保持一致)
            // filename : 文件名
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:value]];
            NSURLResponse *repsonse = nil;
            NSData *fileData=[NSURLConnection sendSynchronousRequest:request returningResponse:&repsonse error:nil];
            
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, [value lastPathComponent]];
            [body appendData:UTF8Data(disposition)];
            NSString *type = [NSString stringWithFormat:@"Content-Type:%@\r\n", repsonse.MIMEType];
            [body appendData:UTF8Data(type)];
            
            [body appendData:UTF8Data(@"\r\n")];
            [body appendData:fileData];
            [body appendData:UTF8Data(@"\r\n")];
        }else{
            NSString *disposition = [NSString stringWithFormat:@"Content-Disposition:form-data; name=\"%@\"\r\n", key];
            [body appendData:UTF8Data(disposition)];
            [body appendData:UTF8Data(@"\r\n")];
            [body appendData:UTF8Data(value)];
            [body appendData:UTF8Data(@"\r\n")];
        }
        
        // 文件处理参考
        // http://blog.csdn.net/codywangziham01/article/details/38044637
    }
    
    [body appendData:UTF8Data(@"--YY--\r\n")];
    
    //    [ZCLogUtils logHeader:LogHeader debug:@"拼接参数：%@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]];
    //设置HTTPHeader中Content-Type的值
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    // [request setValue:@"application/json;charset=UTF-8; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:HttpUserAgent forHTTPHeaderField:@"User-Agent"];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    [[NSURLConnection connectionWithRequest:request delegate:self] start];
    //开始请求
    if(startBlock){
        startBlock();
    }
    
}


#pragma mark 网络请求代理
//该方法在响应connection时调用
-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [ZCLogUtils logHeader:LogHeader info:@"response"];
    //    self.data=[[NSMutableData alloc]init];
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse*)response;
    
    //获取文件文件的大小
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields=[httpResponse allHeaderFields];
        _totalSize=[[httpResponseHeaderFields objectForKey:@"Content-Length"]longLongValue];
    }
    
}

//出错时调用
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [ZCLogUtils logHeader:LogHeader info:@"error"];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if(_failBlock){
        _failBlock(connection,HttpNetWorkError,error);
    }
    if(_finishBlock){
        _finishBlock(connection,_receivedData);
    }
    //    });
}

//接受数据，在接受完成之前，该方法重复调用
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [ZCLogUtils logHeader:LogHeader info:@"下载 Progress %zd",data.length];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [_receivedData appendData:data];
    _receivedSize = _receivedSize + data.length;
    if(_progressBlock){
        // 计算进度值
        CGFloat progress = (CGFloat)_receivedSize / _totalSize;
        
        _progressBlock(progress);
    }
    //    });
}

// 上传进度
- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    [ZCLogUtils logHeader:LogHeader info:@"上传 Progress%zd %zd",totalBytesWritten,totalBytesExpectedToWrite];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if(_progressBlock){
        // 计算进度值
        CGFloat progress = (CGFloat)totalBytesWritten / totalBytesExpectedToWrite;
        
        _progressBlock(progress);
    }
    //    });
}

//完成时调用
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [ZCLogUtils logHeader:LogHeader info:@"Finish %@",[NSThread currentThread]];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //判断后，在界面提示登录信息
    
    @try {
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableLeaves error:nil];
        NSString *code=[dict objectForKey:@"retCode"];
        if(code!=nil && [code intValue]==0 && _completeBlock){
            _completeBlock(dict);
        }else{
            NSString *desc=[dict objectForKey:@"retMsg"];
            if(desc==nil || [@"" isEqual:desc]){
                desc=HttpNetWorkError;
            }
            if(_failBlock){
                _failBlock(nil,desc,nil);
            }
        }
    }
    @catch (NSException *exception) {
        if(_failBlock){
            _failBlock(nil,exception.reason,nil);
        }
    }
    @finally {
        if(_finishBlock){
            _finishBlock(nil,_receivedData);
        }
    }
    //    });
}

@end
