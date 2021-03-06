//
//  ZZShareView.h
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,ZZShareType) {
    ZZShareTypeUser     = 1,
    ZZShareTypeChapter  = 2,
    ZZShareTypeHZResult = 3,
    ZZShareTypeLiangBiao = 4,// 
    ZZShareTypeWenJuan = 5,
    ZZShareTypeKnowledgeDetail = 6, // 精品课
    ZZShareTypeKnowledgeList = 7, // 精品课
    ZZShareTypeUserImage = 8, // 精品课
};



@interface ZZShareView : UIView

/**
 *  必须在selectIndex之前设置
 */
@property (nonatomic, strong) id shareModel;

/**
 *  创建对象方法
 */
- (instancetype)initWithShareType:(ZZShareType ) type vc:(UIViewController *) vc;
- (void)show;

@end

