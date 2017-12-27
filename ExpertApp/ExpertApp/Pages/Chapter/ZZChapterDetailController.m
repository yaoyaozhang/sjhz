//
//  ZZChapterDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/12.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterDetailController.h"
#import "ZZKeyboardView.h"

#import "UIView+Border.h"
#import "UIButtonUpDown.h"
#import "ZZShareView.h"

#import "ZZCommentController.h"

#import "ZZPayHandler.h"
#import "ZZRewardController.h"

@interface ZZChapterDetailController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;
//@property(nonatomic,strong) UIWebView *tmpWebview;
@property(nonatomic,strong) ZZKeyboardView *keyboardView;

@end

@implementation ZZChapterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:_model.title forState:UIControlStateNormal];
    
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setTitle:@"" forState:UIControlStateNormal];
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    
    [self initWebView];
    
    _keyboardView = [[ZZKeyboardView alloc] initWithDelegate:self changeView:self.webView.scrollView show:NO];
    _keyboardView.chatpterModel = _model;
    
    [self btnFontSizeChange];
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == BACK_BUTTON){
        [self goBack:nil];
    }
}



#pragma mark - WKWebView简单使用
- (void)initWebView{
    // 1.创建webview，并设置大小，"20"为状态栏高度
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,NavBarHeight,ScreenWidth,ScreenHeight-NavBarHeight - ZZCommentKeyboardHeight)];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    
    
    [self loadURL];
    
}

//-(UIWebView *)tmpWebview{
//    if(!_tmpWebview){
//        _tmpWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0,NavBarHeight,ScreenWidth,ScreenHeight-NavBarHeight - ZZCommentKeyboardHeight)];
//        _tmpWebview.delegate = self;
//        _tmpWebview.scrollView.bounces = NO;
//        _tmpWebview.opaque = NO;
//        _tmpWebview.backgroundColor = [UIColor whiteColor];
//        _tmpWebview.scalesPageToFit = YES;
//    }
//    return _tmpWebview;
//}

-(void)setReloadData{
//    NSString *jsStr = [NSString stringWithFormat:@"doInitConfig('%@','%@','%@','%@',%d,%d)",@"视频地址",@"音频地址",_model.author,@"时间",123,1];
//    [_webView stringByEvaluatingJavaScriptFromString:jsStr];

}


-(void)loadURL{
    //2.创建URL
    NSURL *URL = [NSURL URLWithString:API_getChapterDetail(_model.nid)];
//    NSURL *URL = [NSURL URLWithString:API_getChapterDetail(65)];
//    NSURL *URL = [NSURL URLWithString:@"http://172.16.4.38:8080/chapter.html"];
//        NSURL *URL = [NSURL URLWithString:@"http://219.142.225.69:8123/news/wz/chapter_template.html"];
    
    
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //4.加载Request
    [_webView loadRequest:request];
    
    [self setReloadData];
}


#pragma mark - UIWebViewDelegate代理方法
#pragma mark 开始加载
//是否允许加载网页，也可获取js要打开的url，通过截取此url可与js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    //截取URL，这里可以和JS进行交互，但这里没有写，因为会涉及到JS的一些知识，增加复杂性
    NSString *urlString = [request.URL absoluteString];
    urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    NSLog(@"urlString=%@---urlComps=%@",urlString,urlComps);
    
    if([urlString hasPrefix:@"sjhz://chapter#"]){
        int type = [[urlString stringByReplacingOccurrencesOfString:@"sjhz://chapter#" withString:@""] intValue];
        [self onClickWithType:type];
        return NO;
    }
    return YES;
}
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
    //显示网络请求加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
}
//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [SVProgressHUD dismiss];
    
    //隐藏网络请求加载图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
//    [self setBarButtonStatus];
    if([@"" isEqual:convertToString(_model.title)]){
        [self.menuTitleButton setTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] forState:UIControlStateNormal];
        
    }
    [self btnFontSizeChange];
}

//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
//                                                    message:@"网络连接发生错误!"
//                                                   delegate:self
//                                          cancelButtonTitle:nil
//                                          otherButtonTitles:@"确定", nil];
//    [alert show];
    [SVProgressHUD dismiss];
}


-(void)onClickWithType:(int)type{
    //1，转发，2，评论，3收藏   0，打赏
    if(type == 1){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeChapter vc:self];
        shareView.shareModel = _model;
        [shareView show];
    }
    if(type == 0){
        // 打赏
        ZZRewardController *rewardVC = [[ZZRewardController alloc] init];
        rewardVC.type = ZZRewardTypeChapter;
        rewardVC.rewardModel = _model;
        [self openNav:rewardVC sound:nil];
    }
    
    if(type == 2){
        ZZCommentController *comVC = [[ZZCommentController alloc] init];
        comVC.nid = _model.nid;
        comVC.model = _model;
        [self openNav:comVC sound:nil];
    }
    if(type == 3){
        // 收藏
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if(_model.collect){
            [dict setObject:convertToString(@"0") forKey:@"collectiontType"];
        }else{
            [dict setObject:convertToString(@"1") forKey:@"collectiontType"];
        }
        [dict setObject:convertIntToString(_model.nid) forKey:@"nid"];
        [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"uid"];
        [ZZRequsetInterface post:API_CollectChapter param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            
        } complete:^(NSDictionary *dict) {
            if(_model.collect){
                [self.view makeToast:@"取消收藏成功!"];
            }else{
                [self.view makeToast:@"收藏成功!"];
            }
            
            _model.collect = !_model.collect;
            
            [self setReloadData];
            
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            [self.view makeToast:errorMsg];
        } progress:^(CGFloat progress) {
            
        }];
    }
}



//字体大小改变
-(void) btnFontSizeChange{
//    NSString *strFontSize = [NSString stringWithFormat:@"document.body.style.fontSize = '%dpx';",20];
//    [self.webView stringByEvaluatingJavaScriptFromString:strFontSize];
    
//    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'";
//    [self.webView stringByEvaluatingJavaScriptFromString:str];
    
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
