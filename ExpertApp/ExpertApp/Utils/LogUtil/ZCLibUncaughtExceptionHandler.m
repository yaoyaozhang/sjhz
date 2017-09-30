//
//  ZCLibUncaughtExceptionHandler.m
//  ExpertKit
//
//  Created by zhangxy on 2017/2/28.
//  Copyright © 2017年 zhichi. All rights reserved.
//

#import "ZCLibUncaughtExceptionHandler.h"
#import "ZCLogUtils.h"
#import <mach-o/dyld.h>
#import <mach-o/loader.h>

@implementation ZCLibUncaughtExceptionHandler

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *exceptionMessage = [NSString stringWithFormat:@"%@\nreason:%@\ncallStackSymbols:\n%@",
                     ExecutableUUID(),reason,[arr componentsJoinedByString:@"\n"]];
    
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
    if([exceptionMessage rangeOfString:@"ZCLib"].location != NSNotFound || [exceptionMessage rangeOfString:@"ZCUI"].location != NSNotFound){
        [ZCLogUtils cacheLog:name content:exceptionMessage logType:ZCLogTypeError];
    }else{
        [ZCLogUtils cacheLog:name content:exceptionMessage logType:ZCLogTypeUnknowError];
        
    }

}

static NSUUID *ExecutableUUID(void)
{
    const struct mach_header *executableHeader = NULL;
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE)
        {
            executableHeader = header;
            break;
        }
    }
    
    if (!executableHeader)
        return nil;
    
    BOOL is64bit = executableHeader->magic == MH_MAGIC_64 || executableHeader->magic == MH_CIGAM_64;
    uintptr_t cursor = (uintptr_t)executableHeader + (is64bit ? sizeof(struct mach_header_64) : sizeof(struct mach_header));
    const struct segment_command *segmentCommand = NULL;
    for (uint32_t i = 0; i < executableHeader->ncmds; i++, cursor += segmentCommand->cmdsize)
    {
        segmentCommand = (struct segment_command *)cursor;
        if (segmentCommand->cmd == LC_UUID)
        {
            const struct uuid_command *uuidCommand = (const struct uuid_command *)segmentCommand;
            return [[NSUUID alloc] initWithUUIDBytes:uuidCommand->uuid];
        }
    }
    
    return nil;
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}


+(void) expressUncaughtExceptionHandler:(NSException *)exception {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *exceptionMessage = [NSString stringWithFormat:@"dSYM UUID:%@\nreason:%@\ncallStackSymbols:\n%@",
                                  ExecutableUUID(),reason,[arr componentsJoinedByString:@"\n"]];
    
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
    [ZCLogUtils cacheLog:name content:exceptionMessage logType:ZCLogTypeException];
}

@end
