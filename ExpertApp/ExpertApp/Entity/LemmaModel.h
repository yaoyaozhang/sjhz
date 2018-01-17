//
//  LemmaModel.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/16.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseModel.h"

@interface LemmaModel : ZZBaseModel


@property(nonatomic,strong)  NSString *lemmaId;
@property(nonatomic,strong)  NSString *lemmaTitle;
@property(nonatomic,strong)  NSString *lemmaCroppedTitle;
@property(nonatomic,strong)  NSString *lemmaDesc;
@property(nonatomic,strong)  NSString *lemmaPic;
@property(nonatomic,strong)  NSString *lemmaUrl;

@end
