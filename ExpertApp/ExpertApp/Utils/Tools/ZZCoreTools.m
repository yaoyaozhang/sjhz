//
//  ZZCoreTools.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/14.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCoreTools.h"
#import "UIDevice-Hardware.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreText/CoreText.h>

@implementation ZZCoreTools

/**Author:Ronaldo Description:从本地NSUserDefaults取出值*/
+(id)getValueFromNSUserDefaultsByKey:(NSString*)key
{
    if (key) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        id obj = [defaults objectForKey:key];
        return obj;
    }
    return nil;
}

/**Author:Ronaldo Description:同步NSUserDefaults数据*/
+(void)syncNSUserDeafaultsByKey:(NSString*)key withValue:(id)value
{
    if (key && value) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:value forKey:key];
        [defaults  synchronize];
    }
}

+(void)removeNSUserDeafaultsByKey:(NSString*)key{
    if (key) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:key];
        [defaults  synchronize];
    }
}


+ (NSString*)getPreferredLanguage
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    return preferredLang;
}

+(NSString *) getDeviceId{
    //获取设备id号
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    //    NSString *deviceUID = [[device identifierForVendor] UUIDString];
    //    return  deviceUID;
    
    return [device getIOSUUID];
    
}

+(NSString *) getDeviceVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString *) getAppVersion{
    //WSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    //kCFBundleVersionKey 获取build的值
    //CFBundleShortVersionString 获取version的值
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+(NSString *) getAppBuildVersion{
    //WSLog(@"%@",[[NSBundle mainBundle] infoDictionary]);
    //kCFBundleVersionKey 获取build的值
    //CFBundleShortVersionString 获取version的值
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return version;
}

+(int)getSystemVerson
{
    int strin=[[[UIDevice currentDevice] systemVersion] intValue];
    return strin;
}

+(NSString*)getDeviceName
{
    return [[UIDevice currentDevice] modelIdentifier];
    //    NSString * device=[[NSString alloc]init];
    //    if ([[[UIDevice currentDevice] model]isEqualToString:@"iPad Simulator"]||[[[UIDevice currentDevice] model]isEqualToString:@"iPad"]) {
    //        device=@"iPad";
    //    }
    //    else
    //    {
    //        device=@"iPhone";
    //    }
    //    return device;
}

+(NSString *)getAppName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}



//检查是否有相册的权限
+(BOOL)isHasPhotoLibraryAuthorization{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        return NO;
    }
    return YES;
}
//检测是否有相机的权限
+(BOOL)isHasCaptureDeviceAuthorization{
    if (iOS7) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
    
}

/**
 war获取录音设置
 @returns 录音设置
 */
+ (NSDictionary*)getAudioRecorderSettingDict
{
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    return recordSetting;
}

+ (NSDictionary*)getAudioRecorderMP3SettingDict{
    NSMutableDictionary *recordSetting=[[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEGLayer3] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:22050.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    return recordSetting;
}


+(UIViewController *)getCurrentRootVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    return result;
}


+(UIViewController *)getCurrentTopVC{
    UIViewController *controller=[self getCurrentRootVC];
    if([self getCurrentRootVC]!=nil && [[self getCurrentRootVC] isKindOfClass:[UINavigationController class]]){
        controller=[[self getCurrentRootVC].childViewControllers objectAtIndex:[self getCurrentRootVC].childViewControllers.count-1];
    }
    return controller;
}


+(CGFloat)getHeightContain:(NSString *)string font:(UIFont *)font Width:(CGFloat) width
{
    if(string==nil){
        return 0;
    }
    //转化为格式字符串
    NSAttributedString *astr = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:font}];
    CGSize contansize=CGSizeMake(width, CGFLOAT_MAX);
    if(iOS7){
        CGRect rec = [astr boundingRectWithSize:contansize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        return rec.size.height;
    }else{
        CGSize s= [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        return s.height;
    }
}

+(CGFloat)getWidthContain:(NSString *)string font:(UIFont *)font Height:(CGFloat) height
{
    if(string==nil){
        return 0;
    }
    //转化为格式字符串
    NSAttributedString *astr = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName: font}];
    
    CGSize cs=CGSizeMake(CGFLOAT_MAX,height);
    if(!iOS7){
        CGSize s= [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        
        return s.width;
    }else{
        CGRect rec = [astr boundingRectWithSize:cs options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        CGSize size = rec.size;
        
        return size.width;
    }
}



/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
+ (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}
+ (CGSize )autoHeightOfLabel:(UILabel *)label withHeight:(CGFloat )height{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    label.numberOfLines = 0;
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, height);
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}


/**
 *  设置线条宽度
 *
 *  @param type 类型，横线、竖线、边框线
 *  @param view 要设置的view
 */
