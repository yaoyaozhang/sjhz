//
//  ZZEditUserCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZUserEditDelegate <NSObject>

-(void)onEditCellClick:(NSString *) tag;

@end

@interface ZZEditUserCell : UITableViewCell

@property(weak,nonatomic) id<ZZUserEditDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDesc;

@property (weak, nonatomic) IBOutlet UIButton *btnBD;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UIImageView *imgInto;

-(void)initToDictView:(NSDictionary *)dict info:(ZZUserInfo *) loginUser;

@end
