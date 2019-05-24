//
//  ZZFriendUserCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/10/25.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZFriendUserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation ZZFriendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labelName setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labelHosptial setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    
    [_labelName setTextAlignment:NSTextAlignmentLeft];
    [_labelHosptial setTextAlignment:NSTextAlignmentLeft];
    
    [_labelName setFont:ListTitleFont];
    [_labelHosptial setFont:ListDetailFont];
    
    
    _imgAvatar.layer.masksToBounds = YES;
    _imgAvatar.layer.cornerRadius = 30.0f;
    _imgAvatar.layer.borderWidth = 1.0f;
    _imgAvatar.layer.borderColor = UIColorFromRGB(BgSystemColor).CGColor;
    [_imgAvatar setContentMode:UIViewContentModeScaleAspectFill];
    
    [_btnControl.titleLabel setFont:ListDetailFont];
    [_btnControl setBackgroundColor:[UIColor clearColor]];
    [_btnControl setTitleColor:UIColorFromRGB(BgTitleColor) forState:0];
    [_btnControl addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_btnAccept.titleLabel setFont:ListDetailFont];
    [_btnAccept setTitle:@"接受" forState:UIControlStateNormal];
    [_btnAccept setBackgroundColor:[UIColor whiteColor]];
    [_btnAccept setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    _btnAccept.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
    _btnAccept.layer.borderWidth = 1.0f;
    _btnAccept.layer.cornerRadius = 4.0f;
    _btnAccept.layer.masksToBounds = YES;
    [_btnAccept setTitleColor:UIColorFromRGB(BgTitleColor) forState:0];
    [_btnAccept.titleLabel setFrame:_btnControl.bounds];
    [_btnAccept addTarget:self action:@selector(itemOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)itemOnClick:(UIButton *) sender{
    if(_tempModel){
        if(self.delegate && [self.delegate respondsToSelector:@selector(onDoctorCellClick:model:)]){
            [self.delegate onDoctorCellClick:_cellType model:_tempModel];
        }
    }
}

-(void)btnLeave:(UIButton *) btn{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"给他留言" preferredStyle:UIAlertControllerStyleAlert];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        }]];
        //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //do something
        UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
        if(convertToString(envirnmentNameTextField.text).length == 0){
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
        
        [dict setObject:convertIntToString([ZZDataCache getInstance].getLoginUser.userId) forKey:@"forUserId"];
        if(_tempModel.userId != [ZZDataCache getInstance].getLoginUser.userId){
            [dict setObject:convertIntToString(_tempModel.userId) forKey:@"toUserId"];
        }else{
            if(_tempModel.fromUserid > 0 && _tempModel.fromUserid != [ZZDataCache getInstance].getLoginUser.userId ){
                [dict setObject:convertIntToString(_tempModel.fromUserid) forKey:@"toUserId"];
            }else if(_tempModel.toUserId > 0 && _tempModel.toUserId != [ZZDataCache getInstance].getLoginUser.userId){
                [dict setObject:convertIntToString(_tempModel.toUserId) forKey:@"toUserId"];
            }else{
                [dict setObject:convertIntToString(_tempModel.userId) forKey:@"toUserId"];
            }
        }
        [dict setObject:envirnmentNameTextField.text forKey:@"context"];
        [ZZRequsetInterface post:API_sendFollowMsg param:dict timeOut:HttpGetTimeOut start:^{
            
        } finish:^(id response, NSData *data) {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } complete:^(NSDictionary *dict) {
            ZZFollowMessageModel *mm = [ZZFollowMessageModel new];
            mm.frUserId = convertIntToString(_tempModel.fromUserid);
            mm.toUserId = convertIntToString(_tempModel.toUserId);
            mm.context = envirnmentNameTextField.text;
            mm.userName = [ZZDataCache getInstance].getLoginUser.name;
            [_tempModel.tempLeaves addObject:mm];
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(onDoctorCellClick:model:)]){
                [self.delegate onChangedMessage:ZZUserFriendCellTypeChanged model:_tempModel];
            }
        } fail:^(id response, NSString *errorMsg, NSError *connectError) {
            
        } progress:^(CGFloat progress) {
            
        }];
        
    }]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"对方还不认识你，介绍一下吧";
//        textField.delegate = self;
    }];
    
    [(UIViewController *)self.delegate presentViewController:alertController animated:true completion:nil];
}

