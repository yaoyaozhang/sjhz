//
//  BaeController.m
//  ExpertApp
//
//  Created by 张新耀 on 15/8/31.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import "BaseController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UMMobClick/MobClick.h>
#import "ZZGlobalDefine.h"
#import "ZZFontColorDefine.h"
#import "MyButton.h"
#import "UIImage+ImageWithColor.h"

@interface BaseController ()


@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if(iOS7){
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(NSMutableAttributedString *)getOtherColorString:(NSString *)string Color:(UIColor *)Color withString:(NSString *)originalString
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    NSMutableString *temp = [NSMutableString stringWithString:originalString];
    str = [[NSMutableAttributedString alloc] initWithString:temp];
    if (string.length) {
        NSRange range = [temp rangeOfString:string];
        [str addAttribute:NSForegroundColorAttributeName value:Color range:range];
        return str;
        
    }
    return str;
    
}




-(void)createTitleMenu{
    self.titleMenu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavBarHeight)];
    [self.titleMenu setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [self.titleMenu setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.titleMenu];
    
    
    self.menuTitleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuTitleButton setFrame:CGRectMake(60, StatusBarHeight, ScreenWidth-120, 44)];
    [self.menuTitleButton setBackgroundColor:[UIColor clearColor]];
    [self.menuTitleButton.titleLabel setFont:TitleFont];
    [self.menuTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.menuTitleButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.titleMenu addSubview:self.menuTitleButton];
    
    
    self.menuLeftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuLeftButton setFrame:CGRectMake(0, StatusBarHeight, 64, 44)];
    self.menuLeftButton.tag=BACK_BUTTON;
    [self.menuLeftButton.titleLabel setFont:ListTitleFont];
    [self.menuLeftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuLeftButton setTitleColor:UIColorFromRGBAlpha(TextWhiteColor, 0.7) forState:UIControlStateHighlighted];
    [self.menuLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuLeftButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuLeftButton setImage:[UIImage imageNamed:@"titlebar_back_normal"] forState:UIControlStateNormal];
    [self.menuLeftButton setImage:[UIImage imageNamed:@"titlebar_back_pressed"] forState:UIControlStateHighlighted];
    [self.menuLeftButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.menuLeftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.menuLeftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.titleMenu addSubview:self.menuLeftButton];
    
    self.menuRightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuRightButton setFrame:CGRectMake(ScreenWidth-64, StatusBarHeight, 64, 44)];
    self.menuRightButton.tag=RIGHT_BUTTON;
    [self.menuRightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.menuRightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.menuRightButton.titleLabel setFont:ListTitleFont];
    [self.menuRightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuRightButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.menuRightButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.menuRightButton setImage:[UIImage imageNamed:@"setting_nor"] forState:UIControlStateNormal];
    [self.menuRightButton setImage:[UIImage imageNamed:@"setting_sel"] forState:UIControlStateHighlighted];
    [self.menuRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.menuRightButton setTitleColor:UIColorFromRGBAlpha(TextWhiteColor, 0.7) forState:UIControlStateHighlighted];
    [self.menuRightButton setTitleColor:UIColorFromRGBAlpha(TextWhiteColor, 0.7) forState:UIControlStateDisabled];
    [self.menuRightButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    [self.titleMenu addSubview:self.menuRightButton];
    
    self.otherButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherButton setFrame:CGRectMake(self.view.frame.size.width-88, StatusBarHeight , 44, 44)];
    self.otherButton.tag=OTHER_BUTTON;
    [self.otherButton.titleLabel setFont:ListTitleFont];
    [self.otherButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.otherButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self.otherButton setImage:[UIImage imageNamed:@"setting_nor"] forState:UIControlStateNormal];
    [self.otherButton setImage:[UIImage imageNamed:@"setting_sel"] forState:UIControlStateHighlighted];
    [self.otherButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [self.titleMenu addSubview:self.otherButton];
    self.otherButton.hidden=YES;
}




-(IBAction)openWithPresent:(UIViewController *)controller animated:(BOOL) anmated{
    //    SystemSoundID soundID;
    //    NSURL *filePath   = [[NSBundle mainBundle] URLForResource:@"open" withExtension: @"m4a"];
    //    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    //
    //    AudioServicesPlaySystemSound(soundID);
    
    [self presentViewController:controller animated:anmated completion:^{
        
    }];
}

