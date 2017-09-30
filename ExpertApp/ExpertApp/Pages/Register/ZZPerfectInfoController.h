//
//  ZZPerfectInfoController.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/17.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "BaseController.h"

@interface ZZPerfectInfoController : BaseController


@property (assign, nonatomic) BOOL isEdit;

@property (strong, nonatomic) NSMutableDictionary *params;


@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIButton *btnCommit;

@end
