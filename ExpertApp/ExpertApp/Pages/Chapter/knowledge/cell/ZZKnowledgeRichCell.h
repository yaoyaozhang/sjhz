//
//  ZZKnowledgeRichCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/18.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZKnowledgeTopicModel.h"

@interface ZZKnowledgeRichCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lineView;

@property (weak, nonatomic) IBOutlet UIImageView *imgFaceBackground;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;

@property (weak, nonatomic) IBOutlet UILabel *labAuthor;

-(void)dataToItem:(ZZKnowledgeTopicModel *) model;
@end
