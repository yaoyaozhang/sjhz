//
//  ZZChapterListController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChapterListController.h"

#import "UIView+Extension.h"
#import "MJRefresh.h"

#import "ZZChannelCell.h"
static NSString * const reuseID  = @"ZZChannelCell";

#import "ZZChannelLabel.h"

@interface ZZChapterListController () <UICollectionViewDelegate, UICollectionViewDataSource>
/** 频道数据模型 */
@property (nonatomic, strong) NSMutableArray *channelList;
/** 当前要展示频道 */
@property (nonatomic, strong) NSMutableArray *list_now; // 功能待完善
/** 已经删除的频道 */
@property (nonatomic, strong) NSMutableArray *list_del; // 功能待完善

/** 频道列表 */
@property (nonatomic, strong) UIScrollView *smallScrollView;
/** 新闻视图 */
@property (nonatomic, strong) UICollectionView *bigCollectionView;
/** 下划线 */
@property (nonatomic, strong) UIView *underline;

@end

@implementation ZZChapterListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTitleMenu];
    [self.menuTitleButton setTitle:@"知识" forState:UIControlStateNormal];
    self.menuLeftButton.hidden = YES;
    
    
    [self createTableView];
}



-(void)createTableView{
    [self.view addSubview:self.smallScrollView];
    [self.view addSubview:self.bigCollectionView];
}


/**
 加载更多
 */
-(void)getChannelListByNetWork{
    _channelList = [NSMutableArray arrayWithCapacity:5];
//    <option value="0">请选择类别</option>
//    <option value="1">运动</option>
//    <option value="2">减肥</option>
//    <option value="3">妇科</option>
    NSArray *localList = @[
                             @{@"topicid":@"0",@"tname":@"全部",@"tid":@"0",@"urlString":@"0"},
                             @{@"topicid":@"1",@"tname":@"运动",@"tid":@"1",@"urlString":@"1"},
                             @{@"topicid":@"2",@"tname":@"减肥",@"tid":@"2",@"urlString":@"2"},
                             @{@"topicid":@"3",@"tname":@"妇科",@"tid":@"3",@"urlString":@"3"}];
    for(NSDictionary *dict in localList){
        [_channelList addObject:[[ZZChannelModel alloc] initWithMyDict:dict]];
    }
}




#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _list_now.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    ZZChannelModel *channel = _list_now[indexPath.row];
    cell.urlString = channel.urlString;
    
    // 如果不加入响应者链，则无法利用NavController进行Push/Pop等操作。
    [self addChildViewController:(UIViewController *)cell.newsTVC];
    return cell;
}


#pragma mark - UICollectionViewDelegate
/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= [self getLabelArrayFromSubviews].count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = [self getLabelArrayFromSubviews].count - 1;
    }
    
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    ZZChannelLabel *labelLeft  = [self getLabelArrayFromSubviews][leftIndex];
    ZZChannelLabel *labelRight = [self getLabelArrayFromSubviews][rightIndex];
    
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    
    //	 NSLog(@"value = %f leftIndex = %zd, rightIndex = %zd", value, leftIndex, rightIndex);
    //	 NSLog(@"左%f 右%f", scaleLeft, scaleRight);
    //	 NSLog(@"左：%@ 右：%@", labelLeft.text, labelRight.text);
    
    // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    
    // 下划线动态跟随滚动：马勒戈壁的可算让我算出来了
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
}

/** 手指滑动BigCollectionView，滑动结束后调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.bigCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

/** 手指点击smallScrollView */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigCollectionView.width;
    // 滚动标题栏到中间位置
    ZZChannelLabel *titleLable = [self getLabelArrayFromSubviews][index];
    CGFloat offsetx   =  titleLable.center.x - _smallScrollView.width * 0.5;
    CGFloat offsetMax = _smallScrollView.contentSize.width - _smallScrollView.width;
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    [_smallScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    
    // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
    for (ZZChannelLabel *label in [self getLabelArrayFromSubviews]) {
        label.textColor = [UIColor blackColor];
    }
    // 下划线滚动并着色
    [UIView animateWithDuration:0.5 animations:^{
        _underline.width = titleLable.textWidth;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = UIColorFromRGB(BgTitleColor);
    }];
}




