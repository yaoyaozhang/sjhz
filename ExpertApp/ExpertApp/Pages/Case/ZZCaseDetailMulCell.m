//
//  ZZCaseDetailMulCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZCaseDetailMulCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "XHImageViewer.h"

@implementation ZZCaseDetailMulCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_bgView setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
    // Initialization code
    [_labTag setFont:ListDetailFont];
    [_labTag setTextColor:UIColorFromRGB(TextDarkColor)];
    
    
    [_labDesc setFont:ListDetailFont];
    [_labDesc setTextColor:UIColorFromRGB(TextBlackColor)];
    _labDesc.numberOfLines = 0;
    
    
   
    [_imgsScroll setBackgroundColor:UIColor.clearColor];
    _imgsScroll.scrollEnabled = YES;
    _imgsScroll.showsVerticalScrollIndicator = NO;
    _imgsScroll.showsHorizontalScrollIndicator = YES;
}

-(void)createImageWith:(NSString *)imgurl tag:(int) tag{
    UIImageView *_imgLook = [[UIImageView alloc] initWithFrame:CGRectMake(120*tag + 10*tag, 0, 120, 80)];
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
}


-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    [_labTag setText:@""];
    _labDesc.hidden = YES;
    _imgsScroll.hidden = YES;
    CGFloat height = _labDesc.frame.origin.y;
    if(item){
        [_labTag setText:item[@"dictDesc"]];
        
        int type = [item[@"dictType"] intValue];
        NSString *value = convertToString(item[@"dictValue"]);
        
        if(type == ZZEditControlTypeButton){
            _labDesc.hidden = YES;
            _imgsScroll.hidden = NO;
            [self setFrame:CGRectMake(0, 0, ScreenWidth, 44+90)];
            NSString *imageString = item[@"dictValue"];
            NSArray *arr = [imageString componentsSeparatedByString:@","];
            [_imgsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int i=0;i<arr.count;i++) {
                [self createImageWith:arr[i] tag:i];
            }
            [_imgsScroll setContentSize:CGSizeMake(120*arr.count + 10*arr.count, 80)];
            height = height + 80 + 15;
        }else{
            _labDesc.hidden = NO;
            [_labDesc setText:value];
            CGSize size = [self autoHeightOfLabel:_labDesc with:_labDesc.frame.size.width];
            height = height + size.height + 15;
        }
    }
    [self setFrame:CGRectMake(0, 0, ScreenWidth, height)];
}


/**
 计算Label高度
 
 @param label 要计算的label，设置了值
 @param width label的最大宽度
 @param type 是否从新设置宽，1设置，0不设置
 */
- (CGSize )autoHeightOfLabel:(UILabel *)label with:(CGFloat )width{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(width, FLT_MAX);
    
    CGSize expectedLabelSize = [label sizeThatFits:maximumLabelSize];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
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
