//
//  ZZSymptomWTListView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/4.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSymptomWTListView.h"
#import "MyButton.h"
#import "UIView+Border.h"
#import "UIView+Extension.h"
#import "MJRefresh.h"
#import "ZZSymptomWTCell.h"
#define cellIdentifier @"ZZSymptomWTCell"

@interface ZZSymptomWTListView()<UITableViewDelegate,UITableViewDataSource,ZZSymptomWTCellDelegate>{
    CGFloat contentWidth;
    
    void(^SymptomWTBlock)(int type,id obj);
    
    NSMutableDictionary *params;
}

@property(nonatomic,strong)UIView         *contentView;
@property(nonatomic,strong)UITableView      *listTable;
@property(nonatomic,strong)NSMutableArray   *listArray;
@end

@implementation ZZSymptomWTListView

-(instancetype)initWithSymptomView:(ZZSymptomModel *)model arr:(NSMutableArray *)data check:(NSMutableDictionary *) checkMap block:(void (^)(int, id))symptomWtBlock{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
        if(!is_null(checkMap)){
            params = checkMap;
        }else{
            params = [NSMutableDictionary dictionaryWithCapacity:data.count];
        }
        _listArray = data;
        SymptomWTBlock = symptomWtBlock;
        
        self.backgroundColor = COLORWithAlpha(51, 51, 51, 0.9);
        self.clipsToBounds=YES;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        contentWidth = ScreenWidth - 60;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 40, contentWidth, ScreenHeight-80)];
        [_contentView setBackgroundColor:UIColor.whiteColor];
        [self addSubview:_contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        
        [self createTableView];
        
        
        UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 40)];
        [titleName setText:[NSString stringWithFormat:@"请选项%@的详细信息",model.sname]];
        [titleName setTextColor:UIColorFromRGB(TextDarkColor)];
        [titleName setFont:ListTitleFont];
        [titleName setTextAlignment:NSTextAlignmentCenter];
        [_contentView addSubview:titleName];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:ListTitleFont];
        [btn setTitle:@"添加完毕" forState:0];
        [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        btn.layer.cornerRadius = 5.0f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(10, _contentView.bounds.size.height - 50, contentWidth-20, 40)];
        [_contentView addSubview:btn];
        
        UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDel.titleLabel setFont:ListTitleFont];
        [btnDel setImage:[UIImage imageNamed:@"close"] forState:0];
        [btnDel setBackgroundColor:UIColor.clearColor];
        [btnDel.imageView setContentMode:UIViewContentModeScaleAspectFill];
        btnDel.layer.cornerRadius = 5.0f;
        btnDel.layer.masksToBounds = YES;
        [btnDel addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        [btnDel setFrame:CGRectMake( contentWidth + 20, 30, 30, 30)];
        [self addSubview:btnDel];
        
    }
    
    return self;
}

-(void)addClick:(UIButton *) btn{
    if(params.allKeys.count < _listArray.count){
        [self makeToast:@"请填写完整"];
        return;
    }
    if(SymptomWTBlock){
        SymptomWTBlock(1,params);
    }
    [self tapClick];
}



-(void)tapClick{
    [self dissmisMenu];
}



- (void)dissmisMenu{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    //    [UIView animateWithDuration:0.25 animations:^{
    //
    //        self.frame = sheetViewF;
    //        self.alpha = 0.0;
    //
    //    } completion:^(BOOL finished) {
    [self removeFromSuperview];
    //    }];
}

-(void)show{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}





-(void)createTableView{
    
    _listTable=[_contentView createTableView:self cell:cellIdentifier];
    
    [_listTable setFrame:CGRectMake(0, 40, contentWidth, _contentView.bounds.size.height - 100)];
    
    
    [_listTable setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    if (iOS7) {
        _listTable.backgroundView = nil;
    }
    
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    [self setTableSeparatorInset];
    
    [_listTable reloadData];
}



#pragma mark UITableView delegate Start
// 返回section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 返回section高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else{
        return 25;
    }
}

// 返回section 的View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        [view setBackgroundColor:UIColorFromRGB(BgSystemColor)];
        
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth-24, 25)];
        [label setFont:ListDetailFont];
        [label setText:@"gansha a"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setTextColor:UIColorFromRGB(TextBlackColor)];
        [view addSubview:label];
        return view;
    }
    return nil;
}

// 返回section下得行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listArray==nil){
        return 0;
    }
    return _listArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZSymptomWTCell *cell = (ZZSymptomWTCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ZZSymptomWTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if(indexPath.row==_listArray.count-1){
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.delegate = self;
    cell.pwidth = contentWidth;
    
    ZZSymptomWTModel *model=[_listArray objectAtIndex:indexPath.row];
    
    [cell dataToView:model check:params];
    
    
    return cell;
}

-(void)onItemClick:(ZZSymptomWTModel *)model text:(NSString *)text check:(BOOL)isChecked{
    
    NSString *value = convertToString([params objectForKey:convertIntToString(model.symptomWtId)]);
    
    if(!isChecked){
        value = [value stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@;",text] withString:@""];
        [params removeObjectForKey:convertIntToString(model.symptomWtId)];
    }else{
        if(model.type != 2){
            value = @"";
        }
        value = [value stringByAppendingFormat:@"%@;",text];
    }
    [params setObject:value forKey:convertIntToString(model.symptomWtId)];
    
    [_listTable reloadData];
}



// 是否显示删除功能
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

// 删除清理数据
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
}


// table 行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 70.0f;
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
}

// table 行的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_listArray==nil || _listArray.count<indexPath.row){
        return;
    }
    
    
}

//设置分割线间距
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if((indexPath.row+1) < _listArray.count){
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:inset];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:inset];
        }
    }
}

-(void)viewDidLayoutSubviews{
    [self setTableSeparatorInset];
}

#pragma mark UITableView delegate end

/**
 *  设置UITableView分割线空隙
 */
-(void)setTableSeparatorInset{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 0);
    if ([_listTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listTable setSeparatorInset:inset];
    }
    
    if ([_listTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listTable setLayoutMargins:inset];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
