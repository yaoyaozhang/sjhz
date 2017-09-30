//
//  ZZChannelCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/8/2.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZChannelCell.h"

@implementation ZZChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //		NSLog(@"%s", __func__);
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ZZChapterTVC" bundle:nil];
    _newsTVC = [sb instantiateInitialViewController];
    _newsTVC.view.frame = self.bounds;
    _newsTVC.urlString = urlString;
    [self addSubview:_newsTVC.view];
}


@end