-(IBAction)openNav:(UIViewController *)controller sound:(NSString *)soundName{
    if(soundName!=nil && ![@"" isEqual:soundName]){
        SystemSoundID soundID;
        NSURL *filePath   = [[NSBundle mainBundle] URLForResource:@"open" withExtension: @"m4a"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        
        AudioServicesPlaySystemSound(soundID);
    }
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)playerSoundWith:(NSString *)soundName{
    SystemSoundID soundID;
    NSURL *filePath   = [[NSBundle mainBundle] URLForResource:soundName withExtension: @"m4a"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
}

-(IBAction)goBack:(id)sender{
    [SVProgressHUD dismiss];
    
    if(self.navigationController!=nil){
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                //push方式
                [self.navigationController popViewControllerAnimated:YES];
                
                return;
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)buttonClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==BACK_BUTTON){
        [self goBack:sender];
    }
    
    
    
}

-(void)beginNetRefreshData{
    
}

-(void)endNetRefreshData{
    
    
}


-(UIView *)showNoticeWithMessage:(NSString *)title message:(NSString *)detail bgColor:(TopNoticeBackColor)colorEnum{
    return  [self showNoticeWithMessage:title message:detail bgColor:colorEnum block:nil];
}

-(UIView *) showNoticeWithMessage:(NSString *)title message:(NSString *)detail bgColor:(TopNoticeBackColor)colorEnum block:(NoticeComplete)finish{
    UIView *showNotice=[[UIView alloc] initWithFrame:CGRectMake(0, -44-StatusBarHeight, self.view.frame.size.width, 44+StatusBarHeight)];
    if(colorEnum==TopNotice_Block_Color){
        [showNotice setBackgroundColor:[UIColor blackColor]];
    }else if(colorEnum==TopNotice_Red_Color){
        [showNotice setBackgroundColor:[UIColor redColor]];
    }
    
    UILabel *label=[[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    
    if(detail==nil ||[@"" isEqual:detail]){
        [label setFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, 44)];
    }else{
        [label setFrame:CGRectMake(0, StatusBarHeight, self.view.frame.size.width, 20)];
        
        UILabel *msgLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 20+StatusBarHeight, self.view.frame.size.width, 20)];
        [msgLabel setBackgroundColor:[UIColor clearColor]];
        [msgLabel setTextColor:[UIColor whiteColor]];
        [msgLabel setFont:[UIFont systemFontOfSize:12]];
        [msgLabel setTextAlignment:NSTextAlignmentCenter];
        [msgLabel setText:detail];
        [showNotice addSubview:msgLabel];
    }
    [showNotice addSubview:label];
    [[[UIApplication sharedApplication]keyWindow]addSubview:showNotice];
    [self animationShowNotice:showNotice block:finish];
    return showNotice;
}


-(void)animationShowNotice:(UIView *) view block:(NoticeComplete) finish{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect cf=view.frame;
        cf.origin.y=0;
        view.frame=cf;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                CGRect cf1=view.frame;
                cf1.origin.y=-44-StatusBarHeight;
                view.frame=cf1;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                if(finish){
                    finish();
                }
            }];
        });
    }];
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [self preferredStatusBarStyle];
    
    [MobClick beginLogPageView:self.description];
    
    //开启ios右滑返回
    if (iOS7) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
        if(self.navigationController!=nil){
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}


