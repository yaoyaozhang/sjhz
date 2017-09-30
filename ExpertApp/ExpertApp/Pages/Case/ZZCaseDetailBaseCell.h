//
//  ZZCaseDetailBaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCaseModel.h"
#import "ZZSportCaseEntity.h"

@interface ZZCaseDetailBaseCell : UITableViewCell

-(void)dataToView:(NSDictionary *) item;

@end
