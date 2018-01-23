//
//  ZZUserHomeController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZUserHomeController.h"
#import "ZZSearchDoctorController.h"
#import "EasyTableView.h"
#import "ZZUserHomeCell.h"
#import "ASQListController.h"

#import "ZZDoctorDetailController.h"

#import "ZZChoosePatientController.h"

#import "UserIndexController.h"

#import "SDCycleScrollView.h"
#define cellIdentifier  @"ZZUserHomeCell"

#import "ZZSearchResultController.h"



#define ZZHomeTopHeight 220
#define ZZHomeMiddleHeight 175


typedef NS_ENUM(NSInteger,ZZHomeButtonTags){
    ZZHomeButtonTags1       = 1,
    ZZHomeButtonTags2       = 2,
    ZZHomeButtonTagsMore    = 3,
};

@interface ZZUserHomeController ()<EasyTableViewDelegate,SDCycleScrollViewDelegate>{
    CGFloat contentSizeHeight;
}

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong) EasyTableView *horizontalView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) NSMutableArray *headerArr;
@property (nonatomic,strong) NSMutableArray *docArr;
@property (nonatomic,strong) NSMutableArray *lmArr;



@end

@implementation ZZUserHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"用户" forState:UIControlStateNormal];
    [self.menuRightButton setImage:[UIImage imageNamed:@"icon_menu_search"] forState:UIControlStateNormal];
    self.menuLeftButton.hidden = YES;
    
    [self cretateScrollView];
    
    [[ZZDataCache getInstance] getCacheConfigDict:^(NSMutableDictionary *dict, int status) {
        
    }];
    
    
    _headerArr = [[NSMutableArray alloc] init];
    _docArr = [[NSMutableArray alloc] init];
    _lmArr = [[NSMutableArray alloc] init];
    
    [self beginNetRefreshData];
}

#pragma mark -- 上拉加载
- (void)beginNetRefreshData{
    [SVProgressHUD show];
    [self endNetRefreshData];
}

-(void)endNetRefreshData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString([[ZZDataCache getInstance] getLoginUser].userId) forKey:@"userId"];
    [ZZRequsetInterface post:API_findUserNewHome param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    } complete:^(NSDictionary *dict) {
        NSArray *arr1 = dict[@"retData"][@"doctor"];
        NSArray *arr2 = dict[@"retData"][@"gauge"];
        NSArray *arr3 = dict[@"retData"][@"home"];
        if(!is_null(arr1)){
            for (NSDictionary *item in arr1) {
                [_docArr addObject:[[ZZUserInfo alloc] initWithMyDict:item]];
            }
        }
        if(!is_null(arr3)){
            [_headerArr addObjectsFromArray:arr3];
        }
        if(!is_null(arr2)){
            [_lmArr addObjectsFromArray:arr2];
        }
        
        
        if(_headerArr.count == 0){
            [self createPlaceholderView:@"网络开小差了！" message:@"" image:nil withView:_mainScrollView action:^(UIButton *button) {
                [self endNetRefreshData];
            }];
        }else{
            [self removePlaceholderView];
            
            
            // 顶部功能按钮
            [self createFirstMenu];
            
            // 中间可滑动模块
            [self createEasyTable];
            
            
            // 底部科室
            [self createKeShi];
            
            
            [_horizontalView reload];
            
            
            [_mainScrollView setContentSize:CGSizeMake(ScreenWidth, contentSizeHeight)];
        }
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
}

-(void)buttonClick:(UIButton *)sender{
    if(sender.tag == RIGHT_BUTTON){
        ZZSearchDoctorController *vc = [[ZZSearchDoctorController alloc] init];
        [self openNav:vc sound:nil];
    }
    if(sender.tag == ZZHomeButtonTagsMore){
        
        UserIndexController *vc = [[UserIndexController alloc] init];
        [self openNav:vc sound:nil];
    }
     NSLog(@"%zd",sender.tag);
}

-(void)tapItemClick:(UITapGestureRecognizer *) tap{
    int tag = (int)tap.view.tag;
    NSDictionary *item = _lmArr[tag];
    ASQListController *vc = [[ASQListController alloc] init];
    vc.code = item[@"code"];
    vc.type = ASQTYPELB;
    [self openNav:vc sound:nil];
    NSLog(@"%d",tag);
    
    
}


-(void) cretateScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, self.view.frame.size.height - NavBarHeight - 50)];
    [_mainScrollView setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    [self.view addSubview:_mainScrollView];
    
}

-(void)createFirstMenu{
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    [menuView setBackgroundColor:[UIColor whiteColor]];
    [_mainScrollView addSubview:menuView];
    
    SDCycleScrollView *cycleView = [self setupCycleImageCell];
    [menuView addSubview:cycleView];
    [menuView setFrame:cycleView.bounds];
    [_mainScrollView addSubview:menuView];
    
    
}

#pragma mark - 图片轮播
/** 设置轮播图 */
- (SDCycleScrollView  *)setupCycleImageCell
{
    // 网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ZZHomeTopHeight) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_big"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    cycleScrollView.titlesGroup = ({
        NSMutableArray *titleArrayM = [NSMutableArray array];
        for (int i = 0; i < _headerArr.count; i++) {
            NSDictionary *item = _headerArr[i];
            [titleArrayM addObject:item[@"title"]];
        }
        
        titleArrayM;
    });
    
    cycleScrollView.imageURLStringsGroup = ({
        NSMutableArray *urlArrayM = [NSMutableArray array];
        for (int i = 0; i < _headerArr.count; i++) {
            NSDictionary *item = _headerArr[i];
            [urlArrayM addObject:item[@"url"]];
        }
        
        urlArrayM;
    });
    cycleScrollView.delegate = self;
    
    return cycleScrollView;
}

