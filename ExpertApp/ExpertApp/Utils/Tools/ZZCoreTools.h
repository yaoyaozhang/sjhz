//
//  ZZCoreTools.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,LineType) {
    LineLayerBorder = 0,//边框线
    LineHorizontal  = 1,//竖线
    LineVertical    = 2,//横线
};

@interface ZZCoreTools : NSObject

/**
 *  从本地NSUserDefaults取出值
 *
 *  @param key
 *
 *  @return
 */
+(id)getValueFromNSUserDefaultsByKey:(NSString*)key;

/**
 *  同步NSUserDefaults数据
 *
 *  @param key
 *  @param value
 */
+(void)syncNSUserDeafaultsByKey:(NSString*)key withValue:(id)value;

/**
 *  移除NSUserDefaults数据
 *
 *  @param key 要移除的key
 */
+(void)removeNSUserDeafaultsByKey:(NSString*)key;


/**
 *  获取当前语言
 *
 *  @return 返回语言简称
 */
+ (NSString*)getPreferredLanguage;

/**
 *  获取UIID，目前不可用
 *
 *  @return uiid
 */
+(NSString *) getDeviceId;

/**
 *  获取系统版本
 *
 *  @return ios版本
 */
+(NSString *) getDeviceVersion;

/**
 *  获取版本version值
 *
 *  @return version
 */
+(NSString *) getAppVersion;

/**
 *  获取app 版本号
 *
 *  @return CFBundleVersion
 */
+(NSString *) getAppBuildVersion;

/**
 *  获取系统版本的int值
 *
 *  @return 系统版本
 */
+(int)getSystemVerson;

/**
 *  获取设备名称
 *
 *  @return iPad / iPhone
 */
+(NSString *)getDeviceName;


/**
 *  检查是否有相册权限
 *
 *  @return YES,有，
 */
+(BOOL)isHasPhotoLibraryAuthorization;


/**
 *  检查是否有相机权限
 *
 *  @return YES,有，
 */
+(BOOL)isHasCaptureDeviceAuthorization;

/**
 *  获取录音配置
 *
 *  @return 录音配置dict
 */
+ (NSDictionary*)getAudioRecorderSettingDict;
+ (NSDictionary*)getAudioRecorderMP3SettingDict;


/**
 *  获取最上层VC
 *
 *  @return
 */
+(UIViewController *)getCurrentRootVC;


/**
 *  获取顶层的Controller
 *
 *  @return
 */
+(UIViewController *)getCurrentTopVC;


/**
 *  获取内容的高度
 *
 *  @param string <#string description#>
 *  @param font   <#font description#>
 *  @param width  <#width description#>
 *
 *  @return <#return value description#>
 */
+(CGFloat)getHeightContain:(NSString *)string font:(UIFont *)font Width:(CGFloat) width;


/**
 *  获取内容的宽度
 *
 *  @param string <#string description#>
 *  @param font   <#font description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
+(CGFloat)getWidthContain:(NSString *)string font:(UIFont *)font Height:(CGFloat) height;


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
+ (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width;

+ (CGSize )autoHeightOfLabel:(UILabel *)label withHeight:(CGFloat )height;

/**
 *  设置View的线条宽度和偏移量
 *
 *  @param type <#type description#>
 *  @param view <#view description#>
 */
+(void)setLineOffset:(LineType) type withView:(UIView *) view;



/**
 过滤html表情
 
 @param text
 @return
 */
+(NSString *)filterSpecialHTML:(NSString *) text;


/**
 *  给非a标签下的链接，添加a表情，使其有链接效果
 *
 *  @param originalStr <#originalStr description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)transformString:(NSString *)originalStr;


/**
 *  获取每行文本的内容
 *
 *  @param text <#text description#>
 *  @param font <#font description#>
 *  @param rect <#rect description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)getSeparatedLinesFromLabel:(NSString *)text font:(UIFont *) font frame:(CGRect ) rect;

+(NSString*) DataTOjsonString:(id)object;




/**
 *  根据类型获取图片
 *  @param zc_imagepicker UIImagePickerController
 *  @param buttonIndex 2，来源照相机，1来源相册
 *  @param delegate       
 *
 */
+(void)getPhotoByType:(NSInteger) buttonIndex byUIImagePickerController:(UIImagePickerController*)zc_imagepicker Delegate:(id)delegate ;


/**
 *  系统相机相册的完成的代理事件
 *  @param zc_imagepicker  UIImagePickerController
 *  @param zc_sourceView   父类VC的view
 *  @param delegate       ZCUIKeyboardDelegate
 *  @param info           图片资源 type 1 相机，2相册
 */
+(void)imagePickerController:(UIImagePickerController *)zc_imagepicker
didFinishPickingMediaWithInfo:(NSDictionary *)info WithView:(UIView *)zc_sourceView
                    Delegate:(id)delegate block:(void(^)(NSString *filePath ,int type, NSString *duration)) finshBlock;;

@end
