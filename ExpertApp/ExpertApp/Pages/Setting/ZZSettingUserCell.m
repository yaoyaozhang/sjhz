//
//  ZZSettingUserCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSettingUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZSettingUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = _imgAvatar.frame.size.height/2;
    [_imgAvatar setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    
    [_labelUname setFont:TitleFont];
    [_labelUname setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_labelQuestionNum setFont:ListDetailFont];
    [_labelQuestionNum setTextColor:UIColorFromRGB(TextLightDarkColor)];
    
    [_btnJifen.titleLabel setFont:ListTitleFont];
    [_btnJifen setTitleColor:UIColorFromRGB(BgTitleColor) forState:0];
    [_btnJifen addTarget:self action:@selector(didOpenJifen:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)dataToView:(NSDictionary *)dict{
    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(dict[@"avatar"])] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        NSLog(@"%@",error);
    }];
    
    ZZUserInfo *loginUser = [[ZZDataCache getInstance] getLoginUser];
    
//    [_btnJifen setTitle:[NSString stringWithFormat:@"%d积分",loginUser.score] forState:0];
    [_btnJifen setTitle:[NSString stringWithFormat:@"%@",loginUser.userName] forState:0];
    
    [_labelUname setText:convertToString(loginUser.userName)];
    if(loginUser.isDoctor){
        [_labelQuestionNum setText:[NSString stringWithFormat:@"会诊%d个  文章%d个",loginUser.orderNumber,loginUser.articleNum]];
    }else{
        _labelQuestionNum.hidden = YES;
        CGRect f = _labelUname.frame;
        CGRect f2 = _btnJifen.frame;
        f.origin.y = (self.frame.size.height - f.size.height - f2.size.height) / 2;
        _labelUname.frame = f;
        
        f2.origin.y = CGRectGetMaxY(f)+2;
        _btnJifen.frame = f2;
        
    }
}

-(void)didOpenJifen:(UIButton * )btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCellClick:)]){
        [self.delegate onCellClick:@"1"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
