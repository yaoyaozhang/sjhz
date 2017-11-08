//
//  ZZBasicCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRemakBaseCell.h"

@interface ZZBasicCell : ZZRemakBaseCell

@property (weak, nonatomic) IBOutlet UILabel *labMsg;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
