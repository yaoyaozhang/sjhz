//
//  MusicInfoModel.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel

// 重写的kvc部分方法.
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    }
}

@end
