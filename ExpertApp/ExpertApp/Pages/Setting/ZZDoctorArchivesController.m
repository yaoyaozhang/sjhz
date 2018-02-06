//
//  ZZDoctorArchivesController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/16.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorArchivesController.h"
#import "ZCTextPlaceholderView.h"

@interface ZZDoctorArchivesController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
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

@property(nonatomic,strong)NSArray   *listArray;
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
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setTitle:@"保存" forState:0];
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    _listArray = [[NSMutableArray alloc] init];
    _listArray = @[@"医生教育背景及职业资格",@"医生临床专长及学术任职",@"医生寄语及健康观点"];
    
    
    
    [self.menuTitleButton setTitle:@"背景资料" forState:UIControlStateNormal];
    
    [_mainScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - NavBarHeight - 60)];
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.alwaysBounceHorizontal = NO;
    _mainScroll.alwaysBounceVertical = YES;
    _mainScroll.pagingEnabled = NO;
    _mainScroll.bounces = YES;
    _mainScroll.scrollEnabled = YES;
    _mainScroll.delegate = self;
    
    [self createInitView:1];
    [self createInitView:2];
    [self createInitView:3];
    
    
    [self handleKeyboard];
    if(_mainScroll.contentSize.height < 390){
        [_mainScroll setContentSize:CGSizeMake(ScreenWidth, 390)];
    }
    
    contentSize = _mainScroll.contentSize;
//    [self createBottomView];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        NSString *v1 = _textView1.text;
        NSString *v2 = _textView2.text;
        NSString *v3 = _textView3.text;
        
        // 提交
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertToString(v1) forKey:@"medicalBackground"];
        [dict setObject:convertToString(v2) forKey:@"academicResearch"];
        [dict setObject:convertToString(v3) forKey:@"doctorWrote"];
        [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
        
        [ZZRequsetInterface post:API_updateDoctorDn param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            loginUser.medicalBackground = convertToString(v1);
            loginUser.academicResearch = convertToString(v2);
            loginUser.doctorWrote = convertToString(v3);
            [[ZZDataCache getInstance] changeUserInfo:loginUser];
            [self.view makeToast:@"保存成功!"];
            [self goBack:nil];
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
    UILabel *labText = [[UILabel alloc] initWithFrame:CGRectMake(15, y + 10, ScreenWidth -30, 30 )];
    [labText setText:_listArray[tag - 1]];
    [labText setFont:ListTitleFont];
    [labText setTextColor:UIColorFromRGB(TextBlackColor)];
    [_mainScroll addSubview:labText];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,y +  40,ScreenWidth, 90)];
    [bgView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_mainScroll addSubview:bgView];
    
    
    ZCTextPlaceholderView *_textView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, y + 55, ScreenWidth - 30, 60)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setTextColor:UIColorFromRGB(TextBlackColor)];
    [_textView setPlaceholder:[NSString stringWithFormat:@"请输入%@",_listArray[tag-1]]];
    [_textView setFont:ListTitleFont];
    [_mainScroll addSubview:_textView];
    if(tag == 1){
        _textView1 = _textView;
        _textView1.text = convertToString(loginUser.medicalBackground);
    }else if(tag == 2){
        _textView2 = _textView;
        _textView2.text = convertToString(loginUser.academicResearch);
    }else if(tag == 3){
        _textView3 = _textView;
        _textView3.text = convertToString(loginUser.doctorWrote);
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
    
    
    [self setBootomLocation];
    [UIView commitAnimations];
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self didTapAnywhere:nil];
//}



-(void)setBootomLocation{
    CGSize tempSize = CGSizeMake(ScreenWidth, 0);
    tempSize.height = contentSize.height + keyboardHeight;
    CGRect f = _mainScroll.frame;
    if(keyboardHeight>0){
     
        f.size.height = ScreenHeight - NavBarHeight - keyboardHeight;
    }else{
        
        f.size.height = ScreenHeight - NavBarHeight - 60 ;
    }
    [_mainScroll setFrame:f];
    [_mainScroll setContentSize:tempSize];
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
        
        [self setBootomLocation];
    }
    
    // commit animations
    [UIView commitAnimations];
    
    [self.view addGestureRecognizer:tapRecognizer];
}


- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    tapRecognizer.delegate = self;
    _mainScroll.userInteractionEnabled = YES;
    [_mainScroll addGestureRecognizer:tapRecognizer];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *view = [touch view];
    
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
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
