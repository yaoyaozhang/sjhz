//
//  ZZFansCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/28.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonUpDown.h"

@protocol ZZFansCellDelegate <NSObject>

-(void)onFansCellClick:(NSDictionary *) item;

@end

@interface ZZFansCell : UITableViewCell

@property (strong, nonatomic) id<ZZFansCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labMessage;
@property (weak, nonatomic) IBOutlet UIButtonUpDown *btnAction;

@end
