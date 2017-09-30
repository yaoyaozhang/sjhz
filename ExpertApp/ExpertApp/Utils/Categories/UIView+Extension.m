//
//  UIView+Extension.m
//  ExpertApp
//
//  Created by 张新耀 on 15/9/1.
//  Copyright © 2015年 com.Expert.chat. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

-(UITableView *)createTableView:(id)delegate{
    return [self createTableView:delegate cell:nil formY:NavBarHeight withHeight:ScreenHeight-NavBarHeight];
}

-(UITableView *)createTableView:(id)delegate cell:(NSString *)cellIdentifier{
    return [self createTableView:delegate cell:cellIdentifier formY:NavBarHeight withHeight:ScreenHeight-NavBarHeight];
}


-(UITableView *)createTableView:(id)delegate cell:(NSString *)cellIdentifier formY:(CGFloat)y withHeight:(CGFloat)height{
    UITableView *listTable=[[UITableView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, height)];
    // 设置table代理
    listTable.dataSource=delegate;
    listTable.delegate=delegate;
    [listTable setBackgroundColor:[UIColor clearColor]];
    [listTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    
    // 注册cell
    if(cellIdentifier!=nil && cellIdentifier){
        [listTable registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        // 如果cell不是使用xib加载，请外部按以下方式实现
//        [listTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    
    [listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [listTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if(iOS7){
        [listTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [listTable setTableFooterView:view];
    
    // 添加table到当前view上
    [self addSubview:listTable];
    
    return listTable;
    
}
#pragma mark --重写setter 和gettter方法
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}




- (void)setMaxX:(CGFloat)maxX{
    CGRect frame = self.frame;
    frame.origin.x = maxX - frame.size.width;
    self.frame = frame;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    CGRect frame = self.frame;
    frame.origin.y = maxY - frame.size.height;
    self.frame = frame;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
