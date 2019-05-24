//
//  ZZAcountInfoCell.h
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZAcountInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labDesc;

-(void)dataToView:(NSDictionary *) item;

@end

NS_ASSUME_NONNULL_END
