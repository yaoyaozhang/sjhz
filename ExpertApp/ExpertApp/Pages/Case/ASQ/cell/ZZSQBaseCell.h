//
//  ZZSQBaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZQSModel.h"

@protocol ZZSQBaseCellDelegate

// 1 单选 2多选 3文本,4添加图片，5删除图片
-(ZZQSModel *)onCellClick:(id) obj type:(int) type with:(ZZQSModel *) questModel;

-(void)didKeyboardWillShow:(NSIndexPath *)indexPath view:(UITextField *) textfield;
@end

@interface ZZSQBaseCell : UITableViewCell

@property(nonatomic,strong) id<ZZSQBaseCellDelegate> delegate;


// 0 可编辑， 1不可编辑
@property (assign, nonatomic) int showType;



@property (strong, nonatomic) UILabel *labTitle;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) ZZQSModel *tempModel;

-(void)dataToView:(ZZQSModel *) model;



- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )height;

- (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )height;

@end
