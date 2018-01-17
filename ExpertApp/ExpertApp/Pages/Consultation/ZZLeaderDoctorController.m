//
//  ZZLeaderDoctorController.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZLeaderDoctorController.h"
#import "ZZPatientSymptomController.h"

#import "ZZWriteResultController.h"
#import "ZZAttentionController.h"
#import "ZZInviteDoctorController.h"
#import "ZZMyHZListController.h"
#import "ZZRemarkUserController.h"

@interface ZZLeaderDoctorController (){
    CGFloat btnY;
    
    NSString *docIds;
}

@end

@implementation ZZLeaderDoctorController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitleMenu];
    
    [self.menuTitleButton setTitle:@"会诊中" forState:UIControlStateNormal];
    
    
    UIView *tipView = [self createTips:@"您作为首诊医生，可以直接填写结果，也可以邀请其他大夫会诊。"];
    CGRect tipF = tipView.frame;
    tipF.origin.y = NavBarHeight;
    [tipView setFrame:tipF];
    [self.view addSubview:tipView];
    
    btnY = tipF.origin.y + tipF.size.height + 10;
    
    NSArray *titles = @[@"请点击阅读病情",@"以往咨询及会诊结果",@"用户资料",@"填写会诊结果",@"邀请医生会诊"];
    for(int i=0;i<titles.count;i++)
    {
        if(_model.caseDept==0 && i == 1){
            continue;
        }
        if(i==2){
            continue;
        }
        [self createItemButton:i+1 title:titles[i]];
        btnY = btnY + 40 + 10;
    }
}

-(void)itemOnClick:(UIButton *) btn{
    if(btn.tag == 1){
        // 病例
        ZZPatientSymptomController *detailVC = [[ZZPatientSymptomController alloc] init];
        detailVC.entity = _model;
        [self openNav:detailVC sound:nil];
    }
    if(btn.tag == 2){
        // 历史会诊记录
        ZZMyHZListController *reVC = [[ZZMyHZListController alloc] init];
        reVC.isFromDoc = YES;
        reVC.model = _model;
        [self openNav:reVC sound:nil];
    }
    if(btn.tag == 3){
        ZZRemarkUserController *vc = [[ZZRemarkUserController alloc] init];
        vc.type = 1;
        ZZUserInfo *info=[ZZUserInfo new];
        info.userId = _model.userId;
        vc.myFriend = info;
        [self openNav:vc sound:nil];
    }
    if(btn.tag == 4){
        // 结果
        ZZWriteResultController *hz = [[ZZWriteResultController alloc] init];
        hz.model = _model;
        [hz setResultBlock:^(ZZHZEngity *reModel){
            _model = reModel;
        }];
        [self openNav:hz sound:nil];
    }
    if(btn.tag == 5){
        // 邀请
        ZZInviteDoctorController *zzDoctor = [[ZZInviteDoctorController alloc] init];
        zzDoctor.isInvited = YES;
        zzDoctor.model = _model;
        [self openNav:zzDoctor sound:nil];
    }
}


-(void)createItemButton:(int) tag title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(15, btnY, ScreenWidth-30, 40)];
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    btn.tag = tag;
    if(tag>3){
        [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
        [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    }else{
        [btn setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
        btn.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
        btn.layer.borderWidth = 1.0f;
        [btn setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    }
    [btn.titleLabel setFont:ListTitleFont];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
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
