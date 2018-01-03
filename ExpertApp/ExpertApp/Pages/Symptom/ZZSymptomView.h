//
//  ZZSymptomView.h
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,ZCSymptomAction) {
    ZCSymptomActionDel    = 1,
    ZCSymptomActionEiit   = 2,
};



@interface ZZSymptomView : UIView<UIScrollViewDelegate>
{
    UIScrollView *faceView;
    
    UIPageControl *facePageControl;
    
    NSArray *_faceMap;
}


-(id)initZZSymptomView;

-(void) setItemValues:(NSMutableArray *) arrs block:(void(^)(ZCSymptomAction action,NSString *text,id obj)) symptomActionBlock;

@end
