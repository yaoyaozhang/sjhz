//
//  ZZRemakBaseCell.m
//  ExpertApp
//
//  Created by zhangxy on 2017/11/6.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZRemakBaseCell.h"

@implementation ZZRemakBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _labTitle=[[UILabel alloc] init];
    [_labTitle setTextAlignment:NSTextAlignmentCenter];
    [_labTitle setFont:ListTitleFont];
    [_labTitle setTextColor:TextBlackColor];
    [_labTitle setTextAlignment:NSTextAlignmentLeft];
    [_labTitle setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:_labTitle];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _labTitle=[[UILabel alloc] init];
        [_labTitle setTextAlignment:NSTextAlignmentCenter];
        [_labTitle setFont:ListTitleFont];
        [_labTitle setTextColor:TextBlackColor];
        [_labTitle setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_labTitle];
    }
    return self;
}

-(void)dataToView:(NSDictionary *)item{
    if(item){
        [_labTitle setFrame:CGRectMake(15, 8, 80, 28)];
        [_labTitle setText:convertToString(item[@"name"])];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
