//
//  ZZHZResultController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/9.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZHZResultController.h"


#import "UIView+Extension.h"
#import "UIButtonUpDown.h"

#import "ZCTextPlaceholderView.h"
#import "ZZRewardController.h"

#import "ZZCreateCaseController.h"
#import "ZZCreateSportCaseController.h"
#import "ZZDoctorDetailController.h"
#import "ZZShareView.h"
#import "CoreTextLabel.h"


@interface ZZHZResultController (){
    CGPoint        contentoffset;// 记录list的偏移量
    
    UIButton *checkButton;
    
    UITapGestureRecognizer *tapRecognizer;
    
    NSString *desc1;
    NSString *desc2;
    ZZUserInfo *loginUser;
    
    
}
@property(nonatomic,strong) UIScrollView *mainScroll;
@property(nonatomic,strong)UIView           *headerView;
@property(nonatomic,strong)UIView           *contentView;
@property(nonatomic,strong)NSMutableArray   *listArray;
@property(nonatomic,strong)ZCTextPlaceholderView   *textView;

@end

@implementation ZZHZResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    self.menuRightButton.hidden = YES;
    
    loginUser = [[ZZDataCache getInstance] getLoginUser];
    
    
    
    [self.menuTitleButton setTitle:@"会诊结果" forState:UIControlStateNormal];
    
    _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
    [_mainScroll setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_mainScroll];
    
    [_mainScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight - NavBarHeight)];
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.alwaysBounceHorizontal = NO;
    _mainScroll.alwaysBounceVertical = NO;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.bounces = NO;
    _mainScroll.scrollEnabled = NO;
    
    if(!loginUser.isDoctor && _model.state == 3){
        [self createInitView];
        [self handleKeyboard];
    }
    
    [self loadCaseResult];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView  = [[ZZShareView alloc] initWithShareType:ZZShareTypeHZResult vc:self];
        shareView.shareModel = _model;
        [shareView show];
    }else if(sender.tag == 111){
        // 评价
        NSString *score = @"";
        if(checkButton){
            score = checkButton.titleLabel.text;
        }
        NSString *text = _textView.text;
        if(is_null(text)){
            [self.view makeToast:@"评价内容不能为空!"];
        }
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:convertToString(text) forKey:@""];
        [dict setObject:convertToString(score) forKey:@""];
        [ZZRequsetInterface post:API_SendChapterComment param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
    }else if(sender.tag == 222){
        // 打赏
        ZZRewardController *rewardVC = [[ZZRewardController alloc] init];
        rewardVC.rewardModel = _model;
        [self openNav:rewardVC sound:nil];
    }else if(sender.tag == 333){
        // 复诊
        // 根据病例类型
        if(sender){
            
            ZZCreateCaseController *vc = [[ZZCreateCaseController alloc] init];
//            vc.docId = _mo
            vc.pCaseId =  convertIntToString(_model.caseId);
            vc.editModel =  nil;
            [self openNav:vc sound:nil];
        }else{
            
            ZZCreateSportCaseController *vc = [[ZZCreateSportCaseController alloc] init];
            
            //            vc.docId = _mo
            vc.pCaseId =  convertIntToString(_model.caseId);
            vc.editModel = nil;
            [self openNav:vc sound:nil];
        }
    }
    
}


