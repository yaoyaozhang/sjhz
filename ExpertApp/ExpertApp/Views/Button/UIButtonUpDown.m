//
//  UIButtonUpDown.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "UIButtonUpDown.h"

@implementation UIButtonUpDown

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGRect imgf = self.imageView.frame;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    
    imgf.origin.x = (self.frame.size.width-imgf.size.width)/2;
    imgf.origin.y = (self.frame.size.height - imgf.size.height - newFrame.size.height - 5)/2;
    self.imageView.frame = imgf;
    
    newFrame.origin.x = 0;
    newFrame.origin.y = imgf.origin.y + imgf.size.height + 5;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
