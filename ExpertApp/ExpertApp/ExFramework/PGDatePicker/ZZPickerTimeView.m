//
//  ZZPickerTimeView.m
//  deerkids
//
//  Created by zhangxy on 2017/11/3.
//  Copyright © 2017年 wangzhao. All rights reserved.
//

#import "ZZPickerTimeView.h"
#import "PGPickerView.h"
#import "NSDate+category.h"
#import "UIView+Border.h"

#define BTM_HEIGHT 320

@interface ZZPickerTimeView()<PGPickerViewDelegate,PGPickerViewDataSource>{
    void(^commitBlock)(NSString *time);
    PGPickerView *pickerView;
}

@property(nonatomic,strong) UIViewController *curVC;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong)NSArray   *weekNames;
@property(nonatomic,strong)NSMutableArray   *weeks;
@property(nonatomic,strong)NSMutableArray   *times;

@end


@implementation ZZPickerTimeView

-(instancetype)initWithShareType:(void (^)(NSString *time))resultBlock{
    commitBlock = resultBlock;
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = COLORWithAlpha(51, 51, 51, 0.6);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        
        _weeks = [[NSMutableArray alloc] init];
        _times = [[NSMutableArray alloc] init];
        _weekNames = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
        [_times addObject:@"10:00"];
        [_times addObject:@"10:30"];
        [_times addObject:@"11:00"];
        [_times addObject:@"11:30"];
        [_times addObject:@"12:00"];
        
        [_weeks addObject:@"今天"];
        [_weeks addObject:@"明天"];
        // 周日=1，周一=2
        int weekday = (int)[[NSDate date] weekday];
        weekday = weekday + 2;
        if(weekday > 7){
            weekday = weekday - 7;
        }
        for(int i=0;i<6;i++){
            [_weeks addObject:_weekNames[weekday-1]];
            weekday = weekday + 1;
            if(weekday > 7){
                weekday = weekday - 7;
            }
        }
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisMenu)];
//        [self addGestureRecognizer:tap];
        
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-BTM_HEIGHT, ScreenWidth, BTM_HEIGHT)];
        _bottomView.backgroundColor = UIColorFromRGB(BgTitleColor);
        [self addSubview:_bottomView];
        
        [self createShareButton];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, BTM_HEIGHT - 60, ScreenWidth, 60)];
        [bgView setBackgroundColor:UIColor.whiteColor];
        [_bottomView addSubview:bgView];
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setFrame:CGRectMake(76, 10, ScreenWidth-76*2, 40)];
        [btnClose setTitle:@"确认" forState:UIControlStateNormal];
        [btnClose setBackgroundColor:UIColor.whiteColor];
        btnClose.layer.cornerRadius = 5.0f;
        btnClose.layer.masksToBounds = YES;
        btnClose.layer.borderColor = UIColorFromRGB(0xDBDBDB).CGColor;
        btnClose.layer.borderWidth = 1.0f;
        [btnClose setTitleColor:UIColorFromRGB(TextDarkColor) forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:btnClose];
    }
    
    return self;
}

-(void)createShareButton{
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,ScreenWidth - 20, 39)];
    [titleLabel setText:@"预约视频问诊时间"];
    [titleLabel setFont:ListTitleFont];
    [titleLabel setTextColor:UIColorFromRGB(TextDarkColor)];
    [_bottomView addSubview:titleLabel];
    
    pickerView = [[PGPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth,BTM_HEIGHT-101)];
    [pickerView addTopBorderWithColor:UIColorFromRGB(0xDBDBDB) andWidth:1.0f];
    [pickerView addBottomBorderWithColor:UIColorFromRGB(0xDBDBDB) andWidth:1.0f];
    pickerView.delegate = self;
    pickerView.dataSource = self;
//    pickerView.backgroundColor = UIColor.clearColor;
    [pickerView selectRow:2 inComponent:0 animated:YES];
    [pickerView selectRow:2 inComponent:1 animated:YES];
    //设置线条的颜色
    pickerView.lineBackgroundColor = UIColorFromRGB(BgTitleColor);
    //设置选中行的字体颜色
//    pickerView.titleColorForSelectedRow = DEEP_GRAY_COLOR;
//    //设置未选中行的字体颜色
//    pickerView.titleColorForOtherRow = BG_GRAY_COLOR;
    [_bottomView addSubview:pickerView];
    
}

-(void)shareWithButton:(UIButton *) shareButton{
    if(commitBlock){
        int secton = (int)[pickerView selectedRowInComponent:0];
        int row = (int)[pickerView selectedRowInComponent:1];
        NSDate *date = [[NSDate date] dateAfterDay:secton];
        NSString *time = _times[row];
        
        NSString *resultTime = [NSString stringWithFormat:@"%@ %@:00",dateTransformString(@"yyyy-MM-dd", date),time];
        
        commitBlock(resultTime);
    }
    [self dissmisMenu];
}



- (void)dissmisMenu{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = sheetViewF;
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}



#pragma UIPickerViewDataSource

- (CGFloat)rowHeightInPickerView:(PGPickerView *)pickerView{
    return 44.0f;
}
- (NSInteger)numberOfComponentsInPickerView:(PGPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0){
        return _weeks.count;
    }
    return _times.count;
}
#pragma UIPickerViewDelegate
//- (UIColor *)pickerView:(PGPickerView *)pickerView viewBackgroundColorForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (row == 0) {
//        return [UIColor redColor];
//    }else if (row == 1) {
//        return [UIColor orangeColor];
//    }
//    return nil;
//}

- (nullable NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0){
        return _weeks[row];
    }
    return _times[row];
}

//- (NSAttributedString *)pickerView:(PGPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSAttributedString *restr = [[NSAttributedString alloc] initWithString:@"121212" attributes:@{NSForegroundColorAttributeName:[UIColor greenColor], NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//    return restr;
//}

- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"row = %ld component = %ld", row, component);
}

@end
