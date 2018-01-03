//
//  ZZCreateCaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/29.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCreateCaseCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "XHImageViewer.h"
#import "MyButton.h"

@interface ZZCreateCaseCell()<UITextFieldDelegate>{
    
}


@end

@implementation ZZCreateCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_labTagName setFont:ListDetailFont];
    [_labTagName setTextColor:UIColorFromRGB(TextBlackColor)];
    
    
    [_labMan setFont:ListDetailFont];
    [_labWoman setTextColor:UIColorFromRGB(TextBlackColor)];
    
    
    [_labUnit setFont:ListDetailFont];
    [_labUnit setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_field1 setPlaceholder:@"请输入"];
    [_field1 setFont:ListDetailFont];
    [_field2 setPlaceholder:@"请输入"];
    [_field2 setFont:ListDetailFont];
    
    [_field1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_field1 addTarget:self action:@selector(textFieldDidChangeBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_field2 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_field2 addTarget:self action:@selector(textFieldDidChangeBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    [_btnMan setBackgroundColor:[UIColor clearColor]];
    [_btnWoman setBackgroundColor:[UIColor clearColor]];
    [_btnMan addTarget:self action:@selector(buttonSex:) forControlEvents:UIControlEventTouchUpInside];
    [_btnWoman addTarget:self action:@selector(buttonSex:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnMan setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [_btnMan setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    
    [_btnWoman setImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
    [_btnWoman setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateSelected];
    
    
    
    [_btnControl.titleLabel setFont:ListDetailFont];
    [_btnControl setBackgroundColor:UIColorFromRGB(BgSystemColor)];
    _btnControl.layer.masksToBounds = YES;
    _btnControl.layer.cornerRadius  = 4.0f;
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_btnControl addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_imgsScroll setBackgroundColor:UIColor.clearColor];
    _imgsScroll.scrollEnabled = YES;
    _imgsScroll.showsVerticalScrollIndicator = NO;
    _imgsScroll.showsHorizontalScrollIndicator = YES;
}

-(void)createImageWith:(NSString *)imgurl tag:(int) tag{
    CGRect f = CGRectMake(150*tag + 10*tag, 0, 150, 80);
    UIImageView *_imgLook = [[UIImageView alloc] initWithFrame:f];
    [_imgLook setBackgroundColor:[UIColor clearColor]];
    _imgLook.layer.borderWidth = 1.0f;
    _imgLook.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    [_imgLook sd_setImageWithURL:[NSURL URLWithString:convertToString(imgurl)]];
    [_imgLook setContentMode:UIViewContentModeScaleAspectFit];
    [_imgsScroll addSubview:_imgLook];
    
    //设置点击事件
    UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchUpInside:)];
    _imgLook.userInteractionEnabled=YES;
    [_imgLook addGestureRecognizer:tapGesturer];
    
    
    MyButton *btnDel = [MyButton buttonWithType:UIButtonTypeCustom];
    [btnDel setFrame:CGRectMake(f.origin.x + f.size.width - 10,f.origin.y,15,15)];
    [btnDel setBackgroundColor:UIColorFromRGB(BgRedColor)];
    [btnDel setTitle:@"X" forState:UIControlStateNormal];
    [btnDel setContentEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [btnDel.titleLabel setFont:ListTimeFont];
    btnDel.layer.cornerRadius = 7.5f;
    btnDel.objTag = imgurl;
    btnDel.layer.masksToBounds = YES;
    [btnDel addTarget:self action:@selector(btnDelClick:) forControlEvents:UIControlEventTouchUpInside];
    [_imgsScroll addSubview:btnDel];
}

-(void)btnDelClick:(MyButton *) btn{
    NSString *url = btn.objTag;
    NSString *vavlue = convertToString(self.tempDict[@"dictValue"]);
    vavlue = [vavlue stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",url] withString:@""];
    vavlue = [vavlue stringByReplacingOccurrencesOfString:url withString:@""];
    [self.tempModel setValue:vavlue forKey:self.tempDict[@"dictName"]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]) {
        [self.delegate onCaseValueChanged:self.tempModel type:ZZEditControlTypeDelImag dict:self.tempDict obj:nil];
    }
}

-(void)dataToView:(NSDictionary *) item{
    [super dataToView:item];
    
    _imgDrop.hidden = YES;
    _imgLine.hidden = YES;
    
    _btnWoman.hidden = YES;
    _btnMan.hidden = YES;
    _labWoman.hidden = YES;
    _labMan.hidden   = YES;
    
    _labUnit.hidden = YES;
    _btnControl.hidden = YES;
    
    _field1.hidden = YES;
    _field2.hidden = YES;
    
    
    _field1.delegate = self;
    _field2.delegate = self;
    
    [_labTagName setText:item[@"dictDesc"]];
    
    int valueType = [item[@"valueType"] intValue];
    if(valueType == 2){
        _field1.keyboardType = UIKeyboardTypeNumberPad;
        _field2.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _field1.keyboardType = UIKeyboardTypeDefault;
        _field2.keyboardType = UIKeyboardTypeDefault;
    }
    
    int type = [item[@"dictType"] intValue];
    if(type == ZZEditControlTypeTextField){
        _field1.hidden = NO;
        
        [_field1 setFrame:CGRectMake(104, 8, ScreenWidth-104-20, 30)];
        
        [_field1 setText:item[@"dictValue"]];
        [_field1 setPlaceholder:item[@"placeholder"]];
    }
    
    if(type == ZZEditControlTypeSex){
        _labMan.hidden = NO;
        _labWoman.hidden = NO;
        _btnMan.hidden = NO;
        _btnWoman.hidden = NO;
        
        
        if([item[@"dictValue"] intValue]== 1){
            _btnMan.selected = YES;
            _btnWoman.selected = NO;
        }else if([item[@"dictValue"] intValue]== 2){
            _btnMan.selected = NO;
            _btnWoman.selected = YES;
        }else{
            _btnMan.selected = NO;
            _btnWoman.selected = NO;
        }
    }
    
    if(type == ZZEditControlTypeDoubleTextField){
        _field1.hidden = NO;
        _field2.hidden = NO;
        _imgLine.hidden = NO;
        [_field1 setFrame:CGRectMake(104, 8, 60, 30)];
        [_field2 setFrame:CGRectMake(224, 8, 60, 30)];
        
        [_field1 setText:@""];
        [_field2 setText:@""];
        
        NSArray *values = [convertToString(item[@"dictValue"]) componentsSeparatedByString:@","];
        if(values.count > 1){
            [_field1 setText:values[0]];
            [_field2 setText:values[1]];
        }
    }
    if(type == ZZEditControlTypeChoose){
        _imgDrop.hidden = NO;
        _btnControl.hidden = NO;
        if([@"" isEqual:convertToString(item[@"dictValue"])]){
            [_btnControl setTitle:item[@"placeholder"] forState:UIControlStateNormal];
        }else{
            [_btnControl setTitle:item[@"dictValue"] forState:UIControlStateNormal];
        }
    }
    
    if(type == ZZEditControlTypeButton){
        _btnControl.hidden = NO;
        [_btnControl setTitle:item[@"placeholder"] forState:UIControlStateNormal];
    }
    
    
    if([item[@"valueType"] intValue] == 2 || [@"lungTime" isEqual:item[@"dictName"]]){
        _labUnit.hidden = NO;
        [_labUnit setText:item[@"placeholder"]];
    }
    
    [self autoWidthOfLabel:_labTagName with:21];
    CGRect of = _labTagName.frame;
    if(type == ZZEditControlTypeTextField){
        CGRect f1 = _field1.frame;
        f1.origin.x = of.origin.x + of.size.width + 10;
        f1.size.width = ScreenWidth - f1.origin.x - 60;
        _field1.frame = f1;
    }
    if(type == ZZEditControlTypeButton || type == ZZEditControlTypeChoose){
        CGRect cf = _btnControl.frame;
        cf.origin.x = of.origin.x + of.size.width + 10;
        cf.size.width = ScreenWidth - cf.origin.x - 10;
        _btnControl.frame = cf;
        
        
        if(type == ZZEditControlTypeChoose){
            CGFloat bw = [ZZCoreTools getWidthContain:_btnControl.titleLabel.text font:_btnControl.titleLabel.font Height:24];
            
            CGRect f = _imgDrop.frame;
            f.origin.x = _btnControl.center.x + bw/2 + 20;
            f.origin.y = _btnControl.center.y - 4;
            [_imgDrop setFrame:f];
        }
    }
    
    if(type == ZZEditControlTypeButton && !is_null(item[@"dictValue"])){
        _imgsScroll.hidden = NO;
        [self setFrame:CGRectMake(0, 0, ScreenWidth, 44+90)];
        NSString *imageString = item[@"dictValue"];
        NSArray *arr = [imageString componentsSeparatedByString:@","];
        [_imgsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i=0;i<arr.count;i++) {
            [self createImageWith:arr[i] tag:i];
        }
        [_imgsScroll setContentSize:CGSizeMake(150*arr.count + 10*arr.count, 80)];
    }else{
        _imgsScroll.hidden = YES;
        [self setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    }
}

-(void)buttonSex:(UIButton *) sender{
    if([_btnWoman isEqual:sender]){
        _btnWoman.selected = YES;
        _btnMan.selected = NO;
        [self.tempModel setValue:@"2" forKey:@"sex"];
        [self.tempModel setValue:@"女" forKey:@"sexName"];
    }else{
        _btnWoman.selected = NO;
        _btnMan.selected = YES;
        [self.tempModel setValue:@"1" forKey:@"sex"];
        [self.tempModel setValue:@"男" forKey:@"sexName"];
        
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]) {
        int type = [self.tempDict[@"dictType"] intValue];
        [self.delegate onCaseValueChanged:self.tempModel type:type dict:self.tempDict obj:nil];
    }
}

-(void)buttonClick:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]){
        [self.delegate onCaseValueChanged:self.tempModel type:[self.tempDict[@"dictType"] intValue] dict:self.tempDict obj:btn];
    }
}



-(void)textFieldDidChangeBegin:(UITextField *) textField{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didKeyboardWillShow:view1:view2:view3:)]){
        if([_field1 isEqual:textField]){
            
            [self.delegate didKeyboardWillShow:self.indexPath view1:nil view2:_field1 view3:nil];
        }else{
            [self.delegate didKeyboardWillShow:self.indexPath view1:nil view2:nil view3:_field2];
        }
    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    int type = [self.tempDict[@"dictType"] intValue];
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]) {
        NSString *dictName = convertToString(self.tempDict[@"dictName"]);
        
        if(type == ZZEditControlTypeDoubleTextField){
            [self.tempModel setValue:convertToString(_field1.text) forKey:@"sbp"];
            [self.tempModel setValue:convertToString(_field2.text) forKey:@"dbp"];
        }else{
            [self.tempModel setValue:convertToString(_field1.text) forKey:dictName];
        }
        [self.delegate onCaseValueChanged:self.tempModel type:type dict:self.tempDict obj:nil];
    }
}




