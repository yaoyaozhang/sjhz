//
//  ZCLogUtils.m
//  XcodeUtils
//
//  Created by zhangxy on 16/3/9.
//  Copyright © 2016年 zhangxy. All rights reserved.
//

#import "ZCLogUtils.h"
#import "ZCLocalStore.h"

// 缓存路径
#define FILE_PATH      @"/Documents/Log/"

// 缓存时长
#define Log_Cache_Days 7

@implementation ZCLogUtils


+(void)log:(NSString *) log cache:(BOOL) isCache show:(BOOL) isShow{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:ZCKey_ISDEBUG] boolValue]){
        return;
    }
    
    if(Log_WS_Flag && isShow){
        printf("%s", [log UTF8String]);

    }
    if(isCache){
        [self cacheLog:@"日志信息" content:log logType:0];
    }
}



+(void)logText:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    [self log:outStr cache:NO show:YES];
}

+(void)logHeader:(NSString *)header info:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    NSString *text = [NSString stringWithFormat:@"%@\nInfo:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_InfoFlag) show:Log_WS_Info_Flag];
}

+(void)logHeader:(NSString *) header debug:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3){
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    NSString *text = [NSString stringWithFormat:@"%@\nDebug:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_DebugFlag) show:Log_WS_Debug_Flag];
}

+(void)logHeader:(NSString *)header error:(NSString *)format, ...{
    
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    NSString *text = [NSString stringWithFormat:@"%@\nError:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_ErrorFlag) show:Log_WS_Error_Flag];
}

+(void)logHeader:(NSString *)header warning:(NSString *)format, ...{
    if(!format){
        return;
    }
    va_list arglist;
    va_start(arglist, format);
    NSString *outStr = [[NSString alloc] initWithFormat:format arguments:arglist];
    va_end(arglist);
    
    
    NSString *text = [NSString stringWithFormat:@"%@\nWarning:\n%@",header,outStr];
    [self log:text cache:(Log_Cache_Flag && Log_Cache_WarningFlag) show:Log_WS_Warning_Flag];
}

////////////////////////////////////////////////////////////


+(void)cacheLog:(NSString *)message{
    [self cacheLog:@"输出日志信息" content:message  logType:0];
}

+(void)cacheLog:(NSString *)title content:(NSString *)message logType:(ZCLogType)logType{
    
    NSString *logPath = @"";
    if(logType == 0){
        logPath = [self getLogFilePath];
    }else{
        logPath = [self getAnalysisFilePath];
        
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setObject:[NSString stringWithFormat:@"19"] forKey:@"logType"];
        [item setObject:[NSString stringWithFormat:@"%zd",logType] forKey:@"type"];
        [item setObject:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000] forKey:@"time"];
//        [item setObject:[ZCLibNetworkTools shareNetworkTools].currentNetWorkStatusString forKey:@"network"];
        [item setObject:message forKey:@"content"];
        [item setObject:[NSString stringWithFormat:@"%@",title] forKey:@"title"];
        [item setObject:[NSString stringWithFormat:@"%@",[ZCLocalStore getLocalParamter:@"ZCKEY_COMPANYID"]] forKey:@"companyid"];
        [item setObject:[NSString stringWithFormat:@"%@",[ZCLocalStore getLocalParamter:@"ZCKEY_UID"]] forKey:@"uid"];
        message = [NSString stringWithFormat:@"%@,",[ZCLocalStore DataTOjsonString:item]];
    }
    
    [self checkPathAndCreate:[self getDocumentsFilePath:@""]];
    
    
    [self checkFileAndCreate:logPath];
    
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}

+(void)writefile:(NSString *)string withPath:(NSString *) filePath{
    NSFileManager *writeManager = [[NSFileManager alloc] init];
    [self checkFileAndCreate:filePath];
    [writeManager createFileAtPath:filePath contents:[string dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

+(NSString *) getDocumentsFilePath:(NSString*) fileName {
    
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:FILE_PATH];
    
    return [documentRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
}


+(BOOL) checkFileAndCreate:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        // 清理缓存
        [self cleanCache];
        
        return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}



+(BOOL) checkPathAndCreate:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        return [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



////////////////////////////////////////////////////////////
+(NSString * )getAnalysisFilePath{
    return [self getLogFilePath:@"analysis"];
}

+(NSString * )getTempSaveFilePath{
    return [self getLogFilePath:@"logtemp"];
}

+(NSString * )getLogFilePath{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //    NSString * dateString = [[NSString alloc] init];
    NSString * dateString = [dateFormatter stringForObjectValue:[NSDate date]];
    return [self getLogFilePath:dateString];
}

+(NSString * )getLogFilePath:(NSString *) dateString{
    return [self getDocumentsFilePath:[NSString stringWithFormat:@"Log_%@.txt",dateString]];
}

+(NSString *) readFileContent:(NSString *) filePath{
   return [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
}


////////////////////////////////////////////////////////////
+(void)cleanCache{
    NSString *logPath=[self getDocumentsFilePath:@""];
    dispatch_sync(dispatch_queue_create("com.log.cache", DISPATCH_QUEUE_SERIAL), ^{
        // 清理过期
        NSFileManager *_fileManager = [NSFileManager new];
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:logPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [logPath stringByAppendingPathComponent:fileName];
            // 过期，直接删除
            if(![self logIsValid:filePath]){
                [_fileManager removeItemAtPath:filePath error:nil];
            }
        }
    });
}
+(void)cleanCache:(NSString *) filePath{
    
    [ZCLogUtils logHeader:LogHeader info:@"移除文件%@",filePath];
    if(filePath==nil || [@"" isEqual:convertToString(filePath)]){
        return;
    }
    
    dispatch_sync(dispatch_queue_create("com.log.cache", DISPATCH_QUEUE_SERIAL), ^{
        NSFileManager *_fileManager = [NSFileManager new];
        
        BOOL isMove = [_fileManager removeItemAtPath:filePath error:nil];
        
        [ZCLogUtils logHeader:LogHeader info:@"移除文件成功：%d--%@",isMove,filePath];
    });
}

+ (int)Interval:(NSString *) filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    //NSLog(@"create date:%@",[attributes fileModificationDate]);
    NSString *dateString = [NSString stringWithFormat:@"%@",[attributes fileModificationDate]];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *formatterDate = [inputFormatter dateFromString:dateString];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *d = [cal components:unitFlags fromDate:formatterDate toDate:[NSDate date] options:0];
    
    //NSLog(@"%d,%d,%d,%d",[d year],[d day],[d hour],[d minute]);
    
    int result = (int)d.day;
    
    //	return 0;
    return result;
}


+(BOOL)logIsValid:(NSString *) filePath{
    if ([self Interval:filePath] < Log_Cache_Days) { //VALIDDAYS = 有效时间天数
        return YES;
    }
    return NO;
}
@end
