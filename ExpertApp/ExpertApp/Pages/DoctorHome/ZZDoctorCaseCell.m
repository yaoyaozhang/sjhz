//
//  ZZDoctorCaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZDoctorCaseCell.h"

@implementation ZZDoctorCaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _btnStatus.layer.cornerRadius = 4.0f;
    _btnStatus.layer.masksToBounds = YES;
    [_btnStatus.titleLabel setFont:ListDetailFont];
    _btnStatus.layer.borderWidth = 1.0f;
    
    _btnDel.hidden = YES;
    [_btnDel addTarget:self action:@selector(delClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnStatus addTarget:self action:@selector(onOtherClick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnHZResult addTarget:self action:@selector(onOtherClick2:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCase addTarget:self action:@selector(onOtherClick1:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btnCase setFrame:CGRectMake(0, 0, ScreenWidth/4, 40)];
    [_btnCase.layer setBorderColor:UIColorFromRGB(BgTitleColor).CGColor];
    _btnCase.layer.borderWidth = 1.0f;
    [_btnCase setBackgroundColor:UIColorFromRGB(TextWhiteColor)];
    [_btnCase setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    [_btnCase setTitle:@"会诊病例" forState:UIControlStateNormal];
    [_btnCase.titleLabel setFont:ListDetailFont];
    
    [_btnHZResult setFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/4, 40)];
    [_btnHZResult setBackgroundColor:UIColorFromRGB(BgTitleColor)];
    [_btnHZResult setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [_btnHZResult setTitle:@"会诊结果" forState:UIControlStateNormal];
    [_btnHZResult.titleLabel setFont:ListDetailFont];
    _btnHZResult.hidden = YES;
    _btnCase.hidden = YES;
    
    
    [_labTime setFont:ListTitleFont];
    [_labTime setTextColor:UIColorFromRGB(TextBlackColor)];
    
    [_labCaseName setFont:ListTitleFont];
    [_labCaseName setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labDesc setFont:ListDetailFont];
    [_labDesc setTextColor:UIColorFromRGB(TextSizeSixColor)];
    _labDesc.numberOfLines = 0;
    
    _labStyle.hidden = YES;
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
}

-(void)setStatusStyle:(int) state{
    
    // 0 创建，1正在处理，2已完成，3已评价，-1已归档(删除)
    [_btnStatus setTitle:[self.tempModel getStateName] forState:UIControlStateNormal];
    if(state == 3 || state == -1){
        [_btnStatus setTitleColor:UIColorFromRGB(TextSizeSixColor) forState:UIControlStateNormal];
        _btnStatus.layer.borderColor = UIColorFromRGB(TextSizeSixColor).CGColor;
        [_btnStatus setTitleColor:UIColorFromRGB(TextSizeSixColor) forState:UIControlStateNormal];
    }else{
        [_btnStatus setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
        _btnStatus.layer.borderColor = UIColorFromRGB(BgTitleColor).CGColor;
        [_btnStatus setTitleColor:UIColorFromRGB(BgTitleColor) forState:UIControlStateNormal];
    }
}



-(void)dataToView:(ZZHZEngity *)model{
    CGFloat cellh = 0;
    
    if(model){
        self.tempModel = model;
        
        _btnHZResult.hidden = YES;
        _btnCase.hidden = YES;
        _btnDel.hidden = YES;
        _btnStatus.hidden = NO;
        _imgInto.hidden = NO;
        
        [_labTime setText:dateTransformDateString(@"yyyy年MM月dd日", model.createTime)];
        [_labCaseName setText:model.caseName];
        [_labDesc setText:model.caseQuestion];
        
        [self setStatusStyle:model.state];
        
        
        CGRect df = _labDesc.frame;
        [self autoWidthOfLabel:_labDesc with:df.size.width];
        df = _labDesc.frame;
        
        if(model.state == 4 && _cellType == ZZHZCellTypeUserHistory){
            self.btnDel.hidden = NO;
        }
        
        
        if(_cellType == ZZHZCellTypeHZHistory){
            self.btnCase.hidden = NO;
            self.btnHZResult.hidden = NO;
            _btnStatus.hidden = YES;
            _imgInto.hidden = YES;
            
            CGFloat iy = df.origin.y + df.size.height + 10.0f;
            [_btnCase setFrame:CGRectMake(0, iy, ScreenWidth/2, 40)];
            [_btnHZResult setFrame:CGRectMake(ScreenWidth/2, iy, ScreenWidth/2, 40)];
            
            
            cellh = iy + 40;
        }else{
            CGRect delf = _btnDel.frame;
            delf.origin.y = df.origin.y + df.size.height;
            _btnDel.frame = delf;
            CGRect sf = _labStyle.frame;
            sf.origin.y = delf.origin.y + 11;
            _labStyle.frame = sf;
            
            CGRect imgF = _imgInto.frame;
            imgF.origin.y = delf.origin.y + 14;
            _imgInto.frame = imgF;
            
            cellh = imgF.origin.y + imgF.size.height + 15;
        }
        
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, cellh)];
}


-(void)delClick:(UIButton *) sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDelegateDel:type:index:)]){
        [self.delegate onDelegateDel:self.tempModel type:0 index:_indexPath];
    }
}

-(void)onOtherClick:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDelegateDel:type:index:)]){
        [self.delegate onDelegateDel:self.tempModel type:1 index:_indexPath];
    }
}
-(void)onOtherClick1:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDelegateDel:type:index:)]){
        [self.delegate onDelegateDel:self.tempModel type:2 index:_indexPath];
    }
}
-(void)onOtherClick2:(UIButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onDelegateDel:type:index:)]){
        [self.delegate onDelegateDel:self.tempModel type:3 index:_indexPath];
    }
}

/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoWidthOfLabel:(UILabel *)label with:(CGFloat )width{
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