+(void)setLineOffset:(LineType) type withView:(UIView *) view{
    CGFloat pixelAdjustOffset = 0;
    if ((int)(LINE_WIDTH * [UIScreen mainScreen].scale + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    CGRect rect = view.frame;
    
    if(type==LineHorizontal){
        rect.origin.y = rect.origin.y - pixelAdjustOffset;
        rect.size.height = SINGLE_LINE_WIDTH;
    }else if(type==LineVertical){
        rect.origin.x = rect.origin.x - pixelAdjustOffset;
        rect.size.width = SINGLE_LINE_WIDTH;
    }else{
        rect.origin.x = rect.origin.x - pixelAdjustOffset;
        rect.origin.y = rect.origin.y - pixelAdjustOffset;
        
        view.layer.borderWidth = SINGLE_LINE_WIDTH;
    }
    
    
    if(rect.size.height<0.5){
        rect.size.height = 0.5;
    }
    if(rect.size.width<0.5){
        rect.size.width = 0.5;
    }
    
    view.frame = rect;
}

+(NSString *)filterSpecialHTML:(NSString *) text{
    NSMutableString *textString = [[NSMutableString alloc] initWithString:convertToString(text)];
    @try {
        [textString replaceOccurrencesOfString:@"<br />" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textString.length)];
        [textString replaceOccurrencesOfString:@"<br/>;" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textString.length)];
        [textString replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textString.length)];
        [textString replaceOccurrencesOfString:@"&nbsp;" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textString.length)];
        [textString replaceOccurrencesOfString:@"amp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, textString.length)];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return (NSString *) textString;
}


+ (NSString *)transformString:(NSString *)originalStr{
    NSString *text = originalStr;
    
    //解析http://短链接
    NSString *regex_http = @"(http(s)?://|www)([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";//http://短链接正则表达式
    
    //    NSString *regex_http = @"http(s)?://[^\\s()<>]+(?:\\([\\w\\d]+\\)|(?:[^\\p{Punct}\\s]|/))+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
    
    NSString *regex_text=[NSString stringWithFormat:@"%@(?![^<]*>)(?![^>]*<)",regex_http];
    //    NSArray *array_http = [text componentsMatchedByRegex:regex_text];
    
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regex_text
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:originalStr options:0 range:NSMakeRange(0, [originalStr length])];
    
    NSInteger len = 0;
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        
        NSRange range = match.range;
        NSString* substringForMatch = [originalStr substringWithRange:range];
        
        NSLog(@"%@,%@",NSStringFromRange(range),substringForMatch);
        
        NSString *funUrlStr = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",substringForMatch, substringForMatch];
        text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location+len, substringForMatch.length) withString:funUrlStr];
        len = 15+substringForMatch.length;
    }
    
    //    if ([array_http count]) {
    //        for (NSString *str in array_http) {
    //            if([str rangeOfString:@">"].location!=NSNotFound || [str rangeOfString:@"'"].location!=NSNotFound || [str rangeOfString:@"\""].location!=NSNotFound){
    //                continue;
    //            }
    //
    //            NSRange range = [text rangeOfString:str];
    //            NSString *funUrlStr = [NSString stringWithFormat:@"<a href=\"%@\">%@</a>",str, str];
    //            text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, str.length) withString:funUrlStr];
    //        }
    //    }
    
    
    
    //解析表情
    //    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情的正则表达式
    //    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    //    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImage.plist"];
    //    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    //    // NSString *path = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] bundlePath]];
    //
    //    if ([array_emoji count]) {
    //        for (NSString *str in array_emoji) {
    //            NSRange range = [text rangeOfString:str];
    //            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
    //            if (i_transCharacter) {
    //                //NSString *imageHtml = [NSString stringWithFormat:@"<img src = 'file://%@/%@' width='12' height='12'>", path, i_transCharacter];
    //                NSString *imageHtml = [NSString stringWithFormat:@"<img src =%@>",  i_transCharacter];
    //                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:[imageHtml stringByAppendingString:@" "]];
    //            }
    //        }
    //    }
    
    
    //返回转义后的字符串
    return text;
}



+ (NSArray *)getSeparatedLinesFromLabel:(NSString *)text font:(UIFont *) font frame:(CGRect ) rect
{
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CFRelease(myFont);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(frameSetter);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    CFRelease(path);
    CFRelease(frame);
    
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}



+(NSString*) DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
    //                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
    //                                                         error:&error];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}


