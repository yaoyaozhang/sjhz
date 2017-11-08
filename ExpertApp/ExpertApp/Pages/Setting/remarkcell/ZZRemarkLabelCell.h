//
//  ZZRemarkLabelCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZRemakBaseCell.h"

@interface ZZRemarkLabelCell : ZZRemakBaseCell

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;

@property (weak, nonatomic) IBOutlet UIView *viewLabels;

@property (strong, nonatomic) NSString *labText;



@end
