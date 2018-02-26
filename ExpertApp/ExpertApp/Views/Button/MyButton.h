//
//  MyButton.h
//  ExpertApp
//
//  Created by zhangxy on 2017/7/19.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIButton

@property(nonatomic,strong) id objTag;


-(void)centerImageUpTextDown;

- (void)verticalImageAndTitle:(CGFloat)spacing;

-(void)fillImageView;

@end
