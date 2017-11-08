//
//  ZZRemarkCaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRemakBaseCell.h"

@interface ZZRemarkCaseCell : ZZRemakBaseCell

@property (weak, nonatomic) IBOutlet UIView *caseViews;

@property (strong, nonatomic) NSArray *cases;
@end
