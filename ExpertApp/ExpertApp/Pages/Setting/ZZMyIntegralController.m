//
//  ZZMyIntegralController.m
//  ExpertApp
//
//  Created by zhangxy on 2019/1/9.
//  Copyright © 2019年 sjhz. All rights reserved.
//

#import "ZZMyIntegralController.h"
#import "UIView+Extension.h"

#import "ZZPayHandler.h"

#import "ZZMyIntegralListController.h"

@interface ZZMyIntegralController (){
    ZZUserInfo *user;
    
    NSInteger checkTag;
    
    UILabel *lab2;
    
    NSString *rule;
}


@property(nonatomic,strong)UIScrollView      *mainScroll;
@property(nonatomic,strong)NSMutableArray          *moneyArray;


@property(nonatomic,strong)UILabel      *labIntegral;

@end

@implementation ZZMyIntegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:@"我的积分" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = NO;
    self.menuRightButton.hidden = NO;
    
    [self.menuRightButton setTitle:@"明细" forState:0];
    
    user = [[ZZDataCache getInstance] getLoginUser];
    
    [self createMainView];
    [self loadMoreData];
    
}


/**
 加载更多
 */
-(void)loadMoreData{
    _moneyArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [ZZRequsetInterface post:API_getSouceePayList param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        if(dict && dict[@"retData"]){
            [_moneyArray addObjectsFromArray:dict[@"retData"][@"items"]];
            rule = dict[@"retData"][@"rule"];
            [self createItemsView];
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

-(void)buttonClick:(UIButton *)sender{
    [super buttonClick:sender];
    
    if(sender.tag == RIGHT_BUTTON){
        ZZMyIntegralListController *vc = [[ZZMyIntegralListController alloc] init];
        [self openNav:vc sound:nil];
        
    }
    
}

-(void)btnPayClick:(UIButton *) btn{
    if(checkTag <= 0){
        return;
    }
    
    NSDictionary *item = _moneyArray[checkTag - 100];
    float money = [item[@"price"] floatValue];
    if(btn.tag == 1){
        // 微信
        [ZZPayHandler startJumppay:user.userId payType:ZZPayTypeWX type:4 otherId:@"111" desc:@"充值" prict:money result:^(int code, NSString *msg) {
            [self.view makeToast:msg];
        }];
    }else if(btn.tag == 2){
        // 支付宝
        [ZZPayHandler startJumppay:user.userId payType:ZZPayTypeZFB type:4 otherId:@"111" desc:@"充值" prict:money result:^(int code, NSString *msg) {
            [self.view makeToast:msg];
        }];
    }
    
}

-(void)itemIntegralClick:(UITapGestureRecognizer *) tap{
    NSInteger tag = tap.view.tag;
    
    
    if(checkTag > 0){
        UIView *itemView = [_mainScroll viewWithTag:checkTag];
        [itemView viewWithTag:11].hidden = YES;
    }
    
    checkTag = tag;
    [tap.view viewWithTag:11].hidden = NO;
}


-(void)createItemsView{
    CGFloat iy = [self createAddIntegralBtn:CGRectGetMaxY(lab2.frame) + 5];
    
    UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, iy + 15, ScreenWidth - 30, 1)];
    [imgLine2 setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_mainScroll addSubview:imgLine2];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgLine2.frame) + 10, ScreenWidth - 15, 30)];
    [lab3 setText:@"积分规则"];
    [lab3 setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [lab3 setFont:[UIFont boldSystemFontOfSize:17]];
    [lab3 setTextAlignment:NSTextAlignmentCenter];
    [_mainScroll addSubview:lab3];
    
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(lab3.frame) + 10, ScreenWidth-30, 0)];
    lab4.numberOfLines = 0;
    [lab4 setFont:FontSeventeen];
    [lab4 setTextColor:UIColorFromRGB(TextLightDarkColor)];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:convertToString(rule)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentLeft];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [convertToString(rule) length])];
    [lab4 setAttributedText:attributedString1];
    [_mainScroll addSubview:lab4];
    [lab4 sizeToFit];
    
    
    [_mainScroll setContentSize:CGSizeMake(ScreenWidth, CGRectGetMaxY(lab4.frame)+10)];
}

