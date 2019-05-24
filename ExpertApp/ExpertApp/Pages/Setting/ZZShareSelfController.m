//
//  ZZShareSelfController.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZShareSelfController.h"
#import "UIButtonUpDown.h"
#import "MyButton.h"
#import "ZZShareView.h"

@interface ZZShareSelfController (){
    ZZUserInfo *user;
    
    UIScrollView *_mainScroll;
}

@end

@implementation ZZShareSelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    user = [[ZZDataCache getInstance] getLoginUser];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self createItemView];
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"" forState:0];
    self.menuRightButton.hidden = NO;
    [self.menuRightButton setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
    
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    if(sender.tag == RIGHT_BUTTON){
        // 分享
        ZZShareView *shareView = [[ZZShareView alloc] initWithShareType:ZZShareTypeUserImage vc:self];
        
        shareView.shareModel = [self captureView:self.view];
        [shareView show];
    }
}

-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return [self cutImage:img];
}

/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
-(UIImage*)cutImage:(UIImage *)image{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, _mainScroll.frame);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    
    // 返回新的改变大小后的图片
    return newImage;
}

-(void)createItemView{
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenWidth * 555 / (750-NavBarHeight))];
    [bgView setImage:[UIImage imageNamed:@"zzicon_jf_myself_bg"]];
    [self.view addSubview:bgView];
    
    CGFloat w = ScreenWidth - 40;
    
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, NavBarHeight + 20, w, ScreenHeight - NavBarHeight - 80 - (ZC_iPhoneX?34:0))];
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    _mainScroll.layer.borderWidth = 2.0f;
    [self.view addSubview:_mainScroll];
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, w, 30)];
    [lab1 setFont:[UIFont boldSystemFontOfSize:28]];
    [lab1 setText:[NSString stringWithFormat:@"邀请函[%@]",user.invtCode]];
    [lab1 setTextColor:UIColorFromRGB(BgTitleColor)];
    [lab1 setTextAlignment:NSTextAlignmentCenter];
    [_mainScroll addSubview:lab1];
    
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame), w, 50)];
    [lab2 setFont:ListTitleFont];
    [lab2 setText:@"INVITATION"];
    [lab2 setTextAlignment:NSTextAlignmentCenter];
    [lab2 setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_mainScroll addSubview:lab2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab2.frame)+30, w, 150)];
    [lab3 setFont:FontSeventeen];
    lab3.numberOfLines = 0;
    [lab3 setTextAlignment:NSTextAlignmentCenter];
    [lab3 setTextColor:UIColorFromRGB(TextDarkColor)];
    [_mainScroll addSubview:lab3];
    
    NSString *text = [NSString stringWithFormat:@"我是%@\n我在使用【三甲慧诊】\n忍不住把它推荐给你\n快来寻找你的私人医生吧",user.userName];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(BgTitleColor) range:NSMakeRange(2, user.userName.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.attributedText = string;
    
    UIImageView *imgCode = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-55, CGRectGetMaxY(lab3.frame) + 50, 110, 110)];
    [imgCode setImage:[UIImage imageNamed:@"downcode"]];
    [_mainScroll addSubview:imgCode];
    
    [_mainScroll setContentSize:CGSizeMake(w, CGRectGetMaxY(imgCode.frame)+5)];
    
    
//    UIView *viewBtm = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 180 - (ZC_iPhoneX?34:0) , ScreenWidth, 180)];
//    [viewBtm setBackgroundColor:UIColor.whiteColor];
//    [self.view addSubview:viewBtm];
//
//    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
//    [btn setFrame:CGRectMake(155/2, 130/2-78/2, 40, 78)];
//    [btn setTitleColor:UIColorFromRGB(TextLightDarkColor) forState:UIControlStateNormal];
//    [btn.titleLabel setFont:ListTimeFont];
//    [btn addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
//    [btn setTitle:@"" forState:UIControlStateNormal];
//    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    btn.tag = 1;
//
//    UILabel *btnlab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 78-20, 40, 20)];
//    [btnlab1 setText:@"微信"];
//    [btnlab1 setTextAlignment:NSTextAlignmentCenter];
//    [btnlab1 setTextColor:UIColorFromRGB(TextLightDarkColor)];
//    [btnlab1 setFont:ListTimeFont];
//    [btn addSubview:btnlab1];
//
//
//    MyButton *btn2 = [MyButton buttonWithType:UIButtonTypeCustom];
//    [btn2 setFrame:CGRectMake(ScreenWidth - 155/2 - 40, 130/2-78/2, 40, 78)];
//    [btn2 setTitleColor:UIColorFromRGB(TextLightDarkColor) forState:UIControlStateNormal];
//    [btn2 addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
//    [btn2 setImage:[UIImage imageNamed:@"share_wechat_circle"] forState:UIControlStateNormal];
//    btn2.tag = 2;
//    btn2.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UILabel *btnlab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 78-20, 40, 20)];
//    [btnlab2 setText:@"朋友圈"];
//    [btnlab2 setTextAlignment:NSTextAlignmentCenter];
//    [btnlab2 setFont:ListTimeFont];
//    [btnlab2 setTextColor:UIColorFromRGB(TextLightDarkColor)];
//    [btn2 addSubview:btnlab2];
//
//
//    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, ScreenWidth, 1)];
//    [imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
//
//
//    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCancel setTitle:@"取消" forState:0];
//    btnCancel.tag = BACK_BUTTON;
//    [btnCancel setTitleColor:UIColorFromRGB(TextLightDarkColor) forState:0];
//    [btnCancel addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btnCancel setFrame:CGRectMake(0, 131, ScreenWidth, 50)];
//    btnCancel.backgroundColor = UIColor.clearColor;
//
//
//    [viewBtm addSubview:btn];
//    [viewBtm addSubview:btn2];
//    [viewBtm addSubview:imgLine];
//    [viewBtm addSubview:btnCancel];
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
