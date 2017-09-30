//
//  ZCActionSheet.m
//  wash
//
//  Created by lizhihui on 15/10/21.
//
//

#import "ZCActionSheetView.h"
#define BtnHeight 44
#define Margin    5

@interface ZCActionSheetView ()
{
    int _btnTag;
}

@property (nonatomic, weak) ZCActionSheetView *actionSheet;
@property (nonatomic, weak) UIView *sheetView;

@end

@implementation ZCActionSheetView

- (instancetype)initWithDelegate:(id<ZCActionSheetViewDelegate>)delegate title:(NSString *)titleMessage CancelTitle:(NSString *)cancelTitle OtherTitles:(NSString *)otherTitles, ...{
    self = [super init];
    
    ZCActionSheetView *actionSheet = self;
    self.actionSheet = actionSheet;
    
    actionSheet.delegate = delegate;
    
    // 黑色遮盖
    actionSheet.frame = [UIScreen mainScreen].bounds;
    actionSheet.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:actionSheet];
    actionSheet.alpha = 0.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverClick)];
    [actionSheet addGestureRecognizer:tap];
    
    // sheet
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    sheetView.backgroundColor = UIColorFromRGB(BgSystemColor);
    sheetView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    sheetView.hidden = YES;
    
    _btnTag = 1;
    
    if(titleMessage){
        [self setupBtnWithTitle:titleMessage isTitle:YES];
    }
    
    NSString* curStr;
    va_list list;
    if(otherTitles)
    {
        [self setupBtnWithTitle:otherTitles isTitle:NO];
        
        va_start(list, otherTitles);
        while ((curStr = va_arg(list, NSString*))) {
            [self setupBtnWithTitle:curStr isTitle:NO];
            
        }
        va_end(list);
    }
    
    CGRect sheetViewF = sheetView.frame;
    
    if(cancelTitle!=nil){
        sheetViewF.size.height = BtnHeight * _btnTag + Margin;
    }else{
        sheetViewF.size.height = BtnHeight * (_btnTag-1);
    }
    sheetView.frame = sheetViewF;
    
    if(cancelTitle!=nil){
        // 取消按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetView.frame.size.height - BtnHeight, ScreenWidth, BtnHeight)];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextLightDarkColor)] forState:UIControlStateHighlighted];
        [btn setTitle:cancelTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    btn.titleLabel.font = HeitiLight(17);
        // 同创建工单页的cell 标题字体一样
        btn.titleLabel.font = ListTitleFont;
        btn.tag = 0;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:btn];
    }
    return actionSheet;
}


-(void)setSelectIndex:(int)selectIndex{
    if(selectIndex > 0){
        UIButton *btn=[self.sheetView viewWithTag:selectIndex];
        if(_selectColor){
            UIButton *btn=[self.sheetView viewWithTag:selectIndex];
            [btn setTitleColor:_selectColor forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(TextLinkColor) forState:UIControlStateNormal];
        }
    }
}

- (void)show{
    self.sheetView.hidden = NO;

    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = ScreenHeight;
    self.sheetView.frame = sheetViewF;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = ScreenHeight - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{

        self.sheetView.frame = newSheetViewF;
        
        self.actionSheet.alpha = 0.3;
    }];
}

- (void)setupBtnWithTitle:(NSString *)title isTitle:(BOOL) isTitle{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, BtnHeight * (_btnTag - 1) , ScreenWidth, BtnHeight)];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextWhiteColor)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:UIColorFromRGB(TextLightDarkColor)] forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    if(_selectIndex==_btnTag){
        [btn setTitleColor:UIColorFromRGB(TextLinkColor) forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if(isTitle){
        btn.titleLabel.font = ListTitleFont;
    }else{
//        btn.titleLabel.font = HeitiLight(17);
        btn.titleLabel.font = ListTitleFont;
        [btn addTarget:self action:@selector(sheetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    btn.tag = _btnTag;
    [self.sheetView addSubview:btn];
    
    
    // 最上面画分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = UIColorFromRGB(BgLineColor);
    [btn addSubview:line];
    
    _btnTag ++;
}

- (void)coverClick{
    CGRect sheetViewF = self.sheetView.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = sheetViewF;
        self.actionSheet.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionSheet removeFromSuperview];
        [self.sheetView removeFromSuperview];
    }];
}
// button的点击事件
- (void)sheetBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        [self coverClick];
        return;
    }
    // 让代理去执行方法
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self.actionSheet clickedButtonAtIndex:btn.tag];
        [self coverClick];
    }
}

- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
