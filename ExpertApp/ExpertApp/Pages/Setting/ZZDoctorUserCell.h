//
//  ZZDoctorUserCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZDoctorUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelKS;
@property (weak, nonatomic) IBOutlet UILabel *labelHispital;
@property (weak, nonatomic) IBOutlet UIButton *btnAttientioon;

@end
