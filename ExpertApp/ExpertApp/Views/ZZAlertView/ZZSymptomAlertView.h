//
//  ZZSymptomAlertView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/25.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZBaseAlertView.h"

@interface ZZSymptomAlertView : ZZBaseAlertView


-(instancetype)initWithTitle:(NSString *)title dict:(NSDictionary *)item cancel:(NSString *)cancel comfirm:(NSString *)text;


@end
