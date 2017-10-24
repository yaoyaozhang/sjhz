//
//  ZZCoreCommon.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCoreCommon.h"


#import <Foundation/NSString.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *regrexUrl = @"\\b((?:[\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|(?:[^\\p{Punct}\\s]|/))+|\\.com|\\.cn|\\.org|\\.net|\\.hk|\\.int|\\.edu|\\.gov|\\.mil|\\.arpa|\\.biz|\\info|\\.name|\\.pro|\\.coop|\\.aero|\\.museum|\\.cc|\\.tv)";


@implementation ZZCoreCommon


NSString *urlEncodedString(NSString *url){
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

NSString* extractFileNameFromPath(NSString* path){
    return [path lastPathComponent];
}



NSString* getTmpDownloadFilePath(NSString* filePath){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:extractFileNameFromPath(filePath)];
}

NSString* getSysCacheFilePath(NSString* cacheKey){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:cacheKey];
}

NSString *convertToString(id object){
    if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    }else if(!object){
        return @"";
    }else if([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }else{
        return [NSString stringWithFormat:@"%@",object];
    }
}
NSString *convertIntToString(int object){
    return [NSString stringWithFormat:@"%d",object];
}

NSString* md5(NSString* input)
{
    if(isEmpty(input)){
        return @"";
    }
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

NSString* trimString (NSString* input) {
    NSMutableString *mStr = [input mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);
    NSString *result = [mStr copy];
    return result;
}

BOOL is_null(id object) {
    return (nil == object || [@"" isEqual:object] || [object isKindOfClass:[NSNull class]]);
}

BOOL isEmpty(NSString* str) {
    
    if (is_null(str)) {
        return YES;
    }
    
    if([str isKindOfClass:[NSString class]]){
        return [trimString(str) length] <= 0;
    }
    
    return NO;
}
//判断是否为整形：
BOOL validatePureInt(NSString *string){
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
BOOL validatePureFloat(NSString *string){
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

BOOL validateNumber(NSString *str){
    NSString *emailRegex = @"^[-+]?(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$";
    //    NSString *emailRegex = @"^(\\w-*\\.*)+@(\\w-?)+(\\.\\w{2,})+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}

BOOL validateEmail(NSString* email) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //    NSString *emailRegex = @"^(\\w-*\\.*)+@(\\w-?)+(\\.\\w{2,})+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


BOOL validatePassword(NSString* password) {
    // 密码长度至少8位
    if([@"" isEqual:convertToString(password)] || password.length<8 || password.length>20){
        return NO;
    }
    NSString *emailRegex = @"[\u4E00-\u9FA5]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    // 通过判断是不是汉字 取反
    return ![emailTest evaluateWithObject:password];
}

//是否是真正的手机号
BOOL validateMobile(NSString* mobile) {
    //    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[0,0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
BOOL validatePhone(NSString* phone){
    NSString *phoneRegex = @"^\\d{11}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

BOOL validateQQNumber(NSString *qqNumber)
{
    NSString *QQRegex = @"^[1-9]*[1-9][0-9]*$";
    NSPredicate *QQTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", QQRegex];
    return [QQTest evaluateWithObject:qqNumber];
}

BOOL validateUName(NSString* uname){
    if(is_null(uname)){
        return NO;
    }
    
    if(getStringCharCount(uname) > 8){
        return NO;
    }
    
    return YES;
}


int getStringCharCount(NSString *text){
    int len=0;
    for (int i=0 ;i<text.length;i++) {
        int s=[text characterAtIndex:i];
        if( s > 0x4e00 && s < 0x9fff){
            //中文算2个字符
            len=len+2;
        }else{
            len=len+1;
        }
    }
    return len;
}

BOOL validdatePinYin(NSString *pinYin){
    NSString *PYRegex = @"^[A-Za-z]*$";
    NSPredicate *PYTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PYRegex];
    return [PYTest evaluateWithObject:pinYin];
}



NSString* getDocumentsFilePath(const NSString* fileName) {
    
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents"];
    
    return [documentRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
}

NSString* getLibraryFilePath(const NSString* fileName){
    NSString* documentRoot = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library"];
    return [documentRoot stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
}


NSString* getResourcePath(NSString* basePath, NSString* resName, NSString* resType) {
    NSString* path = [NSString pathWithComponents:[NSArray arrayWithObjects:basePath, resName, nil]];
    return [[NSBundle mainBundle] pathForResource:path ofType:resType];
}

NSURL* getResourceUrl(NSString* basePath, NSString* resName, NSString* resType) {
    NSString* path = [NSString pathWithComponents:[NSArray arrayWithObjects:basePath, resName, nil]];
    return [[NSBundle mainBundle] URLForResource:path withExtension:resType];
}

BOOL checkFileIsExsis(NSString *filePath){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:convertToString(filePath)]){
        return YES;
    }else{
        return NO;
    }
}

/*删除文件 指向目录为（NSCachesDirectory）临时文件夹*/
BOOL deleteFileAtPath(NSString *filePath){
    BOOL isDel = NO;
    if(filePath !=nil && checkFileIsExsis(filePath)){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *error;
        
        isDel=[fileManager removeItemAtPath:filePath error:&error];
    }
    return isDel;
}




BOOL checkPathAndCreate(NSString *filePath){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        return [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

BOOL checkFileAndCreate(NSString *filePath){
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        return YES;
    }else{
        return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}


NSString * dateTransformString(NSString* fromate,NSDate*date){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromate];
    //    NSString * dateString = [[NSString alloc] init];
    NSString * dateString = [dateFormatter stringForObjectValue:date];
    return dateString;
}
NSString * dateTransformDateString(NSString* fromate,NSString *dateStr){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromate];
    //    NSString * dateString = [[NSString alloc] init];
    NSString * dateString = [dateFormatter stringForObjectValue:stringFormateDate(dateStr)];
    return dateString;
}

NSString * longLongDateTransformString(NSString* fromate,long long longdate){
    return shortDateTransformString(fromate, longdate/1000);
}

NSString * shortDateTransformString(NSString* fromate,long long longdate){
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longdate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromate];
    //    NSString * dateString = [[NSString alloc] init];
    NSString * dateString = [dateFormatter stringForObjectValue:date];
    return dateString;
}

NSDate * stringFormateDate(NSString * stringDate){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
    NSDate *dateFromString = nil;
    // voila!
    dateFromString = [dateFormatter dateFromString:stringDate];
    return dateFromString;
}



NSString *intervalSinceNow(NSString *theDate){
    if([@"" isEqual:convertToString(theDate)]){
        return @"";
    }
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    
    NSTimeInterval cha=now-late;
    
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        if([timeString isEqualToString:@"0"]){
            timeString=[NSString stringWithFormat:@"刚刚"];
        }else{
            timeString=[NSString stringWithFormat:@"%@%@", timeString,@"分钟前"];
        }
        
    }else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@%@", timeString,@"小时前"];
    }else if (cha/86400>1 && cha/86400<=7)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@%@", timeString,@"天前"];
    }else if(getDataYear(dat)- getDataYear(d)==0){
        // 同一年
        //        timeString=dateTransformStringAsYMDByFormate(d,@"MM月dd日 HH:mm");
        timeString=dateTransformString(@"MM-dd HH:mm",d);
    }else{
        timeString=dateTransformString(@"yyyy-MM-dd",d);//[NSString stringWithFormat:@"%@",theDate];
    }
    return timeString;
}


NSString *intervalSinceSimpleNow(NSString *theDate){
    if(is_null(theDate)){
        //        return @"";
        theDate=dateTransformString(@"yyyy-MM-dd HH:mm:ss", [NSDate date]);
    }
    NSArray *timeArray=[theDate componentsSeparatedByString:@"."];
    theDate=[timeArray objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate date];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    
    NSTimeInterval cha=now-late;
    
    
    if (cha/3600<1) {
        timeString=dateTransformString(@"HH:mm",d);
    }else if (cha/3600>1&&cha/86400<1) {
        if(getDataDay(dat) == getDataDay(d)){
            timeString=dateTransformString(@"HH:mm",d);
        }else{
            timeString=dateTransformString(@"昨天 HH:mm",d);
        }
    }else if (cha/86400>1 && cha/86400<=7)
    {
        timeString=dateTransformString(@"MM-dd",d);
    }else if(getDataYear(dat)- getDataYear(d)==0){
        // 同一年
        timeString=dateTransformString(@"MM-dd",d);
    }else{
        timeString=dateTransformString(@"MM-dd",d);
    }
    return timeString;
}

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
NSInteger getDataYear(NSDate *date){
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.year;
}
NSInteger getDataDay(NSDate *date){
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.day;
}



NSString * random32bitString(int len)

{
    
    char data[len];
    
    for (int x=0;x<len;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    
}
@end
