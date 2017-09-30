//
//
//  Created by 张新耀 on
//  Copyright © 2017年  . All rights reserved.
//


////////////////////////////////////////////////////////
/**
 *  字体及大小
 *
 *  @return 字体大小
 */
#define TitleFont [UIFont fontWithName:@"Helvetica Neue" size:18.0]

#define FontSeventeen [UIFont fontWithName:@"Helvetica Neue" size:17.0]
#define FontFiftent  [UIFont fontWithName:@"Helvetica Neue" size:15.0]
#define ListTitleFont [UIFont fontWithName:@"Helvetica Neue" size:16.0]
#define ListDetailFont [UIFont fontWithName:@"Helvetica Neue" size:14.0]
#define ListFileFont [UIFont fontWithName:@"Helvetica Neue" size:13.0]
#define ListTimeFont [UIFont fontWithName:@"Helvetica Neue" size:12.0]
#define ListElevenFont [UIFont fontWithName:@"Helvetica Neue" size:11.0]

////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
/**
 *  颜色取值方法
 *
 *  @return UIColor
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define COLORWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]



////////////////////////////////////////////////////////
/**
 *  背景颜色
 *
 *  @return 背景颜色值
 */
//系统灰色背景颜色
#define BgSystemColor       0xf1f1f1

//顶部蓝色背景
#define BgTitleColor        0x3C82E1

//搜索框背景颜色
#define BgSearchTitleColor  0xe8e8e8

//输入框背景
#define BgTextColor         0xe7e8e9

// 验证码不可点状态
#define BgVCodeColor        0x9ea2a2

// 登陆不可点状态
#define BgLoginColor        0x5fcccd

// 网络状态提醒背景
#define BgRedColor          0xFF3C32
#define BgLinkColor         0xFF4A4A
// 复制选中后工单号背景色
#define BgSelectedColor     0xc0c0c0

/**
 *  线条颜色
 *
 *  @return 线条颜色值
 */
#define BgLineColor     0xE7E7E7


// 列表背景颜色
#define BgListSectionColor   0xF5F5F5


////////////////////////////////////////////////////////
/**
 *  字体颜色
 *
 *  @return 字体颜色值
 */
#define TextWhiteColor          0xFFFFFF
#define TextBlackColor          0x000000
#define TextSizeFourColor       0x444444
#define TextSizeThreeColor      0x333333
#define TextSizeSixColor        0x666666
#define TextSizeNineColor       0x999999
#define TextLinkColor           0x07afb2
#define TextRLinkColor          0x81fcf2
#define TextLLinkColor          0x09aeb0

// LIST
#define TextLightDarkColor      0x4A4B4B
#define TextDarkColor           0x161616
#define TextListColor           0x8B98AD
#define TextPlaceHolderColor    0xBDC3D1
#define TextUnPlaceHolderColor  0x3D4966


