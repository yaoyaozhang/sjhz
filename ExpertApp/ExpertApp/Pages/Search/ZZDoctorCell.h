//
//  ZZDoctorCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ZZDoctorCellType) {
    ZZDoctorCellTypeDefault = 0,
    ZZDoctorCellTypeStar    = 1,
    ZZDoctorCellTypeDel     = 2,
    ZZDoctorCellTypeCheck   = 3,
};

@protocol ZZDoctorCellDelegate <NSObject>

-(void)onDoctorCellClick:(ZZDoctorCellType ) type model:(ZZUserInfo *) model;

@end

@interface ZZDoctorCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;


@property (weak, nonatomic) IBOutlet UILabel *labelName;


@property (weak, nonatomic) IBOutlet UILabel *labelNameZhiWei;

@property (weak, nonatomic) IBOutlet UILabel *labelHosptial;

@property (weak, nonatomic) IBOutlet UILabel *labelSC;


@property (weak, nonatomic) IBOutlet UIView *viewLabels;

@property (weak, nonatomic) IBOutlet UIButton *btnControl;

@property(nonatomic,assign) ZZDoctorCellType cellType;
@property(nonatomic,strong) ZZUserInfo *tempModel;
@property(nonatomic,strong) id<ZZDoctorCellDelegate> delegate;


-(void)dataToView:(ZZUserInfo *)model;

@end
