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
-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    CGRect topF = self.labTitle.frame;
    CGFloat y =  topF.origin.y + topF.size.height + 10;
    [_textField setFrame:CGRectMake(15, y,ScreenWidth, 28)];
//    int type = [item[@"cid"] intValue];
    
    [self setFrame:CGRectMake(0, 0, ScreenWidth, y + 28 +15)];
}

-(void)textFieldDidChangeBegin:(UITextField *) textField{
    [self.delegate didKeyboardWillShow:self.indexPath view:_textField];
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
