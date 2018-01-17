//
//  ZZUserHomeCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/1.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZUserHomeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZZUserHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _viewBordor.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    _viewBordor.layer.borderWidth = 1.0f;
    _viewBordor.layer.cornerRadius = 5.0f;
    [_viewBordor setBackgroundColor:[UIColor clearColor]];
    _viewBordor.layer.masksToBounds  = YES;
    
    [_labelNameZhiWei setTextColor:UIColorFromRGB(TextLightDarkColor)];
    [_labelHosptial setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    [_viewLabels setBackgroundColor:[UIColor clearColor]];
    _imgAvatar.layer.borderWidth = 1.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
}


-(void)dataToView:(ZZUserInfo *)model{
    if(model){
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
        [_labelNameZhiWei setText:[NSString stringWithFormat:@"%@ %@",model.docName,model.departmentName]];
        [_labelHosptial setText:model.hospital];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