#pragma mark - getter
- (NSMutableArray *)channelList
{
    if (_channelList == nil) {
        [self getChannelListByNetWork];
    }
    return _channelList;
}

- (UIScrollView *)smallScrollView
{
    if (_smallScrollView == nil) {
        _smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth, 44)];
        _smallScrollView.backgroundColor = [UIColor whiteColor];
        _smallScrollView.showsHorizontalScrollIndicator = NO;
        // 设置频道
        _list_now = self.channelList.mutableCopy;
        [self setupChannelLabel];
        // 设置下划线
        [_smallScrollView addSubview:({
            ZZChannelLabel *firstLabel = [self getLabelArrayFromSubviews][0];
            firstLabel.textColor = UIColorFromRGB(BgTitleColor);
            // smallScrollView高度44，取下面4个点的高度为下划线的高度。
            _underline = [[UIView alloc] initWithFrame:CGRectMake(0, 40, firstLabel.textWidth, 4)];
            _underline.centerX = firstLabel.centerX;
            _underline.backgroundColor = UIColorFromRGB(BgTitleColor);
            _underline;
        })];
    }
    return _smallScrollView;
}

- (UICollectionView *)bigCollectionView
{
    if (_bigCollectionView == nil) {
        // 高度 = 屏幕高度 - 导航栏高度64 - 频道视图高度44
        CGFloat h = ScreenHeight - NavBarHeight - self.smallScrollView.height ;
        CGRect frame = CGRectMake(0, self.smallScrollView.maxY, ScreenWidth, h);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bigCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _bigCollectionView.backgroundColor = [UIColor clearColor];
        _bigCollectionView.delegate = self;
        _bigCollectionView.dataSource = self;
        [_bigCollectionView registerClass:[ZZChannelCell class] forCellWithReuseIdentifier:reuseID];
        
        // 设置cell的大小和细节
        flowLayout.itemSize = _bigCollectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _bigCollectionView.pagingEnabled = YES;
        _bigCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _bigCollectionView;
}



#pragma mark -
/** 设置频道标题 */
- (void)setupChannelLabel
{
    CGFloat margin = 20.0;
    CGFloat x = 0; //x = 8;
    CGFloat h = _smallScrollView.bounds.size.height;
    CGFloat marginX = ScreenWidth/_list_now.count;
    int i = 0;
    for (ZZChannelModel *channel in _list_now) {
        ZZChannelLabel *label = [ZZChannelLabel channelLabelWithTitle:channel.tname];
        if(label.width<marginX){
            label.frame = CGRectMake(x + (marginX - label.width - margin)/2, 0, label.width + margin, h);
            x += marginX;
        }else{
            label.frame = CGRectMake(x, 0, label.width + margin, h);
            x += label.bounds.size.width;
        }
        [_smallScrollView addSubview:label];
        
        label.tag = i++;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    }
    _smallScrollView.contentSize = CGSizeMake(x + margin, 0);
}

/** 频道Label点击事件 */
- (void)labelClick:(UITapGestureRecognizer *)recognizer
{
    ZZChannelLabel *label = (ZZChannelLabel *)recognizer.view;
    // 点击label后，让bigCollectionView滚到对应位置。
    [_bigCollectionView setContentOffset:CGPointMake(label.tag * _bigCollectionView.frame.size.width, 0)];
    // 重新调用一下滚定停止方法，让label的着色和下划线到正确的位置。
    [self scrollViewDidEndScrollingAnimation:self.bigCollectionView];
}

/** 获取smallScrollView中所有的DDChannelLabel，合成一个数组，因为smallScrollView.subViews中有其他非Label元素 */
- (NSArray *)getLabelArrayFromSubviews
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ZZChannelLabel *label in _smallScrollView.subviews) {
        if ([label isKindOfClass:[ZZChannelLabel class]]) {
            [arrayM addObject:label];
        }
    }
    return arrayM.copy;
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
