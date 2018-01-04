//
//  ZZSymptomView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/2.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomView.h"
#import "UIImage+ImageWithColor.h"
#import "MyButton.h"
#import "ZZSymptomModel.h"

@interface ZZSymptomView()
{
    CGFloat h;
    CGFloat w;
    NSMutableArray *items;
    void(^SymptomActionBlock)(ZCSymptomAction action,int index,id obj);
}
@end

@implementation ZZSymptomView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled=YES;
    
//    [self setAutoresizesSubviews:YES];
    
    self.backgroundColor = UIColorFromRGB(TextWhiteColor);
    self.backgroundColor = UIColor.redColor;
    
    //表情盘
    faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    faceView.pagingEnabled = YES;
    faceView.showsHorizontalScrollIndicator = NO;
    faceView.showsVerticalScrollIndicator = NO;
    [faceView setBackgroundColor:UIColorFromRGB(BgRedColor)];
    [faceView setAutoresizesSubviews:YES];
    faceView.delegate = self;
    [faceView setBackgroundColor:UIColor.greenColor];
    //添加键盘View
    [self addSubview:faceView];
    
    
    //添加PageControl
    facePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    
    [facePageControl addTarget:self
                        action:@selector(pageChange:)
              forControlEvents:UIControlEventValueChanged];
    facePageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    facePageControl.currentPageIndicatorTintColor=[UIColor darkGrayColor];
    facePageControl.currentPage = 0;
    [self addSubview:facePageControl];
}

-(id)initZZSymptomView{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled=YES;
        
        [self setAutoresizesSubviews:YES];
        
        self.backgroundColor = UIColor.whiteColor;
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 0)];
        faceView.pagingEnabled = YES;
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.alwaysBounceVertical = NO;
        [faceView setBackgroundColor:UIColorFromRGB(BgRedColor)];
        [faceView setAutoresizesSubviews:YES];
        faceView.delegate = self;
        [faceView setBackgroundColor:UIColor.clearColor];
        //添加键盘View
        [self addSubview:faceView];
        
        
        //添加PageControl
        facePageControl = [[UIPageControl alloc] init];
        [facePageControl setBackgroundColor:UIColor.clearColor];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        facePageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
        facePageControl.currentPageIndicatorTintColor=[UIColor darkGrayColor];
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
    }
    
    return self;
}

-(void)setItemValues:(NSMutableDictionary *)itemMap block:(void (^)(ZCSymptomAction, int , id))symptomActionBlock{
    SymptomActionBlock = symptomActionBlock;
    
    items = itemMap[@"data"];
    CGFloat ch = 150;
    if(items.count > 8){
        facePageControl.hidden = NO;
        ch = 150;
        [facePageControl setFrame:CGRectMake(0, 130, 0, 20)];
        [faceView setFrame:CGRectMake(0, 20, ScreenWidth, 90)];
    }else{
        facePageControl.hidden = YES;
        if(items.count < 5){
            ch = 70;
        }
        if(items.count > 4){
            ch = 120;
        }
        
        [faceView setFrame:CGRectMake(0, 20, ScreenWidth, ch - 30)];
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, ch+10)];
    
    
    for (UIView *item in faceView.subviews) {
        [item removeFromSuperview];
    }
    
    // 全部宽度
    CGFloat width=(ScreenWidth-10);
    
    // 框的大小
    CGFloat EmojiWidth  = width/4;
    
    // 框的高度
    CGFloat EmojiHeight = 40;
    
    // 列数
    int columns         = 4;
    
    // 当宽度无法除尽时，表情居中
    int allSize         = (int)items.count;
    int rows            = 2;
    int pageSize        = rows * columns;
    int pageNum         = (allSize%pageSize==0) ? (allSize/pageSize) : (allSize/pageSize+1);
    
    faceView.contentSize = CGSizeMake(pageNum * ScreenWidth, faceView.bounds.size.height);
    facePageControl.numberOfPages = pageNum;
    
    for(int i=0; i< pageNum; i++){
        for (int j=0; j<pageSize; j++) {
            ZZSymptomModel *faceDict = [items objectAtIndex:i*pageSize+j];
            MyButton *faceButton = [MyButton buttonWithType:UIButtonTypeCustom];
            
            faceButton.tag = i*pageSize+j;
            faceButton.objTag=faceDict;
            
            [faceButton setTitleColor:UIColorFromRGB(TextDarkColor) forState:0];
            [faceButton setTitle:faceDict.sname forState:UIControlStateNormal];
            [faceButton.titleLabel setFont:ListTitleFont];
            [faceButton setUserInteractionEnabled:YES];
            [faceButton addTarget:self
                           action:@selector(faceClickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = 10 + i * width + (j%columns) * EmojiWidth + i*10;
            
            CGFloat y = 0;
            if(j>=columns){
                y = (j / columns) * EmojiHeight + 10;
            }
            faceButton.frame = CGRectMake( x, y, EmojiWidth-10, EmojiHeight);
            [faceButton setTitleEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
            [faceButton setBackgroundColor:UIColorFromRGB(BgSystemColor)];
            faceButton.layer.cornerRadius = 5.0f;
            faceButton.layer.masksToBounds = YES;
            [faceView addSubview:faceButton];
            
            if([@"1" isEqual:convertToString(itemMap[@"isCheck"])]){
                MyButton *delBtn = [MyButton buttonWithType:UIButtonTypeCustom];
                [delBtn setImage:[UIImage imageNamed:@"close"] forState:0];
                [delBtn setFrame:CGRectMake(EmojiWidth-30, 0, 20, 20)];
                delBtn.objTag = faceDict;
                delBtn.tag = i*pageSize+j;
                [delBtn addTarget:self action:@selector(delButton:) forControlEvents:0];
                [faceButton addSubview:delBtn];
            }
            
            if((i*pageSize+j+1)>=allSize){
                break;
            }
        }
    }
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [facePageControl setCurrentPage:faceView.contentOffset.x / ScreenWidth];
    NSLog(@"%f",faceView.contentOffset.x / ScreenWidth)
    // 更新页码
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * ScreenWidth, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)delButton:(id)sender {
    MyButton *btn = (MyButton*)sender;
    if(self.delegate){
        [self.delegate onItemClick:btn.objTag type:ZCSymptomActionDel index:(int)btn.tag];
    }
    if(SymptomActionBlock){
        SymptomActionBlock(ZCSymptomActionDel,(int)btn.tag,btn.objTag);
    }
    
}
- (void)faceClickButton:(id)sender {
    MyButton *btn = (MyButton*)sender;
    if(self.delegate){
        [self.delegate onItemClick:btn.objTag type:ZCSymptomActionEiit index:(int)btn.tag];
    }
    if(SymptomActionBlock){
        SymptomActionBlock(ZCSymptomActionEiit,(int)btn.tag,btn.objTag);
    }
    
}

@end
