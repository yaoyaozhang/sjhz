//
//  ZZCreateCaseMulCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCreateCaseMulCell.h"

@interface ZZCreateCaseMulCell()<UITextViewDelegate>{
    
}
@end

@implementation ZZCreateCaseMulCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_labTagName setFont:ListDetailFont];
    [_labTagName setTextColor:UIColorFromRGB(TextBlackColor)];
    
}


-(void)dataToView:(NSDictionary *) item{
    
    [super dataToView:item];
    
    _textViewCase.delegate = self;
    
    [_labTagName setText:item[@"dictDesc"]];
    [_textViewCase setText:item[@"dictValue"]];
    [_textViewCase setPlaceholder:item[@"placeholder"]];
    
    
    if([@"0" isEqual:item[@"isOption"]]){
        _imgRequired.hidden = YES;
    }else{
        _imgRequired.hidden = NO;
    }
}


-(void)textViewDidChange:(ZCTextPlaceholderView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]) {
        NSString *dictName = convertToString(self.tempDict[@"dictName"]);
        [self.tempModel setValue:convertToString(textView.text) forKey:dictName];
        [self.delegate onCaseValueChanged:self.tempModel type:[self.tempDict[@"dictType"] intValue] dict:self.tempDict obj:nil];
    }
}

-(void)textViewDidBeginEditing:(ZCTextPlaceholderView *)textView{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didKeyboardWillShow:view1:view2:view3:)]){
        [self.delegate didKeyboardWillShow:self.indexPath view1:textView view2:nil view3:nil];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