/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )hegiht{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(FLT_MAX, hegiht);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    if(expectedLabelSize.width<70){
        expectedLabelSize.width = 70;
    }
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    [label updateConstraintsIfNeeded];
    
    return expectedLabelSize;
}




/**
 *  点击查看大图
 *
 *  @param recognizer
 */
-(void) imgTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    int type = [self.tempDict[@"dictType"] intValue];
    NSString *value = convertToString(self.tempDict[@"dictValue"]);
    
    BOOL isImage = NO;
    if([[value lowercaseString] hasSuffix:@".png"]
       || [[value lowercaseString] hasSuffix:@".pneg"]
       || [[value lowercaseString] hasSuffix:@".jpg"]
       || [[value lowercaseString] hasSuffix:@".jpeg"]
       || [[value lowercaseString] hasSuffix:@".bmp"]
       || [[value lowercaseString] hasSuffix:@".gif"]){
        isImage = YES;
    }
    
    if(type != ZZEditControlTypeButton || !isImage){
        return;
    }
    
    NSLog(@"我怎么不处罚呢：");
    UIImageView *_picView = (UIImageView*)recognizer.view;
    
    CALayer *calayer = _picView.layer.mask;
    [_picView.layer.mask removeFromSuperlayer];
    
    
    
    XHImageViewer *xh = [[XHImageViewer alloc] initWithImageViewerWillDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView) {
        
    } didDismissWithSelectedViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView) {
        
        selectedView.layer.mask = calayer;
        [selectedView setNeedsDisplay];
        
    } didChangeToImageViewBlock:^(XHImageViewer *imageViewer, UIImageView *selectedView) {
    }];
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    [photos addObject:_picView];
    
    //    xh.delegate = self;
    xh.disableTouchDismiss = NO;
    [xh showWithImageViews:photos selectedView:_picView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
