//
//  ZZTipsAlertView.m
//  ExpertApp
//
//  Created by zhangxy on 2018/1/16.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZTipsAlertView.h"


@implementation ZZTipsAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel comfirm:(NSString *)text{
    self = [super initWithTitle:title message:message cancel:cancel comfirm:text];
    if(self){
        
        CGFloat w = super.subContentView.frame.size.width;
        
        _label = [[CoreTextLabel alloc] initWithFrame:CGRectMake(15, 15, w - 30, 30)];
        [_label setFont:ListDetailFont];
        [_label setTextColor:UIColorFromRGB(TextSizeSixColor)];
        [_label setLinkTextColor:UIColorFromRGB(BgTitleColor)];
        _label.numberOfLines = 0;
//        [label setText:message];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setHtml:message];
        [_label sizeToFit];
        
        [_label setLinkPressedBlock:^(NSTextCheckingResult *textCheckingResult) {
            //        NSLog(@"textCheckingResult => %@", textCheckingResult.URL.absoluteString);
            NSString *url = [textCheckingResult.URL.absoluteString stringByReplacingOccurrencesOfString:@"sjhz://" withString:@""];
            
            if(super.block){
                super.block(0,url);
            }
            [super dismiss];
        }];
        
        
        [super.subContentView addSubview:_label];
        
        
        CGRect cf = _label.frame;
        
        CGRect sf = super.subContentView.frame;
        sf.size.height = cf.size.height ;
        super.subContentView.frame = sf;
        
        [super layoutConentView];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
