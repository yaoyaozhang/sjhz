//
//  ZZAddPicCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/8.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZAddPicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XHImageViewer.h"
#import "MyButton.h"
#import "ZZSymptomExtModel.h"

@implementation ZZAddPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_labTagName setFont:ListDetailFont];
    [_labTagName setTextColor:UIColorFromRGB(TextBlackColor)];
    
    
    [_addScrollView setBackgroundColor:UIColor.clearColor];
    _addScrollView.scrollEnabled = YES;
    _addScrollView.showsVerticalScrollIndicator = NO;
    _addScrollView.showsHorizontalScrollIndicator = YES;
}



-(void)createImageWith:(NSString *)imgurl tag:(int) tag text:(NSString *)title isDel:(BOOL )isdel{
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(90*tag + 15*tag, 0, 90, 101)];
    
    UIImageView *imageViwe = [[UIImageView alloc] init];
    [imageViwe setFrame:CGRectMake(0,0, 80, 80)];
    [imageViwe setBackgroundColor:[UIColor clearColor]];
    if([imgurl hasPrefix:@"http"]){
        [imageViwe sd_setImageWithURL:[NSURL URLWithString:convertToString(imgurl)] placeholderImage:[UIImage imageNamed:@"Upload_photos"]];
    }else{
        [imageViwe setImage:[UIImage imageNamed:@"Upload_photos"]];
    }
    imageViwe.layer.cornerRadius = 5.0f;
    imageViwe.layer.masksToBounds = YES;
    imageViwe.layer.borderWidth = 1.0f;
    imageViwe.layer.borderColor = UIColorFromRGB(BgLineColor).CGColor;
    [imageViwe setContentMode:UIViewContentModeScaleAspectFit];
    [itemView addSubview:imageViwe];
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 90, 21)];
    [tLabel setFont:ListDetailFont];
    [tLabel setText:title];
    [tLabel setTextColor:UIColorFromRGB(TextDarkColor)];
    [tLabel setTextAlignment:NSTextAlignmentCenter];
    [tLabel setBackgroundColor:UIColor.clearColor];
    [itemView addSubview:tLabel];
    
    if(_isDetail){
        //设置点击事件
        UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchUpInside:)];
        imageViwe.userInteractionEnabled=YES;
        [imageViwe addGestureRecognizer:tapGesturer];
    }else{
        //设置点击事件
        UITapGestureRecognizer *tapGesturer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonClick:)];
        itemView.userInteractionEnabled=YES;
        [itemView addGestureRecognizer:tapGesturer];
    }
    if(isdel){
        MyButton *delBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
        [delBtn setFrame:CGRectMake(90-10, 0, 20, 20)];
        delBtn.objTag = title;
        delBtn.tag = tag;
        delBtn.userInteractionEnabled = YES;
        [delBtn addTarget:self action:@selector(delButton:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:delBtn];
    }
    
    [_addScrollView addSubview:itemView];
}


-(void)dataToView:(NSDictionary *)item{
    [super dataToView:item];
    
    if(self.isDetail){
        [_imgRequired setBackgroundColor:UIColorFromRGB(BgListSectionColor)];
        [_imgRequired setFrame:CGRectMake(0, 0,ScreenWidth, 40)];
        [_imgRequired setImage:nil];
        [_labTagName setFrame:CGRectMake(10, 0, ScreenWidth - 20, 40)];
    }
    
    [_labTagName setText:@""];
    [_addScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(item){
        [_labTagName setText:item[@"dictDesc"]];
        
        
        
        if([@"0" isEqual:item[@"isOption"]]){
            _imgRequired.hidden = YES;
        }else{
            _imgRequired.hidden = NO;
        }
        int type = [item[@"dictType"] intValue];
        
        if(type == ZZEditControlTypeAddPic){
            int count = 0;
            if(!is_null(item[@"dictValue"])){
                NSMutableArray *arr = item[@"dictValue"];
                
                for (int i=0;i<arr.count;i++) {
                    ZZSymptomExtPicModel *picModel = arr[i];
                    [self createImageWith:picModel.url tag:i text:picModel.type isDel:!_isDetail];
                }
                count = (int)arr.count;
                
            }
            
            if(!_isDetail){
                [self createImageWith:@"Upload_photos" tag:count text:@"添加图像" isDel:NO];
            }
            
            [_addScrollView setContentSize:CGSizeMake(90*count + 15*count + 90, 101)];
        }
    }
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

-(void)delButton:(MyButton *) btn{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]){
        [self.delegate onCaseValueChanged:self.tempModel type:ZZEditControlTypeDelImag dict:self.tempDict obj:btn];
    }
}

/**
 *  点击图片
 */
-(void) buttonClick:(UITapGestureRecognizer *)tap{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onCaseValueChanged:type:dict:obj:)]){
        [self.delegate onCaseValueChanged:self.tempModel type:[self.tempDict[@"dictType"] intValue] dict:self.tempDict obj:tap.view];
    }
}



/**
 *  点击查看大图
 *
 *  @param recognizer
 */
-(void) imgTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
//    int type = [self.tempDict[@"dictType"] intValue];
//    NSString *value = convertToString(self.tempDict[@"dictValue"]);
//    
//    BOOL isImage = NO;
//    if([[value lowercaseString] hasSuffix:@".png"]
//       || [[value lowercaseString] hasSuffix:@".pneg"]
//       || [[value lowercaseString] hasSuffix:@".jpg"]
//       || [[value lowercaseString] hasSuffix:@".jpeg"]
//       || [[value lowercaseString] hasSuffix:@".bmp"]
//       || [[value lowercaseString] hasSuffix:@".gif"]){
//        isImage = YES;
//    }
//    
//    if(type != ZZEditControlTypeButton || !isImage){
//        return;
//    }
    
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
