//
//  ZZDataCache.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZZUserInfo.h"
#import "ZZDictModel.h"


/** 用户ID 用户的唯一标识 */
extern NSString * const KEY_LOGIN_USERINFO;
extern NSString * const KEY_LOGIN_USERNAME;
extern NSString * const KEY_LOGIN_OUTBYSELF;
extern NSString * const KEY_LOGIN_USERPWD;


extern NSString * const KEY_CONFIG_KNTYPE;
extern NSString * const KEY_CONFIG_TITLE;
extern NSString * const KEY_CONFIG_REGION;
extern NSString * const KEY_CONFIG_DCLABEL;
extern NSString * const KEY_CONFIG_DEPARTMENT;
extern NSString * const KEY_CONFIG_HSLEVEL;
extern NSString * const KEY_CONFIG_TC;
extern NSString * const KEY_CONFIG_RELATION;


extern NSString * const KEY_SEARCH_KEYWORD;
extern NSString * const KEY_CONFIG_CHAPTERTYPE;





@interface ZZDataCache : NSObject




+(ZZDataCache *) getInstance;


-(ZZUserInfo *) getLoginUser;
-(void)changeUserInfo:(ZZUserInfo *) info;


-(BOOL) isLogin;


-(void)loginOut;


-(void)cleanCache;

////////////////////////////////////////////
// 配置信息
// status = 0,完成 1开始加载  2失败
-(void) getCacheConfigDict:(void (^)(NSMutableDictionary *dict,int status)) resultBlock;
-(void) setConfigNetworkDict:(NSDictionary *) dict;

-(NSMutableArray *)getConfigArrByType:(NSString *) KEY_Config;


-(void)saveLoginUserInfo:(NSMutableDictionary *) infoDict view:(UIView *) view;

-(void)setSearchKeyword:(NSString *) key;
-(NSArray *) getSearchKeyWork;

@end