-(void)createInitView{
    _listArray = [[NSMutableArray alloc] init];
    
    
    _contentView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    [_contentView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat xh = 15;
    xh = [self createLabel:@"您对此次的服务满意嘛？" y:xh pView:_contentView] + 10;
    
    CGFloat px = 0;
    CGFloat pxw = (ScreenWidth - 4)/3;
    for(int i=0;i<3;i++){
        UIButtonUpDown  *saleButton = [UIButtonUpDown buttonWithType:UIButtonTypeCustom];
        if(i==0){
            [saleButton setImage:[UIImage imageNamed:@"service_satisfied"] forState:UIControlStateNormal];
            [saleButton setTitle:@"满意" forState:UIControlStateNormal];
        }else if(i==1){
            [saleButton setImage:[UIImage imageNamed:@"service_commonly"] forState:UIControlStateNormal];
            [saleButton setTitle:@"一般" forState:UIControlStateNormal];
        }else{
            [saleButton setImage:[UIImage imageNamed:@"service_dissatisfied"] forState:UIControlStateNormal];
            [saleButton setTitle:@"不满意" forState:UIControlStateNormal];
        }
        [saleButton.imageView setFrame:CGRectMake(0, 0, 24, 26)];
        [saleButton setFrame:CGRectMake(px, xh, pxw, 76)];
        [saleButton setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        [saleButton setBackgroundColor:[UIColor whiteColor]];
        saleButton.tag = OTHER_BUTTON;
        [saleButton.titleLabel setFont:ListDetailFont];
        [saleButton addTarget:self action:@selector(checkHeaderClick:) forControlEvents:UIControlEventTouchUpInside];
        saleButton.tag = i+1;
        [_contentView addSubview:saleButton];
        px = px + pxw + 2;
    }
    xh = xh+76+15;
    
    xh = xh + [self createLabel:@"給此次会诊一些评价吧" y:xh pView:_contentView] + 10;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, xh,ScreenWidth, 60)];
    [bgView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_contentView addSubview:bgView];
    
    
    _textView = [[ZCTextPlaceholderView alloc] initWithFrame:CGRectMake(15, xh + 8, ScreenWidth - 30, 44)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setTextColor:UIColorFromRGB(TextBlackColor)];
    [_textView setFont:ListTitleFont];
    [_contentView addSubview:_textView];
    
    xh = xh + 60;
    [_contentView setFrame:CGRectMake(0, 0, ScreenWidth, xh)];
    
    
    
    
    
    CGFloat x = 0;
    int column = 3;
    if(_model.state == 4){
        column = 2;
    }
    CGFloat xw = (ScreenWidth - column-1)/column;
    for(int i=0;i<3;i++){
        if(_model.state == 4 && i==0){
            continue;
        }
        UIButton  *saleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i==0){
            saleButton.tag = 111;
            [saleButton setTitle:@"提交评价" forState:UIControlStateNormal];
        }else if(i==1){
            saleButton.tag = 222;
            [saleButton setTitle:@"我要打赏" forState:UIControlStateNormal];
        }else{
            saleButton.tag = 333;
            [saleButton setTitle:@"我要复诊" forState:UIControlStateNormal];
        }
        
        [saleButton setFrame:CGRectMake(x, ScreenHeight-40, xw, 40)];
        [saleButton setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
        [saleButton setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        saleButton.tag = OTHER_BUTTON;
        [saleButton.titleLabel setFont:ListTitleFont];
        [saleButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        saleButton.tag = i+1;
        [self.view addSubview:saleButton];
        x = x + xw + 1;
    }
}



-(void)checkHeaderClick:(UIButton *)btn{
    if(checkButton!=nil){
        [checkButton setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    }
    [btn setTitleColor:UIColorFromRGB(TextPlaceHolderColor) forState:UIControlStateNormal];
    checkButton = btn;
    
    
}




//键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView beginAnimations:@"bottomBarDown" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    
    if(contentoffset.x != 0 || contentoffset.y != 0){
        // 隐藏键盘，还原偏移量
        [_mainScroll setContentOffset:contentoffset];
    }
    
    [UIView commitAnimations];
    
    
    [self.view removeGestureRecognizer:tapRecognizer];
}



//键盘显示
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    // get a rect for the view frame
    {
        
        //获取当前cell在屏幕中的位置
        CGRect rectinsuperview = _textView.frame;
        
        contentoffset = _mainScroll.contentOffset;
        
        if ((rectinsuperview.origin.y+50 - _mainScroll.contentOffset.y)>200) {
            
            [_mainScroll setContentOffset:CGPointMake(_mainScroll.contentOffset.x,((_textView.origin.y-_mainScroll.contentOffset.y)-150)+  _mainScroll.contentOffset.y) animated:YES];
            
        }
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
    [_textView resignFirstResponder];
}





-(void)loadCaseResult{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(_model.tid) forKey:@"id"];
    [ZZRequsetInterface post:API_GetCaseResult param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(dict[@"retData"]){
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
            CGFloat y = 10;
            NSArray *hzdoc = dict[@"retData"][@"hzdoc"];
            NSString *hzStr = @"";
            if(hzdoc && hzdoc.count>0){
                for (NSDictionary *hzItem in hzdoc) {
                    hzStr = [hzStr stringByAppendingFormat:@",%@",hzItem[@"docName"]];
                }
                
                if(hzStr.length>0){
                    hzStr  = [hzStr substringFromIndex:1];
                }
            }
            if(hzdoc.count>1){
                y = y + [self createLabel:[NSString stringWithFormat:@"您的［%@］的病例经过%@ %zd位大夫会诊结果如下：",_model.caseName,hzStr,hzdoc.count] y:y pView:_headerView] +10;
            }else{
                y = y + [self createLabel:[NSString stringWithFormat:@"您的［%@］的病例经过%@大夫会诊结果如下：",_model.caseName,hzStr] y:y pView:_headerView] +10;
            }
            y = y + [self createWhiteText:convertToString(dict[@"retData"][@"result"][@"caseRsult"]) y:y arr:nil] +15;
            
            NSDictionary *tjDict = dict[@"retData"][@"result"];
            NSArray *tjArr = dict[@"retData"][@"tjdoc"];
            // 如果有推荐医生
            if(tjDict[@"tjOutdoc"] || tjArr.count>0){
                y = y + [self createWhiteText:convertToString(tjDict[@"tjOutdoc"]) y:y arr:tjArr] + 15;
            }
            
            //
//            y = y + [self createWhiteText:convertToString(@"客户评价了你：嘻嘻嘻嘻嘻嘻嘻嘻嘻") y:y arr:nil] +15;
            
            [_headerView  setFrame:CGRectMake(0, 0, ScreenHeight, y)];
            [_mainScroll addSubview:_headerView];
            if(_contentView != nil){
                
                CGRect cf = _contentView.frame;
                cf.origin.y = y;
                _contentView.frame = cf;
                
            }
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

-(CGFloat)createLabel:(NSString *) text y:(CGFloat )y pView:(UIView *) view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, y, ScreenWidth - 30, 0)];
    [label setFont:ListDetailFont];
    [label setTextColor:UIColorFromRGB(TextBlackColor)];
    [label setText:text];
    label.numberOfLines = 0;
    [label setBackgroundColor:[UIColor clearColor]];
    CGSize size = [self autoHeightOfLabel:label with:ScreenWidth - 30];
    [view addSubview:label];
    return size.height;
}

-(CGFloat)createWhiteText:(NSString *) content y:(CGFloat) y arr:(NSArray *) arr{
    CGRect f = CGRectMake(0, y, ScreenWidth, 0);
    UIImageView *whiteBg = [[UIImageView alloc] initWithFrame:f];
    [whiteBg setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_headerView addSubview:whiteBg];
    
    NSString *text = @"";
    if(arr!=nil && arr.count>0){
        text = [text stringByAppendingFormat:@"%@大夫推荐了他的朋友",_model.docName];
        int i=0;
        for (NSDictionary *hzItem in arr) {
            if(i==0){
                text = [text stringByAppendingFormat:@"<a href='sjhz://%@'>%@</a>,",hzItem[@"id"],hzItem[@"docName"]];
                
            }else{
                text = [text stringByAppendingFormat:@"<a href='sjhz://%@'>%@</a>,",hzItem[@"id"],hzItem[@"docName"]];
            }
        }
        text = [text stringByAppendingFormat:@"建议您去找他查看!"];
    }
    text = [text stringByAppendingFormat:@"%@",content];
    
    CoreTextLabel *label = [[CoreTextLabel alloc] initWithFrame:CGRectMake(15, y + 15, ScreenWidth - 30, 0)];
    [label setFont:ListDetailFont];
    [label setTextColor:UIColorFromRGB(TextSizeSixColor)];
    [label setLinkTextColor:UIColorFromRGB(BgTitleColor)];
    label.numberOfLines = 0;
    [label setText:text];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setHtml:text];
    [label sizeToFit];
    
    CGRect cf = label.frame;
    __weak ZZHZResultController *safeSelf = self;
    [label setLinkPressedBlock:^(NSTextCheckingResult *textCheckingResult) {
        //        NSLog(@"textCheckingResult => %@", textCheckingResult.URL.absoluteString);
        NSString *uid = [textCheckingResult.URL.absoluteString stringByReplacingOccurrencesOfString:@"sjhz://" withString:@""];
        
        ZZDoctorDetailController * vc = [[ZZDoctorDetailController alloc] init];
        vc.docId = [convertToString(uid) intValue];
        [safeSelf openNav:vc sound:nil];
    }];
    [_headerView addSubview:label];
    
    f.size.height = cf.size.height + 30;
    [whiteBg setFrame:f];
    
    return cf.size.height+30;
}



/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width,FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
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

