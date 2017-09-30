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
}


-(void)dataToView:(NSDictionary *)dict{
//    [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
//    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]]];
    [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"%@",error);
    }];
    [_labelUname setText:dict[@"uname"]];
    [_labelQuestionNum setText:[NSString stringWithFormat:@"可免费提问次数:%@次",dict[@"num"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
