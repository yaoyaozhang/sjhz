//
//  ZZFollowMessageModel.h
//  ExpertApp
//
//  Created by mac on 2019/1/18.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZFollowMessageModel : ZZBaseModel

@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *frUserId;
@property(nonatomic,strong) NSString *toUserName;
@property(nonatomic,strong) NSString *context;
@property(nonatomic,strong) NSString *toUserId;

@end

NS_ASSUME_NONNULL_END
