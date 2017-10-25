//
//  ZZChapterTVC.h
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZChapterTVC : UITableViewController

@property(nonatomic,assign) int docId;

@property (nonatomic, copy) NSString *newsType;

@property(nonatomic,strong) id preVC;

@end
