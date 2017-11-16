//
//  ZZBasicCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZBasicCell.h"

@implementation ZZBasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labMsg setTextColor:UIColorFromRGB(TextPlaceHolderColor)];
    [_labMsg setFont:ListTitleFont];
    
    [_nameField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    int cid = [item[@"cid"] intValue];
    if(cid == 1){
        if(convertToString(self.user.userRemark).length>0){
            [_nameField setText:convertToString(self.user.userRemark)];
        }else{
            [_nameField setText:convertToString(self.user.name)];
        }
        [_nameField setPlaceholder:@"备注"];
        _nameField.hidden = NO;
        _labMsg.hidden = YES;
    }
    if(cid == 3){
        [_labMsg setText:convertToString(super.user.phone)];
        _nameField.hidden = YES;
        _labMsg.hidden = NO;
    }
}

-(void)onTextChanged:(UITextField *) f{
    if(self.delegate){
        [self.delegate onCellClick:convertToString(f.text) type:3];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
