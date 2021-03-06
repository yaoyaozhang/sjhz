//
//  ZZKnowledgeItemTextCell.h
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterModel.h"
#import "ZZKnowledgeCellDelegate.h"


@interface ZZKnowledgeItemTextCell : UITableViewCell

@property (strong, nonatomic) ZZChapterModel *tempModel;

@property (strong, nonatomic) id<ZZKnowledgeItemsCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgLine;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (weak, nonatomic) IBOutlet UILabel *labTime;


-(void)dataToView:(ZZChapterModel *) item;

-(IBAction)messageClick:(id)sender;

-(IBAction)moreClick:(id)sender;

@end
