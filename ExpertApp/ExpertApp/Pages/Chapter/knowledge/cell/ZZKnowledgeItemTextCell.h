//
//  ZZKnowledgeItemTextCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterModel.h"

@interface ZZKnowledgeItemTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labTime;


-(void)dataToView:(ZZChapterModel *) item;

@end
