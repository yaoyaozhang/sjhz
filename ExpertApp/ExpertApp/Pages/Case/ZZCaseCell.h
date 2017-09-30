//
//  ZZCaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZCaseCellDelegate <NSObject>

// 1 删除，2 选择
-(void)onCaseCellItemOnClick:(int) type index:(NSIndexPath *) indexPath;

@end

@interface ZZCaseCell : UITableViewCell

@property(weak,nonatomic) id<ZZCaseCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (weak, nonatomic) IBOutlet UILabel *caseLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (strong, nonatomic) NSIndexPath *curIndexPath;

@property(nonatomic,assign) BOOL isChecked;



-(void)dataToView:(NSDictionary *) item;

@end
