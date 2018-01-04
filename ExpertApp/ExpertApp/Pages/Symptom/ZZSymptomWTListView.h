//
//  ZZSymptomWTListView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSymptomModel.h"

@interface ZZSymptomWTListView : UIView

-(instancetype)initWithSymptomView:(ZZSymptomModel *) model arr:(NSMutableArray *) data  check:(NSMutableDictionary *) checkMap block:(void(^)(int type,id obj)) symptomWtBlock;


- (void)dissmisMenu;


-(void)show;

@end
