//
//  ZZDoctorArchivesController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/16.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorArchivesController.h"
#import "ZCTextPlaceholderView.h"

@interface ZZDoctorArchivesController (){
    CGSize        contentSize;// 记录list的偏移量
    
    UIButton *checkButton;
    
    UITapGestureRecognizer *tapRecognizer;
    
    NSString *desc1;
    NSString *desc2;
    ZZUserInfo *loginUser;
    
    CGFloat keyboardHeight;
    
    
}
@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong)UIView           *headerView;
@property(nonatomic,strong)UIView           *bottomView;

@property(nonatomic,strong)UIView           *contentView;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)ZCTextPlaceholderView   *textView1;
@property(nonatomic,strong)ZCTextPlaceholderView   *textView2;
@property(nonatomic,strong)ZCTextPlaceholderView   *textView3;

@end

@implementation ZZDoctorArchivesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
    [_mainScroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_mainScroll];
    
    [self createTitleMenu];
    self.menuRightButton.hidden = YES;
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    _listArray = [[NSMutableArray alloc] init];
    [_listArray addObjectsFromArray:@[@"医学背景介绍",@"学术研究成果",@"医生寄语"]];
    
    
    
    [self.menuTitleButton setTitle:@"我的档案" forState:UIControlStateNormal];
    
    [_mainScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - NavBarHeight)];
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.alwaysBounceHorizontal = NO;
    _mainScroll.alwaysBounceVertical = NO;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.bounces = NO;
    _mainScroll.scrollEnabled = NO;
    
    [self createInitView:1];
    [self createInitView:2];
    [self createInitView:3];
    
    [_mainScroll setContentSize:CGSizeMake(ScreenWidth, 390)];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == 111){
        NSString *v1 = _textView1.text;
        NSString *v2 = _textView2.text;
        NSString *v3 = _textView3.text;
        
        // 提交
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertToString(v1) forKey:@"v1"];
        [dict setObject:convertToString(v2) forKey:@"v1"];
        [dict setObject:convertToString(v3) forKey:@"v1"];
        [ZZRequsetInterface post:API_Register param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }
}


-(void)createInitView:(int ) tag{
    CGFloat y = 0;
    if(tag == 1){
        y = 0;
    }else if(tag == 2){
        y = 130;
    }else if(tag == 3){
        y = 260;
    }
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth -30, 30 )];
    [labText setText:_listArray[tag - 1]];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40,ScreenWidth, 90)];
    [bgView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_contentView addSubview:bgView];
    
    
    ZCTextPlaceholderView *_textView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, y + 55, ScreenWidth - 30, 60)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setTextColor:UIColorFromRGB(TextBlackColor)];
    [_textView setFont:ListTitleFont];
    [_contentView addSubview:_textView];
    if(tag == 1){
        _textView1 = _textView;
    }else if(tag == 2){
        _textView2 = _textView;
    }else if(tag == 3){
        _textView3 = _textView;
    }
    
}

-(void)createBottomView{
    UIButton  *saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saleButton.tag = 111;
    [saleButton setTitle:@"提交" forState:UIControlStateNormal];

    
    [saleButton setFrame:CGRectMake(30, ScreenHeight - 60, ScreenWidth - 60, 35)];
    [saleButton setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [saleButton setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [saleButton.titleLabel setFont:ListTitleFont];
    [saleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saleButton];
    
}



//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    keyboardHeight = 0;
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    
    CGRect mf = _mainScroll.frame;
    mf.origin.y = NavBarHeight;
    _mainScroll.frame = mf;
    
    [UIView commitAnimations];
    
    
    [self.view removeGestureRecognizer:tapRecognizer];
}



//键盘显示
- (void)keyboardWillShow:(NSNotification *)notification {
    
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    // get a rect for the view frame
    {
        
        CGRect mf = _mainScroll.frame;
        
        CGFloat x = mf.size.height - _mainScroll.contentSize.height;
        CGFloat SH = StatusBarHeight;
        CGFloat bottomH = 0;
        if (ZC_iPhoneX ) {
            SH = 0;
            bottomH = 34;
        }
        if(x > 0){
            if(x<keyboardHeight){
                mf.origin.y = NavBarHeight - (keyboardHeight - x);
            }
        }else{
            mf.origin.y   = NavBarHeight - keyboardHeight;
        }
        _mainScroll.frame = mf;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    [self.view addGestureRecognizer:tapRecognizer];
}


- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

//屏幕点击事件
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [_textView1 resignFirstResponder];
    [_textView2 resignFirstResponder];
    [_textView3 resignFirstResponder];
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