+(void)getPhotoByType:(NSInteger) buttonIndex byUIImagePickerController:(UIImagePickerController*)zc_imagepicker Delegate:(id)delegate {
    switch (buttonIndex) {
        case 2:
        {
            if ([ZZCoreTools isHasCaptureDeviceAuthorization]) {
                
                zc_imagepicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                zc_imagepicker.allowsEditing=NO;
                [(UIViewController *)delegate presentViewController:zc_imagepicker animated:YES completion:^{
                }];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许访问你的手机相机" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
            }
            break;
        }
        case 1:
        {
            //                从相册选择
            
            if ([ZZCoreTools isHasPhotoLibraryAuthorization]) {
                
                zc_imagepicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                
                // 处理导航栏和状态栏的透明的问题,并重写他的navc代理方法
                if (iOS7) {
                    zc_imagepicker.edgesForExtendedLayout = UIRectEdgeNone;
                }
                
                if ([zc_imagepicker.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
                    // 是否设置相册背景图片
//                    if ([ZZCoreTools zcgetPhotoLibraryBgImage]) {
//                        // 图片是否存在
//                        if ([ZZCoreTools zcuiGetBundleImage:@"ZCIcon_navcBgImage"]) {
//                            
//                            [zc_imagepicker.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[ZCUITools zcuiGetBundleImage:@"ZCIcon_navcBgImage"]]];
//                        }else{
//                            [zc_imagepicker.navigationBar setBarTintColor:[ZCUITools zcgetImagePickerBgColor]];
//                            [zc_imagepicker.navigationBar setTranslucent:YES];
//                            [zc_imagepicker.navigationBar setTintColor:[ZCUITools  zcgetImagePickerTitleColor]];
//                        }
//                    }else{
//                        // 不设置默认治随主题色
                        [zc_imagepicker.navigationBar setBarTintColor:UIColorFromRGB(BgTitleColor)];
//                    }
                    
                    [zc_imagepicker.navigationBar setTranslucent:YES];
                    [zc_imagepicker.navigationBar setTintColor:UIColorFromRGB(BgTitleColor)];
                }else{
                    [zc_imagepicker.navigationBar setBackgroundColor:UIColorFromRGB(BgSystemColor)];
                }
                // 设置系统相册导航条标题文字的大小
                //[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]
                [zc_imagepicker.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(TextWhiteColor), NSForegroundColorAttributeName,TitleFont, NSFontAttributeName, nil]];
                
                zc_imagepicker.allowsEditing=NO;
                
                [(UIViewController *)delegate presentViewController:zc_imagepicker animated:YES completion:^{
                    
                }];
            }else{
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的手机相册" message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil];
                [alert show];
            }
            break;
        }
        default:
            break;
    }
    
}

+(void)imagePickerController:(UIImagePickerController *)zc_imagepicker didFinishPickingMediaWithInfo:(NSDictionary *)info WithView:(UIView *)zc_sourceView Delegate:(id)delegate block:(void (^)(NSString *, int, NSString *))finshBlock{
    //    [zc_imagepicker dismissViewControllerAnimated:YES completion:^{
    //        NSLog(@"页面消失了");
    //    }];
    
    if (zc_imagepicker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImage * oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        oriImage = [self normalizedImage:oriImage];
        // 发送图片
        if (oriImage) {
            NSData * imageData =UIImageJPEGRepresentation(oriImage, 0.75f);
            NSString * fname = [NSString stringWithFormat:@"/expert/image100%ld.jpg",(long)[NSDate date].timeIntervalSince1970];
            checkPathAndCreate(getDocumentsFilePath(@"/expert/"));
            NSString *fullPath=getDocumentsFilePath(fname);
            [imageData writeToFile:fullPath atomically:YES];
            CGFloat mb=imageData.length/1024/1024;
            if(mb>6){
                if(((UIViewController *)delegate).navigationController){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [zc_sourceView makeToast:@"图片大小需小于6M!"];
                    });
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [zc_sourceView makeToast:@"图片大小需小于6M!"];
                    });
                }
                return;
            }
            //            [self sendMessageOrFile:fullPath type:ZCMessageTypePhoto duration:@""];
            if (finshBlock) {
                finshBlock(fullPath,1,@"");
            }
        }
        
    }
    if (zc_imagepicker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        originImage = [self normalizedImage:originImage];
        if (originImage) {
            NSData * imageData =UIImageJPEGRepresentation(originImage, 0.75f);
            NSString * fname = [NSString stringWithFormat:@"/expert/image100%ld.jpg",(long)[NSDate date].timeIntervalSince1970];
            checkPathAndCreate(getDocumentsFilePath(@"/expert/"));
            NSString *fullPath=getDocumentsFilePath(fname);
            [imageData writeToFile:fullPath atomically:YES];
            CGFloat mb=imageData.length/1024/1024;
            if(mb>6){
                if(((UIViewController *)delegate).navigationController){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [zc_sourceView makeToast:@"图片大小需小于6M!"];
                    });
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [zc_sourceView makeToast:@"图片大小需小于6M!"];
                    });
                }
                return;
            }
            //            [self sendMessageOrFile:fullPath type:ZCMessageTypePhoto duration:@""];
            if (finshBlock) {
                finshBlock(fullPath,2,@"");
            }
        }
    }
    
}


+ (UIImage *)normalizedImage:(UIImage *) image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
@end
