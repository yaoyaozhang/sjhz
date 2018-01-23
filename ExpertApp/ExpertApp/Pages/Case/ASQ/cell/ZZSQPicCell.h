//
//  ZZSQPicCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/22.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSQBaseCell.h"

@interface ZZSQPicCell : ZZSQBaseCell

@property (assign, nonatomic) BOOL isDetail;

@property (weak, nonatomic) IBOutlet UIScrollView *imgsScroll;

@end
