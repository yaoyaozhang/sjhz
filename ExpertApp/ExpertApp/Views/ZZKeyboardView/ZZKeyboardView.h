//
//  ZZKeyboardView.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZChapterModel.h"
#import "ZZChapterCommentModel.h"

#define ZZCommentKeyboardHeight 40

@interface ZZKeyboardView : UIView

@property(nonatomic,strong) ZZChapterModel *chatpterModel;
@property(nonatomic,strong) NSString *nid;


-(instancetype)initWithDelegate:(UIViewController *) delegate changeView:(UIScrollView *) changeView show:(BOOL) isShowKeyboard;


-(void)hideKeyboard;


-(void)setReplyModel:(ZZChapterCommentModel *) model;

@end