- (void)createPlaceholderView:(NSString *)title message:(NSString *)message image:(UIImage *)image withView:(UIView *)superView action:(void (^)(UIButton *button)) clickblock{
    if (_placeholderView) {
        [_placeholderView removeFromSuperview];
        _placeholderView = nil;
    }
    if(superView==nil){
        superView=self.view;
    }
    
    _placeholderView = [[UIView alloc]initWithFrame:superView.bounds];
    
    NSLog(@"%@",NSStringFromCGRect(superView.bounds));
    
    [_placeholderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [_placeholderView setAutoresizesSubviews:YES];
    [_placeholderView setBackgroundColor:[UIColor clearColor]];
    //    [_placeholderView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [superView addSubview:_placeholderView];
    CGFloat y = 0;
    CGRect pf = CGRectMake(0, 0, superView.bounds.size.width, 0);
    if(image){
        UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"robot_default"]];
    
        [icon setImage:image];
    
        [icon setContentMode:UIViewContentModeCenter];
        [icon setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        icon.frame = CGRectMake(0,0, pf.size.width, image.size.height);
        [_placeholderView addSubview:icon];
        y= icon.frame.size.height+20;
    }
    if(title){
        CGFloat height=[ZZCoreTools getHeightContain:title font:ListTitleFont Width:pf.size.width];
        
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, y, pf.size.width, height)];
        [lblTitle setText:title];
        [lblTitle setFont:ListTitleFont];
        [lblTitle setTextColor:UIColorFromRGB(TextSizeFourColor)];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [lblTitle setNumberOfLines:0];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [_placeholderView addSubview:lblTitle];
        y=y+height+5;
    }
    
    if(message){
        UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, y, pf.size.width, 20)];
        [lblTitle setText:message];
        [lblTitle setFont:ListDetailFont];
        [lblTitle setTextColor:UIColorFromRGB(TextSizeNineColor)];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [lblTitle setAutoresizesSubviews:YES];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [_placeholderView addSubview:lblTitle];
        y=y+25;
    }
    
    // 如果有重新加载方法，就显示重新加载按钮
    if(clickblock){
        MyButton *reButton=[MyButton buttonWithType:UIButtonTypeCustom];
        [reButton setFrame:CGRectMake(pf.size.width/2-192/2, y+5, 192, 50)];
        [reButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgTitleColor)] forState:UIControlStateNormal];
        [reButton setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgVCodeColor)] forState:UIControlStateDisabled];
        [reButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [reButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [reButton.titleLabel setFont:ListTitleFont];
        reButton.objTag = clickblock;
        [reButton addTarget:self action:@selector(reloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [reButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        reButton.layer.cornerRadius  = 5;
        reButton.layer.masksToBounds = YES;
        [_placeholderView addSubview:reButton];
        
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.tag=10;
        [activityIndicator setFrame:CGRectMake(192/2-45, 15, 20, 20)];
        [reButton addSubview:activityIndicator];
        
        y=y+60;
    }
    pf.size.height= y;
    
    [_placeholderView setFrame:pf];
    [_placeholderView setCenter:CGPointMake(superView.center.x, superView.bounds.size.height/2-80)];
}


- (void)removePlaceholderView{
    if (_placeholderView && _placeholderView!=nil) {
        [_placeholderView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_placeholderView removeFromSuperview];
        
        _placeholderView = nil;
    }
}

-(UIView *)createTips:(NSString *)tip{
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [tipView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 12, 12)];
    [iconView setImage:[UIImage imageNamed:@"icon_tips"]];
    [iconView setBackgroundColor:[UIColor clearColor]];
    iconView.tag = 1;
    [tipView addSubview:iconView];
    
    
    UILabel *lblTips = [[UILabel alloc] init];
    [lblTips setFont:ListDetailFont];
    [lblTips setTextColor:UIColorFromRGB(BgTitleColor)];
    [lblTips setText:tip];
    [lblTips setNumberOfLines:0];
    [lblTips setBackgroundColor:[UIColor clearColor]];
    [tipView addSubview:lblTips];
    CGFloat height = [ZZCoreTools getHeightContain:tip font:ListDetailFont Width:ScreenWidth-45];
    if(height<20){
        height = 20;
    }
    [lblTips setFrame:CGRectMake(30, 9, ScreenWidth-45, height)];
    
    [tipView setFrame:CGRectMake(0, 0, ScreenWidth, height + 12)];
    
    return tipView;
}

-(void)reloadButtonClick:(MyButton *)btn{
    [btn setTitle:@"      加载中..." forState:UIControlStateNormal];
    // 变灰
    //    [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(BgVCodeColor)] forState:UIControlStateDisabled];
    
    UIActivityIndicatorView *activityIndicator = [btn viewWithTag:10];
    [activityIndicator startAnimating];
    ((void (^)(UIButton *button))btn.objTag)(btn);
}

-(ZZUserInfo *)getLoginUser{
    return [[ZZDataCache getInstance] getLoginUser];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)dealloc{
    //移除消息监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.description];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
