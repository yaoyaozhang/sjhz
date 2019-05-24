//
//  ZZAcountTypeCell.h
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZAcountTypeCellDelegate <NSObject>

/**
 * 点击充值事件
 */
- (void)onCellItemClick:(id) sender;

@end


NS_ASSUME_NONNULL_BEGIN

@interface ZZAcountTypeCell : UITableViewCell


@property(nonatomic,strong) id<ZZAcountTypeCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgCheck;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labCurIntegral;

@property (weak, nonatomic) IBOutlet UILabel *labTips;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;


-(void)dataToView:(NSDictionary *) item;

@end

NS_ASSUME_NONNULL_END