/** SDCycleScrollView轮播点击事件代理 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *item = _headerArr[index];
    NSLog(@"%@",item);
    ZZChoosePatientController *vc = [[ZZChoosePatientController alloc] init];
    vc.doctorId  = @"1";
    [self openNav:vc sound:nil];
}



-(void)createKeShi{
    CGFloat y = ZZHomeTopHeight + 10 + ZZHomeMiddleHeight + 10;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 50)];
    titleView.layer.contents = (id)[UIImage imageNamed:@"classificationbgl"].CGImage;
    [_mainScrollView addSubview:titleView];
    
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [_headerLabel setBackgroundColor:[UIColor clearColor]];
    [_headerLabel setFont:ListTitleFont];
    [_headerLabel setText:@"按分类找量表"];
    [_headerLabel setTextAlignment:NSTextAlignmentCenter];
    [_headerLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    [titleView addSubview:_headerLabel];
    
    y = y + 50;
    UIView *keShiView = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 0)];
    [keShiView setBackgroundColor:[UIColor clearColor]];
    [_mainScrollView addSubview:keShiView];
    

    [keShiView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat itemX = 0;
    CGFloat itemY = 0;
    CGFloat w = (ScreenWidth-2)/3;
    int count = (int)_lmArr.count;
    for(int i=1;i<=count;i++){
        NSDictionary *dictItem = _lmArr[i-1];
        CGRect itemF = CGRectMake(itemX, itemY + 1, w, 89);
        [keShiView addSubview:[self createKeshiItem:itemF image:@"" text:[NSString stringWithFormat:@"%@",dictItem[@"name"]] tag:i-1]];
        
        itemX = itemX + 1 + w;
        if(i%3==0){
            itemX = 0;
            itemY = itemY + 90;
        }
    }
    if(count%3!=0){
        itemY = itemY + 90;
    }
    
    [keShiView setFrame:CGRectMake(0, y, ScreenWidth, itemY)];
    
    contentSizeHeight = itemY + y;
}


-(UIView *) createKeshiItem:(CGRect )f image:(NSString *) imageName text:(NSString *)titleText tag:(ZZHomeButtonTags) tag{
    UIView *itemView = [[UIView alloc] initWithFrame:f];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    itemView.tag = tag;
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 25, 25, 25)];
    [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"scale_%zd",((int)tag>9)?tag-9:tag+1]]];
    [imgView setBackgroundColor:[UIColor clearColor]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [itemView addSubview:imgView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, f.size.width, 21.0f)];
    [textLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    [textLabel setFont:ListDetailFont];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:titleText];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [itemView addSubview:textLabel];
    
    UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemClick:)];
    [itemView addGestureRecognizer:tapGuester];
    return itemView;
}


-(void)createEasyTable{
    CGFloat y = ZZHomeTopHeight + 10;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 50)];
    titleView.layer.contents = (id)[UIImage imageNamed:@"classificationbg"].CGImage;
    [_mainScrollView addSubview:titleView];
    
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [_headerLabel setBackgroundColor:[UIColor clearColor]];
    [_headerLabel setFont:ListTitleFont];
    [_headerLabel setText:@"名医入驻"];
    [_headerLabel setTextAlignment:NSTextAlignmentCenter];
    [_headerLabel setTextColor:UIColorFromRGB(TextBlackColor)];
    [titleView addSubview:_headerLabel];
    
    UIButton *btnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnButton setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [btnButton setFrame:CGRectMake(ScreenWidth - 50, 0, 50, 50)];
    [btnButton setContentMode:UIViewContentModeCenter];
    [btnButton setBackgroundColor:[UIColor clearColor]];
    btnButton.tag = ZZHomeButtonTagsMore;
    [titleView addSubview:btnButton];
    
    
    y = y+50;
    CGRect frameRect	= CGRectMake(0, y, ScreenWidth, 125.0f);
    self.horizontalView = [[EasyTableView alloc] initWithFrame:frameRect ofWidth:331.0f];
    self.horizontalView.delegate					= self;
    self.horizontalView.tableView.backgroundColor	= [UIColor clearColor];
    self.horizontalView.tableView.allowsSelection	= YES;
    self.horizontalView.tableView.separatorColor	= [UIColor clearColor];
    self.horizontalView.autoresizingMask			= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.horizontalView.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [_mainScrollView addSubview:self.horizontalView];
}

-(NSInteger)easyTableView:(EasyTableView *)easyTableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)easyTableView:(EasyTableView *)easyTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZUserHomeCell *cell = [easyTableView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // Create a new table view cell
        cell = [[ZZUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:cell.bounds]];
    //    [cell.selectedBackgroundView setBackgroundColor:UIColorFromRGB(LineListColor)];
    
    // selectedIndexPath can be nil so we need to test for that condition
    [cell dataToView:_docArr[indexPath.row]];
    
    
    return cell;
}
-(void)easyTableView:(EasyTableView *)easyTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZUserInfo *info = _docArr[indexPath.row];
    ZZDoctorDetailController *vc = [[ZZDoctorDetailController alloc] init];
    vc.docId = info.userId;
    [self openNav:vc sound:nil];
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
