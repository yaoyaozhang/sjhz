//
//  ZZKnowledgeDetailController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeDetailController.h"
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZZKnowledgeItemTextCell.h"
#define cellIndentifer @"ZZKnowledgeItemTextCell"
#import "MyButton.h"

@interface ZZKnowledgeDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    int pageNumber;
    NSMutableArray     *_listArray;
    
    UITableView        *_listTable;
}

@end

@implementation ZZKnowledgeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:convertToString(_model.className) forState:UIControlStateNormal];
    
    _listArray = [[NSMutableArray alloc] init];
    [self createTableView];
    [self beginNetRefreshData];
    
}


- (void)beginNetRefreshData{
    pageNumber = 1;
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"0" forKey:@"newsType"];
    [dict setObject:@"30" forKey:@"pageSize"];
    [dict setObject:convertIntToString(pageNumber) forKey:@"pageNum"];
    
    [ZZRequsetInterface post:API_getKnowledgeHome param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(_listTable.footer && [_listTable.footer respondsToSelector:@selector(endRefreshing)]){
            [_listTable.footer endRefreshing];
        }
        if(_listTable.header && [_listTable.header respondsToSelector:@selector(endRefreshing)]){
            [_listTable.header endRefreshing];
        }
    } complete:^(NSDictionary *dict) {
        if(pageNumber == 1){
            [_listArray removeAllObjects];
            
        }
        NSDictionary *data= dict[@"retData"];
        
        
        
        for (NSDictionary *item in data[@"jinpingke"]) {
            [_listArray addObject:[[ZZChapterModel alloc] initWithMyDict:item]];
        }
        
        
        
        [_listTable reloadData];
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [_listTable reloadData];
    } progress:^(CGFloat progress) {
        
    }];
}




#pragma mark -- tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 210 + 60 + 21;
    }
    
    if(section == 1){
        return 55*2+20+ 21*2;
    }
    
    return 55.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    if(section == 0){
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 210)];
        [img setBackgroundColor:UIColor.clearColor];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 230, ScreenWidth-30, 25)];
        [btn setTitle:[NSString stringWithFormat:@"徐顺利 北京大学第三医院"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:0];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10, 0, 10, 25)];
        [arrow setImage:[UIImage imageNamed:@"icon_arrow"]];
        [arrow setContentMode:UIViewContentModeCenter];
        [btn addSubview:arrow];
        
        UILabel *lab = [self createLabel:@"医生介绍内容休息休息"];
        
        CGRect f = lab.frame;
        f.origin.y = 250 + 25;
        lab.frame = f;
        
        
        [headerView addSubview:img];
        [headerView addSubview:btn];
        [headerView addSubview:lab];
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 270 + f.size.height)];
        return headerView;
    }else if(section == 1){
        
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [headerView addSubview:lineView];
        
        [self createMenuButton:headerView tag:1];
        
        UILabel *lab = [self createLabel:@"课程说明内容嘻嘻嘻嘻嘻嘻想"];
        
        CGRect f = lab.frame;
        f.origin.y =55;
        lab.frame = f;
        
        [headerView addSubview:lab];
        
        CGFloat y2 = f.origin.y + f.size.height + 10;
        UIImageView *lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, y2, ScreenWidth, 1.0f)];
        [lineView2 setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [headerView addSubview:lineView2];
        
        UIButton *btn = [self createMenuButton:headerView tag:2];
        CGRect bf = btn.frame;
        bf.origin.y = y2;
        
        UILabel *lab1 = [self createLabel:@"课程说明内容嘻嘻嘻嘻嘻嘻想"];
        
        CGRect f1 = lab.frame;
        f1.origin.y =y2 + 55;
        lab1.frame = f1;
        
        [headerView addSubview:lab1];
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, y2 + 55 + f1.size.height + 10)];
        
        
        
        return headerView;
    }else{
        
        [headerView setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        [lineView setBackgroundColor:UIColorFromRGB(BgLineColor)];
        [headerView addSubview:lineView];
        
        [self createMenuButton:headerView tag:1];
        
        [headerView setFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        return headerView;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 || section == 1){
        return 0;
    }
    
    
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==2){
        
        ZZKnowledgeItemTextCell *cell = (ZZKnowledgeItemTextCell*)[tableView dequeueReusableCellWithIdentifier:cellIndentifer];
        if (cell == nil) {
            cell = [[ZZKnowledgeItemTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
        }
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _listTable) {
        CGFloat sectionHeaderHeight = 10;
        
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
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



#pragma mark -- searchBar
- (void)createTableView{
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, ScreenHeight -NavBarHeight) style:UITableViewStylePlain];
    _listTable.dataSource = self;
    _listTable.delegate = self;
    [_listTable setBackgroundColor:[UIColor clearColor]];
    [_listTable setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_listTable setSeparatorColor:UIColorFromRGB(BgLineColor)];
    [_listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(iOS7){
        [_listTable setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_listTable setTableFooterView:view];
    
    [self.view addSubview:_listTable];
    // 注册
    [_listTable registerNib:[UINib nibWithNibName:cellIndentifer bundle:nil] forCellReuseIdentifier:cellIndentifer];
    [self setTableSeparatorInset];
    
    MJRefreshStateHeader *header=[MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginNetRefreshData)];
    //    header.stateLabel.hidden=YES;
    _listTable.header=header;
    
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(endNetRefreshData)];
    footer.stateLabel.hidden=YES;
    _listTable.footer=footer;
}

-(void)btnShowDropMenu:(UIButton *) btn{
    
}


-(UIButton *)createMenuButton:(UIView *) pview tag:(int) tag{
    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitleColor:UIColorFromRGB(TextBlackColor) forState:UIControlStateNormal];
    [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [btn addTarget:self action:@selector(btnShowDropMenu:) forControlEvents:UIControlEventTouchUpInside];
    if(tag == 1){
        btn.tag = 1;
        [btn setTitle:@"编辑推荐" forState:UIControlStateNormal];
    }else{
        btn.tag = 2;
        [btn setTitle:@"精品课" forState:UIControlStateNormal];
    }
    
    [btn setFrame:CGRectMake(10, 17.5, ScreenWidth-40, 30)];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    //
    UIImageView * lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 2, 20)];
    lineImg.backgroundColor = UIColorFromRGB(BgTitleColor);
    [btn addSubview:lineImg];
    
    
    [pview addSubview:btn];
    return btn;
}


-(UILabel *)createLabel:(NSString *) text{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, 0)];
    lab.numberOfLines = 0;
    lab.font = ListDetailFont;
    lab.textColor = UIColorFromRGB(TextLightDarkColor);
    [lab setText:text];
    
    [self autoWidthOfLabel:lab with:ScreenWidth - 30];
    
    return lab;
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width,FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        
        return NO;
        
    }
    
    return YES;
    
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
