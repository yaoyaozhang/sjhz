//
//  ZZIntegralCell.h
//  ExpertApp
//
//  Created by zhangxy on 2019/1/10.
//  Copyright © 2019 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZIntegralCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labIntegral;


-(void)dataToView:(NSDictionary *) item;

@end

NS_ASSUME_NONNULL_END
