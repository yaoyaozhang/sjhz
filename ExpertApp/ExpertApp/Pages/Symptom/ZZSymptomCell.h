//
//  ZZSymptomCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSymptomModel.h"
#import "ZZSymptomView.h"

@interface ZZSymptomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (strong, nonatomic) ZZSymptomView *symptomView;

-(void)dataToView:(NSString *) title data:(NSMutableArray *) arr;

@end
