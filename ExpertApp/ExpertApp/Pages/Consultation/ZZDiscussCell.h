//
//  ZZDiscussCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/20.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCaseTalkModel.h"

@interface ZZDiscussCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labMessage;


-(void) dataToView:(ZZCaseTalkModel *) model;

@end
