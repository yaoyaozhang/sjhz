//
//  ZZNewsCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZNewsModel.h"

@interface ZZNewsCell : UITableViewCell

-(void)dataToView:(NSIndexPath *) indexPath model:(ZZNewsModel *) model;

@end
