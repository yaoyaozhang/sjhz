//
//  ZZCreateCaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCreateCaseBaseCell.h"

@interface ZZCreateCaseCell : ZZCreateCaseBaseCell

@property (weak, nonatomic) IBOutlet UILabel *labTagName;
@property (weak, nonatomic) IBOutlet UIImageView *imgRequired;

@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;


@property (weak, nonatomic) IBOutlet UILabel *labUnit;

@property (weak, nonatomic) IBOutlet UIButton *btnControl;

@property (weak, nonatomic) IBOutlet UIButton *btnMan;

@property (weak, nonatomic) IBOutlet UIButton *btnWoman;

@property (weak, nonatomic) IBOutlet UILabel *labMan;
@property (weak, nonatomic) IBOutlet UILabel *labWoman;
@property (weak, nonatomic) IBOutlet UIImageView *imgDrop;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;


@property (weak, nonatomic) IBOutlet UIImageView *imgLook;


@end
