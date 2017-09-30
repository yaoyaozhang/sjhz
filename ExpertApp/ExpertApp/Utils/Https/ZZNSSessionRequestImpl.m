//
//  ZZNSSessionRequestImpl.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZNSSessionRequestImpl.h"

@interface ZZNSSessionRequestImpl()<NSURLSessionDelegate>{
    
}
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, assign) CGFloat receivedSize;
@property (nonatomic, assign) CGFloat totalSize;
@property (nonatomic, strong)ProgressBlock progressBlock;
@property (nonatomic, strong)FinishBlock finishBlock;
@property (nonatomic, strong)CompleteBlock completeBlock;
@property (nonatomic, strong)FailBlock failBlock;

@end


@implementation ZZNSSessionRequestImpl

+(ZZNSSessionRequestImpl *)getZCNSURLSession{
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
        _receivedData = nil;
    }
    return self;
}


+(void)get:(NSString *)stringURL start:(StartBlock)startBlock finish:(FinishBlock)finishBlock complete:(CompleteBlock)completeBlock fail:(FailBlock)failBlock progress:(ProgressBlock)progressBlock{
    //第一步，创建url
    NSString *escapedPath = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];
    //    [ZCLogUtils logHeader:LogHeader debug:@"%@",escapedPath];
    //第二步，创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:HttpGetTimeOut];
    
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                @try {
                                                    if(error){
                                                        failBlock(response,HttpNetWorkError,error);
                                                    }else{
                                                        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                        NSString *code=[dict objectForKey:@"code"];
                                                        if(code!=nil && [code intValue]==1){
                                                            completeBlock(dict);
                                                        }else{
                                                            NSString *desc=[dict objectForKey:@"desc"];
                                                            if(desc==nil || [@"" isEqual:desc]){
                                                                desc=HttpNetWorkError;
                                                            }
                                                            failBlock(response,desc,nil);
                                                        }
                                                    }
                                                }
                                                @catch (NSException *exception) {
                                                    failBlock(response,exception.reason,nil);
                                                }
                                                @finally {
                                                    finishBlock(response,data);
                                                }
                                                
                                            });
                                        }];
    
    // 启动任务
    [task resume];
    //开始请求
    if(startBlock){
        startBlock();
    }
}

-(void)startPost:(NSString *)stringURL param:(NSDictionary *)dict timeOut:(CGFloat)timeout start:(StartBlock)startBlock finish:(FinishBlock)finishBlock complete:(CompleteBlock)completeBlock fail:(FailBlock)failBlock progress:(ProgressBlock)progressBlock{
    _finishBlock = finishBlock;
    _progressBlock = progressBlock;
    _failBlock = failBlock;
    _completeBlock = completeBlock;
    
    if(_receivedData==nil){
        _receivedData = [[NSMutableData alloc] init];
    }else{
        //清空数据
        [_receivedData resetBytesInRange:NSMakeRange(0, _receivedData.length)];
        [_receivedData setLength:0];
    }
    
    //第一步，创建url
    NSString *escapedPath = [stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];
    //    [ZCLogUtils logHeader:LogHeader debug:@"%@",escapedPath];
    
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeout];
    [request setValue:HttpUserAgent forHTTPHeaderField:@"User-Agent"];
    
    
    [dict setValue:@"iOS" forKey:@"from"];
    [dict setValue:@"1.0" forKey:@"version"];
    
    
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
    // 请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    
    
    
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[self getSessionConfig:timeout] delegate:self delegateQueue:queue];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    
    if(startBlock){
        startBlock();
    }
}

-(NSURLSessionConfiguration *)getSessionConfig:(CGFloat )timeout{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 超时时间
    config.timeoutIntervalForRequest = timeout;
    // 请求资源时间
    config.timeoutIntervalForResource = timeout;
    // 是否允许使用蜂窝网络(后台传输不适用)
    config.allowsCellularAccess = YES;
    // 还有很多可以设置的属性
    config.HTTPMaximumConnectionsPerHost = 3; //限制每次最多连接数；在 iOS 中默认值为4
    //    config.discretionary = YES; //是否自动选择最佳网络访问，仅对「后台会话」有效
    config.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                     @"Accept-Language": @"en",
                                     @"User-Agent": HttpUserAgent};
    return config;
}

#pragma mark - delegate
// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
    
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse*)response;
    //获取文件文件的大小
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields=[httpResponse allHeaderFields];
        //        __weak typeof(self) weakSelf =self;
        //        dispatch_async(dispatch_get_main_queue(), ^{
        _totalSize=[[httpResponseHeaderFields objectForKey:@"Content-Length"]longLongValue];
        //        });
    }
}

// 上传进度的比例计算
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    [ZCLogUtils logHeader:LogHeader info:@"上传 Progress%zd %zd",totalBytesSent,totalBytesExpectedToSend];
    
    //    __weak typeof(self) weakSelf =self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if(_progressBlock){
        // 计算进度值
        CGFloat progress = (CGFloat)totalBytesSent / totalBytesExpectedToSend;
        if(progress >= 0.99){
            progress = 0.99;
        }
        _progressBlock(progress);
    }
    //    });
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
    [ZCLogUtils logHeader:LogHeader info:@"下载 Progress %zd\n%@",data.length,[NSThread currentThread]];
    
    //    __weak typeof(self) weakSelf =self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    _receivedSize = _receivedSize + data.length;
    [_receivedData appendData:data];
    if(_progressBlock){
        // 计算进度值
        CGFloat progress = (CGFloat)_receivedSize / _totalSize;
        if(progress >= 0.99){
            progress = 0.99;
        }
        _progressBlock(progress);
    }
    //    });
}


// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [ZCLogUtils logHeader:LogHeader info:@"完成操作了====%@",[NSThread currentThread]];
    //判断后，在界面提示登录信息
    // 请求完成,成功或者失败的处理
    
    //    __weak typeof(self) weakSelf =self;
    //    dispatch_async(dispatch_get_main_queue(), ^{
    if(error||_receivedData.length==0){
        if(_failBlock){
            _failBlock(nil,HttpNetWorkError,error);
        }
        if(_finishBlock){
            _finishBlock(nil,_receivedData);
        }
    }else{
        
        @try {
            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableLeaves error:nil];
            
            //                [ZCLogUtils logHeader:LogHeader info:@"数据：%@",dict];
            NSString *code=[dict objectForKey:@"code"];
            if(code!=nil && [code intValue]==1 && _completeBlock){
                _completeBlock(dict);
            }else{
                NSString *desc=[dict objectForKey:@"desc"];
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
    }
    //    });
}



@end
