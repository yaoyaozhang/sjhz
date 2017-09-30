//
//  ZZCreateCaseMulCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCreateCaseBaseCell.h"
#import "ZCTextPlaceholderView.h"

@interface ZZCreateCaseMulCell : ZZCreateCaseBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *imgRequired;
@property (weak, nonatomic) IBOutlet UILabel *labTagName;

@property (weak, nonatomic) IBOutlet ZCTextPlaceholderView *textViewCase;

@end
