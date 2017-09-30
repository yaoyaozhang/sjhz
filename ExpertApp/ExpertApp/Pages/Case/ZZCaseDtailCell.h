//
//  ZZCaseDtailCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCaseDetailBaseCell.h"

@interface ZZCaseDtailCell : ZZCaseDetailBaseCell


@property (weak, nonatomic) IBOutlet UILabel *labTag;

@property (weak, nonatomic) IBOutlet UILabel *labValue;

@property (weak, nonatomic) IBOutlet UILabel *labUnit;

@end
