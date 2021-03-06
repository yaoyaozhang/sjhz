//
//  ZZFriendUserCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/10/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButtonUpDown.h"
#import "ZZFollowMessageModel.h"
typedef NS_ENUM(NSInteger,ZZUserFriendCellType) {
    ZZUserFriendCellTypeDefault = 0,
    ZZUserFriendCellTypeChanged = 2,
};

@protocol ZZUserFriendCellDelegate <NSObject>

-(void)onDoctorCellClick:(ZZUserFriendCellType ) type model:(ZZUserInfo *) model;

-(void)onChangedMessage:(ZZUserFriendCellType ) type model:(ZZUserInfo *) model;

@end


@interface ZZFriendUserCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;


@property (weak, nonatomic) IBOutlet UILabel *labelHosptial;

@property (weak, nonatomic) IBOutlet UIButtonUpDown *btnControl;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;


@property (weak, nonatomic) IBOutlet UIView *viewChat;


@property(nonatomic,assign) ZZUserFriendCellType cellType;
@property(nonatomic,strong) ZZUserInfo *tempModel;
@property(nonatomic,strong) id<ZZUserFriendCellDelegate> delegate;


-(void)dataToView:(ZZUserInfo *)model;


@end
