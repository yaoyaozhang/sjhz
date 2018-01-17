//
//  ZZRSTableController.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/15.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZRSTableController.h"
#import "ZZSearchResultCell.h"
#import "ZZRSTableController.h"
#import "UIImage+ImageWithColor.h"
#import "SVWebViewController.h"

@interface ZZRSTableController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSMutableArray * _searchArray;//搜索结果的数组
    UICollectionView * _collectionView;//搜索结果的表格视图
    int page;
}

@end

@implementation ZZRSTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchArray = [[NSMutableArray alloc] init];
    page = 1;
    [self loadCollectionView];
}

- (void)loadCollectionView
{
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake((ScreenWidth-10)/2, 165);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 5;
        
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavBarHeight, ScreenWidth,ScreenHeight - NavBarHeight - 236) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.scrollsToTop = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[ZZSearchResultCell class] forCellWithReuseIdentifier:kZCCollectionViewCellID];
        
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    
    
}
-(void)loadResult:(NSString *)text{
    //调取接口
    //刷新数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertToString(text) forKey:@"title"];
    [dict setObject:@"24" forKey:@"pageSize"];
    [dict setObject:convertIntToString(page) forKey:@"pageNum"];
    [ZZRequsetInterface post:API_searchWikit param:dict timeOut:HttpGetTimeOut start:^{
        [SVProgressHUD show];
    } finish:^(id response, NSData *data) {
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        [SVProgressHUD dismiss];
        //            NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        //            NSArray *arr = [dict objectForKey:@"lemmaList"];
        //            [_listArray addObjectsFromArray:arr];
        //            [_collectionView reloadData];
    } complete:^(NSDictionary *dict) {
        NSArray *arr = dict[@"retData"];
        
        if(page == 1){
            [_searchArray removeAllObjects];
        }
        
        for (NSDictionary *item in arr) {
            [_searchArray addObject:[[LemmaModel alloc] initWithMyDict:item]];
        }
        [_collectionView reloadData];
        if(arr.count >= 24){
            page = page  + 1;
        }
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        
    } progress:^(CGFloat progress) {
        
    }];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _searchArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:kZCCollectionViewCellID forIndexPath:indexPath];
}

// 点击发送消息
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 发送点击消息
    LemmaModel * model = _searchArray[indexPath.row];
    if(_block){
        _block(model.lemmaUrl);
    }
//    SVWebViewController *web = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:urlEncodedString(model.lemmaUrl)]];
//    [self openNav:web sound:nil];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LemmaModel * model = _searchArray[indexPath.row];
    
    [(ZZSearchResultCell *)cell configureCellWithPostURL:model];
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
