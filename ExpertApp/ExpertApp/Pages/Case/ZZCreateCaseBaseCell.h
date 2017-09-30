//
//  ZZCreateCaseBaseCell.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZCaseModel.h"
#import "ZZSportCaseEntity.h"
#import "ZCTextPlaceholderView.h"


@protocol ZZCreateCaseDeleate <NSObject>

-(void)onCaseValueChanged:(id ) changeModel type:(ZZEditControlType ) type dict:(NSDictionary *) item obj:(id) object;

-(void)didKeyboardWillShow:(NSIndexPath *)indexPath view1:(ZCTextPlaceholderView *)textview view2:(UITextField *)textField view3:(UITextField *) ttextfield2;

@end

@interface ZZCreateCaseBaseCell : UITableViewCell

@property(nonatomic,strong) id<ZZCreateCaseDeleate> delegate;

@property(nonatomic,strong) id tempModel;
@property(nonatomic,strong) NSDictionary *tempDict;
@property(nonatomic,strong) NSIndexPath *indexPath;

-(void)dataToView:(NSDictionary *) item;

@end
