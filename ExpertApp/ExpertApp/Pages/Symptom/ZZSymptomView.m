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

@interface ZZSymptomView()
{
    CGFloat h;
    CGFloat w;
    NSMutableArray *items;
    void(^SymptomActionBlock)(ZCSymptomAction action,NSString *text,id obj);
}
@end

@implementation ZZSymptomView


-(id)initZZSymptomView{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled=YES;
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [self setAutoresizesSubviews:YES];
        
        self.backgroundColor = UIColorFromRGB(TextWhiteColor);
        
        if(_faceMap==nil){
            _faceMap = @[];
        }
        
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        faceView.pagingEnabled = YES;
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        [faceView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [faceView setAutoresizesSubviews:YES];
        faceView.delegate = self;
        //添加键盘View
        [self addSubview:faceView];
        
        
        //添加PageControl
        facePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth/2-50, 0, 100, 20)];
        [facePageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        [facePageControl setAutoresizesSubviews:YES];
        
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

-(void)setItemValues:(NSMutableArray *)arrs block:(void (^)(ZCSymptomAction, NSString *, id))symptomActionBlock{
    SymptomActionBlock = symptomActionBlock;
    
    items = arrs;
    CGFloat ch = 110;
    if(items.count > 8){
        facePageControl.hidden = NO;
        ch = 110;
        [facePageControl setFrame:CGRectMake(ScreenWidth/2-50, 90, 100, 20)];
    }else{
        facePageControl.hidden = YES;
        if(items.count < 5){
            ch = 64;
        }
        if(items.count > 4){
            ch = 110;
        }
    }
    [faceView setFrame:CGRectMake(0, 0, ScreenWidth, ch-20)];
    [self setFrame:CGRectMake(0, 0, ScreenWidth, ch)];
    
    
    for (UIView *item in faceView.subviews) {
        [item removeFromSuperview];
    }
    
    // 全部宽度
    CGFloat width=(ScreenWidth-40);
    
    // 框的大小
    CGFloat EmojiWidth  = (ScreenWidth-70)/4;
    
    // 框的高度
    CGFloat EmojiHeight = 44;
    
    // 列数
    int columns         = (width-30)/EmojiWidth;
    
    // 当宽度无法除尽时，表情居中
    CGFloat itemX       = (width - columns * EmojiWidth)/2;
    
    int allSize         = (int)_faceMap.count;
    int rows            = (self.frame.size.height-20)/44;
    int pageSize        = rows * columns;
    int pageNum         = (allSize%pageSize==0) ? (allSize/pageSize) : (allSize/pageSize+1);
    
    faceView.contentSize = CGSizeMake(pageNum * width, ch - 20);
    facePageControl.numberOfPages = pageNum;
    
    for(int i=0; i< pageNum; i++){
        for (int j=0; j<pageSize; j++) {
            NSDictionary *faceDict = [_faceMap objectAtIndex:i*pageSize+j];
            MyButton *faceButton = [MyButton buttonWithType:UIButtonTypeCustom];
            
            faceButton.tag = i*pageSize+j;
            faceButton.objTag=faceDict;
            
            //            [faceButton setTitle:faceKey forState:UIControlStateNormal];
            //            [faceButton.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
            [faceButton setUserInteractionEnabled:YES];
            [faceButton addTarget:self
                           action:@selector(faceClickButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            CGFloat x = i * width + (j%columns) * EmojiWidth+itemX;
            
            CGFloat y = 8;
            if(j>=columns){
                y = (j / columns) * EmojiHeight + 8;
            }
            faceButton.frame = CGRectMake( x, y, EmojiWidth, EmojiHeight);
            [faceButton setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
            [faceButton setBackgroundColor:[UIColor clearColor]];
            
            [faceView addSubview:faceButton];
            
            if((i*pageSize+j+1)>=allSize){
                break;
            }
        }
    }
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [facePageControl setCurrentPage:faceView.contentOffset.x / ScreenWidth];
    // 更新页码
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * ScreenWidth, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceClickButton:(id)sender {
    MyButton *btn = (MyButton*)sender;
    
    if(SymptomActionBlock){
        SymptomActionBlock(ZCSymptomActionEiit,btn.titleLabel.text,btn);
    }
    
}

- (void)backFace:(id)sender{
    MyButton *btn = (MyButton*)sender;
    if(SymptomActionBlock){
        SymptomActionBlock(ZCSymptomActionDel,btn.titleLabel.text,btn);
    }
}

@end
