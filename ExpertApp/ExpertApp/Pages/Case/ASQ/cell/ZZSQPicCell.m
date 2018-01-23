//
//  ZZSQPicCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/22.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZSQPicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyButton.h"
#import "XHImageViewer.h"

@implementation ZZSQPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [_imgsScroll setBackgroundColor:UIColor.clearColor];
    _imgsScroll.scrollEnabled = YES;
    _imgsScroll.showsVerticalScrollIndicator = NO;
    _imgsScroll.showsHorizontalScrollIndicator = YES;
}


-(void)dataToView:(ZZQSModel *)model{
    [super dataToView:model];
    
    [_imgsScroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if(model.quesType == 4){
       
        int count = 0;
        
        NSMutableArray *arr = model.quesAnswer;
                
        for (int i=0;i<arr.count;i++) {
            ZZQSAnswerModel *picModel = arr[i];
            if(picModel.wentiId >= 0){
                [self createImageWith:picModel.context tag:i text:picModel.tag isDel:!_isDetail model:picModel];
            }
        }
        count = (int)arr.count;
        if(!_isDetail){
            [self createImageWith:@"Upload_photos" tag:count text:@"添加图像" isDel:NO model:nil];
        }
        [_imgsScroll setContentSize:CGSizeMake(80*count + 10*count + 80, 101)];
    }
}

-(void)createImageWith:(NSString *)imgurl tag:(int) tag text:(NSString *)title isDel:(BOOL )isdel model:(ZZQSAnswerModel *)itemM{
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(80*tag + 10*tag, 0, 80, 101)];
    
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
    
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 21)];
    [tLabel setFont:ListDetailFont];
    [tLabel setText:title];
    [tLabel setTextColor:UIColorFromRGB(TextDarkColor)];
    [tLabel setTextAlignment:NSTextAlignmentCenter];
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
        itemView.tag = tag;
        [itemView addGestureRecognizer:tapGesturer];
    }
    if(isdel){
        MyButton *delBtn = [MyButton buttonWithType:UIButtonTypeCustom];
        [delBtn setImage:[UIImage imageNamed:@"close"] forState:0];
        [delBtn setFrame:CGRectMake(80-10, 0, 20, 20)];
        delBtn.objTag = itemM;
        delBtn.tag = tag;
        delBtn.userInteractionEnabled = YES;
        [delBtn addTarget:self action:@selector(delButton:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:delBtn];
    }
    
    [_imgsScroll addSubview:itemView];
}


-(void)delButton:(MyButton *) btn{
    if(self.delegate){
        [self.delegate onCellClick:btn.objTag type:5 with:self.tempModel];
    }
}

/**
 *  点击图片
 */
-(void) buttonClick:(UITapGestureRecognizer *)tap{
    if(self.delegate){
        [self.delegate onCellClick:tap.view type:4 with:self.tempModel];
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
