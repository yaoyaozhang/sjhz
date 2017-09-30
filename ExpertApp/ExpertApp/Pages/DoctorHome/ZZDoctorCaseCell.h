//
//  ZZDoctorCaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZHZEngity.h"

@protocol ZZDoctorCaseDelegate <NSObject>


/**
 

 @param model
 @param type 0,删除，1状态点击,2病例，3结果
 */
-(void)onDelegateDel:(ZZHZEngity *) model type:(int) type;

@end

typedef NS_ENUM(NSInteger,ZZHZCellType) {
    ZZHZCellTypeDefault = 0,
    ZZHZCellTypeHome = 1,
    ZZHZCellTypeUserHistory = 2,
    ZZHZCellTypeHZHistory = 3,
};

@interface ZZDoctorCaseCell : UITableViewCell

@property(nonatomic,assign) ZZHZCellType cellType;

@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgInto;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labCaseName;

@property (weak, nonatomic) IBOutlet UILabel *labDesc;

@property (weak, nonatomic) IBOutlet UILabel *labStyle;

@property (weak, nonatomic) IBOutlet UIButton *btnDel;

@property (weak, nonatomic) IBOutlet UIButton *btnCase;
@property (weak, nonatomic) IBOutlet UIButton *btnHZResult;


@property(nonatomic,strong) id<ZZDoctorCaseDelegate> delegate;
@property(nonatomic,strong) ZZHZEngity *tempModel;


-(void)dataToView:(ZZHZEngity *) model;

@end
