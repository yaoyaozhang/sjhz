//
//  ZZSQTextCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/8.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZSQTextCell.h"

@implementation ZZSQTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_textField setTextColor:UIColorFromRGB(TextBlackColor)];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self action:@selector(textFieldDidChangeBegin:) forControlEvents:UIControlEventEditingDidBegin];
}
-(void)dataToView:(ZZQSModel *)model{
    [super dataToView:model];
    CGRect topF = self.labTitle.frame;
    CGFloat y =  topF.origin.y + topF.size.height + 10;
    
    [_textField setFrame:CGRectMake(15, y,ScreenWidth-30, 28)];
    if(!is_null(model.values) && [model.values isKindOfClass:[NSDictionary class]]){
        [_textField setText:model.values[@"value"]];
    }
    
    if(self.showType == 1){
        [_textField setEnabled:NO];
        [_textField setUserInteractionEnabled:NO];
    }
//    int type = [item[@"cid"] intValue];
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + 28 +15)];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.showType == 1) {
        return YES;
    }
    return NO;
}

-(void)textFieldDidChangeBegin:(UITextField *) textField{
    [self.delegate didKeyboardWillShow:self.indexPath view:_textField];
}

-(void)textFieldDidChange:(UITextField *)textField{
    [self.delegate onCellClick:textField.text type:3 with:self.tempModel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
