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


@protocol ZZSymptomViewDelegate <NSObject>


/**
 
 
 @param model
 @param type 0,删除，1状态点击,2病例，3结果
 */
-(void)onItemClick:(id) model type:(int) type index:(int  ) index;

@end

@interface ZZSymptomView : UIView<UIScrollViewDelegate>
{
    UIScrollView *faceView;
    
    UIPageControl *facePageControl;
}
@property(nonatomic,assign) id<ZZSymptomViewDelegate> delegate;

-(id)initZZSymptomView;



-(void) setItemValues:(NSMutableDictionary *) itemMap block:(void(^)(ZCSymptomAction action,int index,id obj)) symptomActionBlock;

@end
