//
//  ZZDataCache.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDataCache.h"
#import "ZCLocalStore.h"
#define ImageLocalPath @"CacheImage"
#import "JPUSHService.h"

NSString * const KEY_LOGIN_USERINFO = @"ZZLoginUserInfo";
NSString * const KEY_LOGIN_USERNAME = @"ZZLoginUserName";
NSString * const KEY_LOGIN_USERPWD = @"ZZLoginUserPwd";

NSString * const KEY_CONFIG_KNTYPE = @"ZZConfigknType";
NSString * const KEY_CONFIG_TITLE = @"ZZConfigtitle";
NSString * const KEY_CONFIG_REGION = @"ZZConfigregion";
NSString * const KEY_CONFIG_DCLABEL = @"ZZConfigdcLable";
NSString * const KEY_CONFIG_DEPARTMENT = @"ZZConfigdepartment";
NSString * const KEY_CONFIG_HSLEVEL = @"ZZConfighsLevel";
NSString * const KEY_CONFIG_TC = @"ZZConfigtc";


NSString * const KEY_SEARCH_KEYWORD = @"ZZSearchKeyword";


@interface ZZDataCache(){
    
}

@property(nonatomic,strong) ZZUserInfo *loginUserInfo;
@property(nonatomic,strong) NSMutableDictionary *configDict;

@end

@implementation ZZDataCache

+(ZZDataCache *) getInstance{
    static ZZDataCache *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil){
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}


-(ZZUserInfo *)getLoginUser{
//    NSLog(@"-----%@",_loginUserInfo);
    if(!_loginUserInfo){
        NSDictionary *loginInfo = [ZCLocalStore getLocalDictionary:KEY_LOGIN_USERINFO];
        if(!is_null(loginInfo)){
            _loginUserInfo = [[ZZUserInfo alloc] initWithMyDict:loginInfo];
        }
    }
    return _loginUserInfo;
}
-(void)changeUserInfo:(ZZUserInfo *) info{
    if(info.thirdId == nil){
        info.thirdId = @"";
    }
    _loginUserInfo = info;
    if(_loginUserInfo){
        NSDictionary *changeDict = [ZCLocalStore getObjectData:_loginUserInfo];
        [ZCLocalStore addObject:changeDict forKey:KEY_LOGIN_USERINFO];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZZNoticeUserInfoChanged" object:nil];
    }
    
}


-(BOOL)isLogin{
    [self getLoginUser];
    if(_loginUserInfo && _loginUserInfo.userId>0){
        return YES;
    }
    return NO;
    
}

-(void)loginOut{
    [ZCLocalStore removeObjectforKey:KEY_LOGIN_USERINFO];
    _loginUserInfo = nil;
}





-(void)cleanCache{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    for (NSString *key in dict) {
        if([key hasPrefix:@"ZZKEY"]){
            [userDefaults removeObjectForKey:key];
        }
    }
    [userDefaults synchronize];
    
    // 清理本地存储文件
    dispatch_async(dispatch_queue_create("com.Expert.cache", DISPATCH_QUEUE_SERIAL), ^{
        NSFileManager *_fileManager = [NSFileManager new];
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:ImageLocalPath];
        
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [ImageLocalPath stringByAppendingPathComponent:fileName];
            // 过期，直接删除
            [_fileManager removeItemAtPath:filePath error:nil];
        }
    });
}


/////////////////////////
-(void)getCacheConfigDict:(void (^)(NSMutableDictionary *, int status))resultBlock{
    if(is_null(_configDict)){
        
        [ZZRequsetInterface get:API_findBaseInfo start:^{
            resultBlock(nil,1);
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            [self setConfigNetworkDict:dict[@"retData"]];
            resultBlock(_configDict,0);
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
             resultBlock(_configDict,2);
        } progress:^(CGFloat progress) {
            
        }];
        
    }else{
        if(resultBlock){
            resultBlock(_configDict,0);
        }
        
    }
}


-(void)setConfigNetworkDict:(NSDictionary *)dict{
    if(dict){
        _configDict = [[NSMutableDictionary alloc] init];
        
        for (NSString *key in dict.allKeys) {
            NSMutableArray *items = [[NSMutableArray alloc] init];
            NSArray *arr= dict[key];
            for (NSDictionary *item in arr) {
                [items addObject:[[ZZDictModel alloc] initWithMyDict:item]];
            }
            [_configDict setObject:items forKey:[NSString stringWithFormat:@"ZZConfig%@",key]];
        }
    }
}

-(NSMutableArray *)getConfigArrByType:(NSString *)KEY_Config{
    if(_configDict && [[_configDict allKeys] containsObject:KEY_Config]){
        return _configDict[KEY_Config];
    }
    return [[NSMutableArray alloc] init];
}



// 执行登录
-(void)saveLoginUserInfo:(NSMutableDictionary *) infoDict view:(UIView *) view{
    [ZCLocalStore addObject:infoDict forKey:KEY_LOGIN_USERINFO];
    ZZUserInfo *info = [[ZZDataCache getInstance] getLoginUser];
    
    if(info){
        UIStoryboard *stryBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        view.window.rootViewController=[stryBoard instantiateInitialViewController];
        
        // 设置别名
        [JPUSHService setAlias:convertIntToString(info.userId) completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            
        } seq:1];
        
        //设置标签
        NSSet * set = [[NSSet alloc] initWithObjects:(info.isDoctor == 1)?@"医生":@"用户",info.phone,convertToString(info.departmentName), nil];
        [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            
        } seq:2];
    }
}

-(void)setSearchKeyword:(NSString *)key{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableDictionary *oldDict = [ZCLocalStore getLocalDictionary:KEY_SEARCH_KEYWORD];
    if(!is_null(oldDict)){
        dict = [NSMutableDictionary dictionaryWithDictionary:oldDict];
    }
    
    [dict setObject:convertToString(key) forKey:convertToString(key)];
    [ZCLocalStore addObject:dict forKey:KEY_SEARCH_KEYWORD];
}

-(NSArray *)getSearchKeyWork{
    NSMutableDictionary *dict = [ZCLocalStore getLocalDictionary:KEY_SEARCH_KEYWORD];
    if(dict && [dict isKindOfClass:[NSDictionary class]]){
        return dict.allKeys;
    }
    return @[];
}

@end
