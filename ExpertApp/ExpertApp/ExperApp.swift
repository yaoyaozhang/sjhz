//
//  ExperApp.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import Foundation
import UIKit


/* 导航栏高度 */
let kNavigationH = 64
/* 工具栏高度 */
let kTabBarHeight = 49
/* 屏幕的宽 */
public let kSCREEN_WIDTH:CGFloat  = UIScreen.main.bounds.size.width
/* 屏幕的高 */
public let kSCREEN_HEIGHT:CGFloat  = UIScreen.main.bounds.size.height

public let ZC_iPhoneX = ((kSCREEN_WIDTH == 375.0 && kSCREEN_HEIGHT == 812.0) ? true : false)

public let NavBarHeight:CGFloat = (ZC_iPhoneX ? 88.0 : 64.0)


////////////////////////////////////////////////////////
/**
 *  背景颜色
 *
 *  @return 背景颜色值
 */
//系统灰色背景颜色
let BgSystemColor:Int64 = 0xf1f1f1

//顶部蓝色背景
let BgTitleColor:Int64  = 0x3C82E1

//搜索框背景颜色
let BgSearchTitleColor:Int64 =  0xe8e8e8

//输入框背景
let BgTextColor:Int64        =  0xe7e8e9

// 验证码不可点状态
let BgVCodeColor:Int64      =   0x9ea2a2

// 登录不可点状态
let BgLoginColor:Int64     =    0x5fcccd

// 网络状态提醒背景
let BgRedColor:Int64      =     0xFF3C32
let BgLinkColor:Int64      =    0xFF4A4A
// 复制选中后工单号背景色
let BgSelectedColor:Int64  =    0xc0c0c0

/**
 *  线条颜色
 *
 *  @return 线条颜色值
 */
let BgLineColor:Int64  =    0xE7E7E7


// 列表背景颜色
let BgListSectionColor:Int64 =   0xF5F5F5


////////////////////////////////////////////////////////
/**
 *  字体颜色
 *
 *  @return 字体颜色值
 */
let TextWhiteColor:Int64   =        0xFFFFFF
let TextBlackColor:Int64   =     0x000000
let TextSizeFourColor:Int64 =       0x444444
let TextSizeThreeColor:Int64    =   0x333333
let TextSizeSixColor:Int64      =   0x666666
let TextSizeNineColor:Int64     =   0x999999
let TextLinkColor:Int64         =   0x07afb2
let TextRLinkColor:Int64        =   0x81fcf2
let TextLLinkColor:Int64        =   0x09aeb0

// LIST
let TextLightDarkColor:Int64    =   0x4A4B4B
let TextDarkColor:Int64        =   0x161616
let TextListColor:Int64         =   0x8B98AD
let TextPlaceHolderColor:Int64  =   0xBDC3D1
let TextUnPlaceHolderColor:Int64 =   0x3D4966


func UIColorFromRGB(rgbValue:Int64) -> UIColor {
    return UIColor.init(red:CGFloat(((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0), green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: 1.0)
}

func UIColorFromRGBAlpha(rgbValue:Int64,alpha:CGFloat) -> UIColor {
    return UIColor.init(red:CGFloat(((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0), green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha)
}


func FontWithSize(size:CGFloat) -> UIFont {
    return UIFont.init(name: "Helvetica Neue", size: size)!
}
