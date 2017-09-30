//
//  ZCMenuCell.m
//  ExpertApp
//
//  Created by zhangxy on 16/5/18.
//  Copyright © 2016年 com.Expert.chat.app. All rights reserved.
//

#import "ZCMenuCell.h"


@implementation ZCMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _iconView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 40, ItemHeight-15)];
        [_iconView setContentMode:UIViewContentModeScaleAspectFit];
        [_iconView.layer setMasksToBounds:YES];
        [_iconView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_iconView];
        
        _titleLabel=[[UILabel alloc] init];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_titleLabel setFont:ListTimeFont];
        [_titleLabel setTextColor:UIColorFromRGB(TextUnPlaceHolderColor)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_titleLabel];
        
        
        self.userInteractionEnabled=YES;
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void) InitDataToView:(ZCMenuItem *)item{
    if(item.iconImage!=nil && convertToString(item.iconImage)){
        _iconView.hidden = NO;
        [_iconView setImage:[UIImage imageNamed:item.iconImage]];
        
        [_titleLabel setFrame:CGRectMake(60, 0,  ScreenWidth-60,ItemHeight)];
        [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }else{
        _iconView.hidden = YES;
        [_titleLabel setFrame:CGRectMake(10, 0,ScreenWidth-20, ItemHeight)];
        [_titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    
    if(item.titleFont){
        [_titleLabel setFont:item.titleFont];
    }else{
        [_titleLabel setFont:TitleFont];
    }
    [_titleLabel setText:item.title];
    
    if(item.checked){
        [_titleLabel setTextColor:item.tintColor];
    }else{
        [_titleLabel setTextColor:item.textColor];
    }
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ItemHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
