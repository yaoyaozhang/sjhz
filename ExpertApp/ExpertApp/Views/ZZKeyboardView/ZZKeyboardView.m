//
//  ZZKeyboardView.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZKeyboardView.h"
#import "UIView+Border.h"

@interface ZZKeyboardView()<UITextFieldDelegate>{
    UITapGestureRecognizer *tapRecognizer;
    CGFloat navY;
    
    ZZChapterCommentModel *tempModel;
    
    
}

@property(nonatomic,strong) UIViewController *curVC;
@property(nonatomic,strong) UIScrollView     *changeView;
@property(nonatomic,strong) UITextField      *textField;


@end

@implementation ZZKeyboardView

-(instancetype)initWithDelegate:(UIViewController *)delegate changeView:(UIScrollView *)changeView show:(BOOL)isShowKeyboard{
    self = [super init];
    if(self){
        _curVC = delegate;
        _changeView = changeView;
        
        [_curVC.view addSubview:self];
        
        navY = _changeView.frame.origin.y;
        
        [self endEditing:YES];
        
        self.frame = CGRectMake(0, ScreenHeight - ZZCommentKeyboardHeight, ScreenWidth, ZZCommentKeyboardHeight);
        [self addTopBorderWithColor:UIColorFromRGB(BgLineColor) andWidth:1.0f];
        [self setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        
        UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 18, 18)];
        [imgIcon setImage:[UIImage imageNamed:@"btn_comment"]];
        [self addSubview:imgIcon];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(48, 7, ScreenWidth - 48 - 20, 24)];
        [bgView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        bgView.layer.cornerRadius                      = 12.0f;
        bgView.layer.masksToBounds                     = YES;
        [self addSubview:bgView];
        
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 48 - 50, 24)];
        [_textField setPlaceholder:@"写评论"];
        _textField.font                                    = ListDetailFont;
        _textField.textColor                               = UIColorFromRGB(TextSizeSixColor);
        _textField.returnKeyType                           = UIReturnKeySend;
        _textField.autoresizesSubviews                     = YES;
        _textField.delegate                                = self;
        _textField.textAlignment                           = NSTextAlignmentLeft;
        _textField.autoresizingMask                        = (UIViewAutoresizingFlexibleWidth);
        [_textField setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:_textField];
        
        [self handleKeyboard];
        
        
        if(isShowKeyboard){
            [_textField becomeFirstResponder];
        }
    }
    return self;
}

-(void)hideKeyboard{
    [_textField resignFirstResponder];
}


-(void)setReplyModel:(ZZChapterCommentModel *)model{
    if(model!=nil){
        [_textField setText:[NSString stringWithFormat:@"@%@ ",model.name]];
        tempModel = model;
    }
}

//屏幕点击事件
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer {
    [self hideKeyboard];
}


//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    CGRect tf         = _changeView.frame;
    tf.origin.y       = navY;
    _changeView.frame  = tf;
    
    
    CGRect bf         = self.frame;
    bf.origin.y       = ScreenHeight - ZZCommentKeyboardHeight;
    self.frame = bf;
    
    [UIView commitAnimations];
    
    
    [_curVC.view removeGestureRecognizer:tapRecognizer];
}



//键盘显示
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    // get a rect for the view frame
    
    {
        CGRect tf         = _changeView.frame;
        tf.origin.y       = navY - keyboardHeight;
        _changeView.frame  = tf;
        
        CGRect bf         = self.frame;
        bf.origin.y       = ScreenHeight - ZZCommentKeyboardHeight - keyboardHeight;
        
        self.frame = bf;
    }
    
    // commit animations
    [UIView commitAnimations];
    
    [_curVC.view addGestureRecognizer:tapRecognizer];
}


- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    [_curVC.view addGestureRecognizer:tapRecognizer];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && tempModel!=nil){
        if([[NSString stringWithFormat:@"@%@",tempModel.name]  isEqual:textField.text]){
            _textField.text = @"";
            tempModel = nil;
            return NO;
        }
    }
    return YES;
        
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard];
    
    if([@"" isEqual:convertToString(textField.text)]){
        return YES;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(_nid) forKey:@"nid"];
    [dict setObject:convertIntToString([ZZDataCache getInstance].getLoginUser.userId) forKey:@"uid"];
    [dict setObject:convertToString(textField.text) forKey:@"content"];
    if(tempModel!=nil){
        [dict setObject:convertIntToString(tempModel.cid) forKey:@"deptCid"];
    }else{
        [dict setObject:@"0" forKey:@"deptCid"];
    }
    
    [ZZRequsetInterface post:API_SendChapterComment param:dict timeOut:HttpGetTimeOut start:^{
        _textField.text = @"";
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        [_curVC.view makeToast:@"评论成功!"];
        if(_ResultBlock){
            _ResultBlock(0);
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
    
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
