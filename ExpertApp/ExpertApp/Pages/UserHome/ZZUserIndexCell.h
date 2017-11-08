//
//  ZZUserIndexCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZUserHomeModel.h"

@protocol ZZUserIndexCellDelegate <NSObject>

-(void)onUserIndexCellClick:(NSInteger ) tag model:(ZZUserHomeModel *) model;

@end

@interface ZZUserIndexCell : UITableViewCell


@property(nonatomic,weak) id<ZZUserIndexCellDelegate> delegate;


@property(nonatomic,strong) ZZUserHomeModel *tempModel;

@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *viewChapter;


@property (weak, nonatomic) IBOutlet UILabel *labName;

@property (weak, nonatomic) IBOutlet UILabel *labKes;

@property (weak, nonatomic) IBOutlet UILabel *labHospital;

@property (weak, nonatomic) IBOutlet UIImageView *imgFace;
@property (weak, nonatomic) IBOutlet UILabel *labChapter;

@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (weak, nonatomic) IBOutlet UIButton *btnComment;

@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@property (weak, nonatomic) IBOutlet UIImageView *imgVideoOrMp3;


-(void)dataToCellView:(ZZUserHomeModel* )model;


@end
