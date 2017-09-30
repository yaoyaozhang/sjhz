//
//  ZZDoctorHeaderCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserHomeModel.h"

@interface ZZDoctorHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;

@property (weak, nonatomic) IBOutlet UIView *viewZhic;

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labKes;
@property (weak, nonatomic) IBOutlet UILabel *labHospital;

@property (weak, nonatomic) IBOutlet UILabel *labDesc;


-(void) dataToView:(ZZUserHomeModel *) model;

@end
