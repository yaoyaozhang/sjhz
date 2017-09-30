//
//  ZCActionMenu.m
//  ExpertApp
//
//  Created by zhangxy on 16/5/18.
//  Copyright © 2016年 com.Expert.chat.app. All rights reserved.
//

#import "ZCActionMenu.h"

#import "UIView+Extension.h"

#import "ZCMenuCell.h"
#define cellIndentifer @"ZCMenuCell"

@interface ZCActionMenu()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSArray * items;
    void(^ItemClickBlock)(ZCMenuItem *item);
    BOOL isShow;
}

@property (nonatomic, weak  ) UITableView *listTable;


@end

@implementation ZCActionMenu
- (instancetype)initWithDelegate:(id<ZCActionMenuDelegate>)delegate arr:(NSArray *)array{
    self = [super initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, 0)];
    if (self)
    {
        self.alpha = 1;
        self.delegate = delegate;
        items = array;
        
        self.backgroundColor = UIColorFromRGBAlpha(0x969696, 0.3);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisMenu)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.listTable = [self createTableView:self];
        if(items!=nil && items.count > 0){
            [self.listTable registerClass:[ZCMenuCell class] forCellReuseIdentifier:cellIndentifer];
            [self.listTable setFrame:CGRectMake(0, 0, ScreenWidth, 0)];
            [self.listTable setBounces:NO];
            [self.listTable reloadData];
        }
        
    }
    
    return self;
}

-(void) setActionClickBlock:(void (^)(ZCMenuItem *))clickblock{
    ItemClickBlock = clickblock;
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
        
        return NO;
    
    else
        
        return YES;
    
}


#pragma mark UITableView delegate Start
// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return items.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZCMenuCell *cell = (ZCMenuCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[ZCMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
    
    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(BgLineColor)];

    [cell InitDataToView:items[indexPath.row]];
    
    return cell;
}

// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ItemHeight;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 让代理去执行方法
    if ([self.delegate respondsToSelector:@selector(onActionMenuItem:)]) {
        [self.delegate onActionMenuItem:[items objectAtIndex:indexPath.row]];
    }
    if(ItemClickBlock){
        ItemClickBlock([items objectAtIndex:indexPath.row]);
    }
    [self dissmisMenu];
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < items.count){
        [self setTableSeparatorInset];
    }
}


-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}
/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    if ([_listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTable setSeparatorInset:inset];
    }
    
    if ([_listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTable setLayoutMargins:inset];
    }
}



- (void)dissmisMenu{
    isShow = NO;
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = NavBarHeight;
    sheetViewF.size.height = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = sheetViewF;
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self.listTable removeFromSuperview];
        [self removeFromSuperview];
    }];
}

-(void)show{
    isShow = YES;
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = NavBarHeight;
    sheetViewF.size.height = ScreenHeight - NavBarHeight;
    
    
    CGRect cf = self.listTable.frame;
    cf.size.height = ScreenHeight - NavBarHeight;
    self.listTable.frame = cf;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}

-(BOOL) isShowing{
    return isShow;
}

// button的点击事件
- (void)sheetBtnClick:(UIButton *)btn{
    if (btn.tag == 0) {
        [self dissmisMenu];
        return;
    }
}

@end
