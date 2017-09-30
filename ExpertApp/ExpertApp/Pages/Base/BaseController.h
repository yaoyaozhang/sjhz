//
//  BaeController.h
//  ExpertApp
//
//  Created by 张新耀 on 15/8/31.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @enum
 @abstract  页面公用点击
 @constant  BACK_BUTTON，顶部左上角按钮tag
 @constant  RIGHT_BUTTON，顶部右上角按钮tag
 @constant  ...
 */
typedef NS_ENUM(NSInteger, MenuButtonTag) {
    BACK_BUTTON=1,
    RIGHT_BUTTON=2,
    OTHER_BUTTON=3,
    DOWN_BTNTAG1=4,
    DOWN_BTNTAG2=5,
    DOWN_BTNTAG3=6,
};

//提示层颜色
typedef NS_ENUM(NSInteger, TopNoticeBackColor) {
    TopNotice_Red_Color=1,
    TopNotice_Block_Color=2,
};


typedef void(^NoticeComplete)();


//*********************属性说明**********************************
//如果用的是自定义的View当做NavigationBar，创建的是上面的menuLeftButton，
//如何是在系统的原生的导航栏上自定义，用的是下面的leftBarItem
@interface BaseController : UIViewController

@property(nonatomic,retain)UIView *titleMenu;

@property(nonatomic,retain)UIButton *menuTitleButton;
@property(nonatomic,retain)UIButton *menuLeftButton;
@property(nonatomic,retain)UIButton *menuRightButton;
@property(nonatomic,retain)UIButton *otherButton;



//当页面的list数据为空时，给它一个带提示的占位图。
@property(nonatomic,strong)UIView *placeholderView;


////////////////////////////////////////////////////////////////////////////////



/**
 *  加载数据方法
 */
-(void)beginNetRefreshData;

-(void)endNetRefreshData;



/**
 * 创建顶部导航
 * menuTitleButton; 中间标题
 * menuLeftButton;  左边返回
 * menuRightButton; 右边按钮
 * otherButton;     右边按钮
 *
 */
-(void)createTitleMenu;


//////////////////////////////////////////////////////////////////
/**
 * 打开新的页面
 * soundName，声音名字，如果open.m4a,传递open
 */
-(IBAction)openNav:(UIViewController *) controller sound:(NSString *)soundName;

/**
 *  使用Present方式打开
 *
 *  @param controller 
 */
-(IBAction)openWithPresent:(UIViewController *)controller animated:(BOOL) anmated;

/**
 * 播放声音
 * soundName，声音名字，如果open.m4a,传递open
 */
-(void)playerSoundWith:(NSString *)soundName;
//////////////////////////////////////////////////////////////////

/**
 * button 点击
 * MenuButtonTag tag 枚举值
 */
-(IBAction)buttonClick:(id)sender;

/**
 * 返回上一页
 */
-(IBAction)goBack:(id)sender;



/**
 *  当页面的list数据为空时，需要创建一个占位视图
 *
 *  @param title  占位视图上面的提示文字[标题]
 *  @param message 占位视图上面的提示文字
 *  @param superView 显示在那个view上，如果nil，就显示在self.view
 */



/**
 *  移除占位视图
 */
//- (void)removePlaceholderView;


/**
 * 下滑提示框
 *  title，提示的标题
 *  detail 如果没有，直接传nil
 * 枚举直接选择
 */
-(UIView *)showNoticeWithMessage:(NSString *)title message:(NSString *) detail bgColor:(TopNoticeBackColor) colorEnum;
-(UIView *)showNoticeWithMessage:(NSString *)title message:(NSString *) detail bgColor:(TopNoticeBackColor) colorEnum block:(NoticeComplete) finish;


/**
 *  当页面的list数据为空时，需要创建一个占位视图
 *
 *  @param title  占位视图上面的提示文字[标题]
 *  @param message 占位视图上面的提示文字
 *  @param superView 显示在那个view上，如果nil，就显示在self.view
 */
- (void)createPlaceholderView:(NSString *) title
                      message:(NSString *)message
                        image:(UIImage *)image
                     withView:(UIView *)superView
                       action:(void (^)(UIButton *button)) clickblock;

/**
 *  移除提醒视图
 */
- (void)removePlaceholderView;


-(UIView *)createTips:(NSString *)tip;

-(ZZUserInfo *) getLoginUser;

@end
