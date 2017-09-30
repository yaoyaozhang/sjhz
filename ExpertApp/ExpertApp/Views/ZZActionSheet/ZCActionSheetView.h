//
//  ZCActionSheet.h
//  wash
//
//  Created by lizhihui on 15/10/21.
//
//

#import <UIKit/UIKit.h>

@class ZCActionSheetView;

@protocol ZCActionSheetViewDelegate <NSObject>

@optional

/**
 *  点击按钮
 */
- (void)actionSheet:(ZCActionSheetView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface ZCActionSheetView : UIView

/**
 *  代理
 */
@property (nonatomic, weak  ) id <ZCActionSheetViewDelegate> delegate;

/**
 *  必须在selectIndex之前设置
 */
@property (nonatomic, strong) UIColor                    *selectColor;
@property (nonatomic, assign) int                        selectIndex;

/**
 *  创建对象方法
 */
- (instancetype)initWithDelegate:(id<ZCActionSheetViewDelegate>)delegate title:(NSString *)titleMessage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString*)otherTitles,... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
