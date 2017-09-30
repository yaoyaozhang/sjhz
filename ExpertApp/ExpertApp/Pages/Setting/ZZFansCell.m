//
//  ZZFansCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/28.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZFansCell.h"

@implementation ZZFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //mydoctor_mutualfollow
    [_btnAction setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnAction addTarget:self action:@selector(onClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void ) dataToView:(NSDictionary *) item{
    if(item){
        if(item!=nil){
            [_btnAction.layer removeFromSuperlayer];
            [_btnAction setBackgroundColor:[UIColor clearColor]];
            [_btnAction setImage:[UIImage imageNamed:@"mydoctor_mutualfollow"] forState:UIControlStateNormal];
            [_btnAction setTitle:@"互相关注" forState:UIControlStateNormal];
        }else{
            [_btnAction setTitle:@"接受" forState:UIControlStateNormal];
            _btnAction.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
            _btnAction.layer.borderWidth = 1.0f;
            _btnAction.layer.cornerRadius = 4.0f;
            _btnAction.layer.masksToBounds = YES;
        }
    }
}


-(void)onClickAction:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onFansCellClick:)]){
        [self.delegate onFansCellClick:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
