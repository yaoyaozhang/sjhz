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


@protocol ZZSymptomCellDelegate <NSObject>


/**
 
 
 @param model
 @param type 1,删除，2编辑 
 */
-(void)onItemClick:(ZZSymptomModel *) model type:(int) type index:(int  ) index;

@end

@interface ZZSymptomCell : UITableViewCell

@property(nonatomic,assign)id<ZZSymptomCellDelegate> delegate;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *bgView;

@property (strong, nonatomic) ZZSymptomView *symptomView;

-(void)dataToView:(NSString *) title data:(NSMutableDictionary *) data;

@end
