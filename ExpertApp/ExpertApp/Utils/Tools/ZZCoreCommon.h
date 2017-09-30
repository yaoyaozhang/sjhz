//
//  ZZCoreCommon.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FormateTime @"yyyy-MM-dd HH:mm:ss"

@interface ZZCoreCommon : NSObject

/**
 *  格式化URL
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
NSString *urlEncodedString(NSString *url);

/**
 *  空对象转行成@""
 *
 *  @param object 传入的不定对象
 *
 *  @return 字符串
 */
NSString *convertToString(id object);
NSString *convertIntToString(int object);

/**
 * do md5 hash
 ***/
NSString* md5(NSString* input);

/**
 *  去掉尾部空格
 *
 *  @param input 要去掉的空格
 *
 *  @return
 */
NSString* trimString (NSString* input);

/**
 *  判断nil
 *
 *  @param object
 *
 *  @return
 */
BOOL is_null(id object);

/**
 *  判断@""
 *
 *  @param str
 *
 *  @return
 */
BOOL isEmpty(NSString* str);


// 验证
BOOL validateEmail(NSString* email);
BOOL validatePassword(NSString* password);
BOOL validateMobile(NSString* mobile);
// 仅验证11位数字
BOOL validatePhone(NSString* phone);
BOOL validateQQNumber(NSString *qqNumber);
BOOL validateUName(NSString* uname);
BOOL validdatePinYin(NSString *pinYin);

//判断是否为整形：
BOOL validatePureInt(NSString *string);
//判断是否为浮点形：
BOOL validatePureFloat(NSString *string);

BOOL validateNumber(NSString *str);

//计算text的长度，英文算1个，汉字算2个
int getStringCharCount(NSString *text);


/**
 * extract the file name from path
 *
 **/
NSString* extractFileNameFromPath(NSString* path);


/**
 *  get the Tmp path of download file
 *
 ***/
NSString* getTmpDownloadFilePath(NSString* filePath);

/**
 *  get cache file path
 ***/
NSString* getSysCacheFilePath(NSString* cacheKey);

//获取Library路径
NSString* getLibraryFilePath(const NSString* fileName);

NSString* getDocumentsFilePath(const NSString* fileName);

NSString* getResourcePath(NSString* basePath, NSString* resName, NSString* resType);

NSURL* getResourceUrl(NSString* basePath, NSString* resName, NSString* resType);


BOOL checkFileIsExsis(NSString *filePath);

/*删除文件 指向目录为（NSCachesDirectory）临时文件夹*/
BOOL deleteFileAtPath(NSString *filePath);


//检查路径，没有就创建路径
BOOL checkPathAndCreate(NSString *path);

//检查路径文件，没有就创建路径和文件
BOOL checkFileAndCreate(NSString *filePath);



/**
 *  日期格式
 *
 *  @param fromate 格式
 *  @param date    要格式的日期
 *
 *  @return 格式化后的字符串
 */
NSString * dateTransformString(NSString* fromate,NSDate*date);
NSString * dateTransformDateString(NSString* fromate,NSString *dateStr);

/**
 *  longlong类型日期，转换为字符串
 *
 *  @param fromate  格式
 *  @param longdate 转换的类型，主要php和java日期精确度不一样
 *
 *  @return 日期字符串
 */
NSString * longLongDateTransformString(NSString* fromate,long long longdate);
NSString * shortDateTransformString(NSString* fromate,long long longdate);

/**
 *  字符串转日期
 *
 */
NSDate * stringFormateDate(NSString * stringDate);

/**
 *  计算日期与当前时间的差
 *
 *  @param theDate 要对比的日期
 *
 *  @return 刚刚、几分钟前、几小时前、几天前、日期
 */
NSString *intervalSinceNow(NSString *theDate);
NSString *intervalSinceSimpleNow(NSString *theDate);


/**
 *  获取日期的年
 *
 *  @param date 要获取的日期
 *
 *  @return 返回哪一年
 */
NSInteger getDataYear(NSDate *date);

/**
 *  获取日期的天
 *
 *  @param date 要获取的日期
 *
 *  @return 返回哪一天
 */
NSInteger getDataDay(NSDate *date);


/**
 *  获取随机字符串
 *
 *  @return 32位字符串
 */
NSString *random32bitString(int len);
@end