-(void)createMainView{
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight - NavBarHeight)];
    
    [_mainScroll setBackgroundColor:UIColor.clearColor];
    [self.view addSubview:_mainScroll];
    
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, 30)];
    [lab1 setText:@"积分"];
    [lab1 setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [lab1 setTextAlignment:NSTextAlignmentCenter];
    [_mainScroll addSubview:lab1];

    _labIntegral = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lab1.frame) , ScreenWidth, 30)];
    [_labIntegral setText:[NSString stringWithFormat:@"%d",user.score]];
    [_labIntegral setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labIntegral setFont:[UIFont boldSystemFontOfSize:24]];
    [_labIntegral setTextAlignment:NSTextAlignmentCenter];
    _labIntegral.backgroundColor = UIColor.clearColor;
    [_mainScroll addSubview:_labIntegral];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 125, ScreenWidth - 30, 1)];
    [imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
    [_mainScroll addSubview:imgLine];
    
    lab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgLine.frame)+15, ScreenWidth-30, 30)];
    [lab2 setText:@"充值"];
    [lab2 setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [lab2 setTextAlignment:NSTextAlignmentLeft];
    [_mainScroll addSubview:lab2];
    
    
    
    
}

-(CGFloat)createAddIntegralBtn:(CGFloat) y{
    CGFloat space = 15;
    CGFloat iy = y;
    CGFloat ix = space;
    CGFloat iw = (ScreenWidth - 4*space)/3;
    CGFloat ih = iw/2;
    for (int i = 0; i<_moneyArray.count; i++) {
        NSDictionary *item = [_moneyArray objectAtIndex:i];
        if(i%3 == 0){
            iy = y + i/3 * ih + i/3 * space;
            ix = space;
        }
        
        UIView *itemView =[[UIView alloc] initWithFrame:CGRectMake(ix, iy, iw, ih)];
        itemView.userInteractionEnabled = true;
        itemView.tag = 100 + i;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemIntegralClick:)]];
        itemView.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
        itemView.layer.borderWidth = 1.0;
        itemView.layer.cornerRadius = 4.0f;
        [_mainScroll addSubview:itemView];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(iw-36, ih-36, 36, 36)];
        img.tag = 11;
        [img setImage:[UIImage imageNamed:@"zzicon_jf_checked"]];
        img.hidden = YES;
        [itemView addSubview:img];
        
        
        UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, iw, ih/2)];
        [lab3 setText:[NSString stringWithFormat:@"%@积分",item[@"score"]]];
        [lab3 setTextColor:UIColorFromRGB(TextBlackColor)];
        [lab3 setFont:FontFiftent];
        [lab3 setTextAlignment:NSTextAlignmentCenter];
        [itemView addSubview:lab3];
        
        UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectMake(0, ih/2, iw, ih/2-5)];
        [lab4 setText:[NSString stringWithFormat:@"%@元",item[@"price"]]];
        [lab4 setFont:ListDetailFont];
        lab4.numberOfLines = 0;
        [lab4 setTextColor:UIColorFromRGB(TextLightDarkColor)];
        [lab4 setTextAlignment:NSTextAlignmentCenter];
        [itemView addSubview:lab4];
        
        
        
        ix = ix + space + iw;
    }
    
    iy = iy + space + ih;
    
    UIButton *btnWechat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnWechat.tag = 1;
    [btnWechat setImage:[UIImage imageNamed:@"zzicon_jf_wechatpay"] forState:0];
    [btnWechat setFrame:CGRectMake(space, iy, (ScreenWidth-space*3)/2, 40)];
    btnWechat.layer.cornerRadius = 4.0f;
    [btnWechat addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:btnWechat];
    
    UIButton *btnAliPay = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAliPay.tag = 2;
    [btnAliPay setImage:[UIImage imageNamed:@"zzicon_jf_zfbpay"] forState:0];
    [btnAliPay setFrame:CGRectMake(CGRectGetMaxX(btnWechat.frame) + space, iy, (ScreenWidth-space*3)/2, 40)];
    btnAliPay.layer.cornerRadius = 4.0f;
    [btnAliPay addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScroll addSubview:btnAliPay];
    
    iy = iy + 40;
    return iy;
}


#pragma mark UITableView delegate end
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