-(void)dataToView:(ZZUserInfo *)model{
   
    _btnAccept.hidden = YES;
    _btnControl.hidden = YES;
    
    if(model){
        _tempModel = model;
        ZZUserInfo *userInfo = [ZZDataCache getInstance].getLoginUser;
        
        int status = model.state;
        CGRect bf = _btnControl.frame;
        if(status == 1){
            if(model.fromUserid == userInfo.userId){
                _btnControl.layer.borderColor = [UIColor clearColor].CGColor;
                [_btnControl setTitle:@"已关注" forState:UIControlStateNormal];
                [_btnControl setImage:[UIImage imageNamed:@"mydoctor_havefollow"] forState:UIControlStateNormal];
                [_btnControl setImage:[UIImage imageNamed:@"mydoctor_havefollow"] forState:UIControlStateSelected];
                bf.size.height = 50.0f;
                bf.origin.y = (90-50)/2;
                [_btnControl setFrame:bf];
                _btnControl.hidden = NO;
            }else{
                _btnAccept.hidden = NO;
            }
        }
        if(status == 2){
            _btnControl.layer.borderColor = [UIColor clearColor].CGColor;
            [_btnControl setTitle:@"互相关注" forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_mutualfollow"] forState:UIControlStateNormal];
            [_btnControl setImage:[UIImage imageNamed:@"mydoctor_mutualfollow"] forState:UIControlStateSelected];
            bf.size.height = 50.0f;
            bf.origin.y = (90-50)/2;
            [_btnControl setFrame:bf];
            _btnControl.hidden = NO;
            
            _viewChat.hidden = YES;
        }else{
            _viewChat.hidden = NO;
            
            [self createChatViews];
        }
        
        
        
        _tempModel = model;
        
        if(convertToString(model.userRemark).length>0){
            [_labelName setText:model.userRemark];
        }else if(convertToString(model.name).length){
            [_labelName setText:model.name];
        }else{
            [_labelName setText:model.userName];
        }
        if([[ZZDataCache getInstance] getLoginUser].isDoctor){
            [_labelHosptial setText:model.context];
        }else{
            [_labelHosptial setText:convertToString(model.hospital)];
        }
        
        
        [_imgAvatar sd_setImageWithURL:[NSURL URLWithString:convertToString(model.imageUrl)]];
        
        if(_viewChat.hidden){
            self.frame = CGRectMake(0, 0, ScreenHeight, CGRectGetMaxY(_imgAvatar.frame) + 10);
        }else{
            self.frame = CGRectMake(0, 0, ScreenHeight, CGRectGetMaxY(_viewChat.frame) + 10);
        }
        
    }
}


-(void)createChatViews{
    [_viewChat.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _viewChat.layer.cornerRadius = 5.0;
    _viewChat.layer.masksToBounds = YES;
    [_viewChat setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    _viewChat.userInteractionEnabled = true;
    CGFloat y = 10.0;
    for (int i= 0; i<_tempModel.tempLeaves.count; i++) {
        ZZFollowMessageModel *mm = _tempModel.tempLeaves[i];
        NSString *text = [NSString stringWithFormat:@"%@:%@",mm.userName,mm.context];
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, y, ScreenWidth - 50, 0)];
        lab.numberOfLines = 0;
        [lab setFont:ListDetailFont];
        [lab setTextColor:UIColorFromRGB(TextLightDarkColor)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,_tempModel.userName.length + 1)];
        lab.attributedText = str;
        [self autoHeightWidthOfLabel:lab with:ScreenWidth - 50];
        
        y = CGRectGetMaxY(lab.frame) + 5;
        [_viewChat addSubview:lab];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(ScreenWidth - 40 - 55, y, 50, 24)];
    [btn setTitle:@"回复" forState:0];
    [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:0];
    [btn setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    btn.layer.cornerRadius = 4.0;
    btn.titleLabel.font = ListDetailFont;
    btn.layer.masksToBounds = true;
    [btn addTarget:self action:@selector(btnLeave:) forControlEvents:UIControlEventTouchUpInside];
    [_viewChat addSubview:btn];
    
    [_viewChat setFrame:CGRectMake(15, CGRectGetMaxY(_imgAvatar.frame)+10, ScreenWidth - 30, y + 35)];
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )height{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX,height);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}

- (CGSize )autoHeightWidthOfLabel:(UILabel *)label with:(CGFloat )width{
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
