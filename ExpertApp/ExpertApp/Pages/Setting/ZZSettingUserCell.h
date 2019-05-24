//
//  ZZSettingUserCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZSettingUserCellDelegate <NSObject>

-(void)onCellClick:(NSString *) tag;

@end

@interface ZZSettingUserCell : UITableViewCell
@property (weak, nonatomic)  id<ZZSettingUserCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *labelQuestionNum;

@property (weak, nonatomic) IBOutlet UILabel *labelUname;

@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnJifen;



-(void)dataToView:(NSDictionary *)dict;

@end
