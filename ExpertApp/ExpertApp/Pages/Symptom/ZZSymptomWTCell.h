//
//  ZZSymptomWTCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSymptomModel.h"

@protocol ZZSymptomWTCellDelegate <NSObject>


/**WT
 
 
 @param model
 @param 
 */
-(void)onItemClick:(ZZSymptomWTModel *) model text:(NSString *) text check:(BOOL) isChecked;

@end
@interface ZZSymptomWTCell : UITableViewCell

@property(nonatomic,assign) CGFloat pwidth;
@property(nonatomic,strong) UILabel *tempLabel;
@property(nonatomic,strong) ZZSymptomWTModel *tempModel;
@property(nonatomic,strong)id<ZZSymptomWTCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabe;

@property (weak, nonatomic) IBOutlet UIView *chooseView;


-(void)dataToView:(ZZSymptomWTModel *) model check:(NSMutableDictionary *) checkItem;

@end
