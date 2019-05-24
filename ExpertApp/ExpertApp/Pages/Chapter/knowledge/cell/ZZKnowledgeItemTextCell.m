//
//  ZZKnowledgeItemTextCell.m
//  ExpertApp
//
//  Created by zhangxy on 2018/4/20.
//  Copyright © 2018年 sjhz. All rights reserved.
//

#import "ZZKnowledgeItemTextCell.h"
#import "ZZOperaterView.h"

@implementation ZZKnowledgeItemTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_imgIcon setBackgroundColor:UIColor.clearColor];
    [_imgIcon setContentMode:UIViewContentModeCenter];
    
    [_imgLine setBackgroundColor:UIColorFromRGB(BgLineColor)];
    
    [_labTitle setFont:ListTitleFont];
    [_labTime setFont:ListDetailFont];
    
    [_labTitle setTextColor:UIColorFromRGB(TextBlackColor)];
    [_labTime setTextColor:UIColorFromRGB(TextLightDarkColor)];
}

-(void)dataToView:(ZZChapterModel *)item{
    if(item!=nil){
        _tempModel = item;
        [_labTitle setText:item.title];
        [_labTime setText:[NSString stringWithFormat:@"%@ %@",item.createTime,item.author]];
        [_labTitle setTextColor:UIColorFromRGB(TextDarkColor)];
        if(item.lclassify == 3){
            
            [_imgIcon setImage:[UIImage imageNamed:@"icon_list_video"]];
        }else if(item.lclassify == 1){
            [_imgIcon setImage:[UIImage imageNamed:@"icon_list_text"]];
        }else{
            if(item.isPlaying){
                [_imgIcon setImage:[UIImage imageNamed:@"icon_list_pause"]];
                [_labTitle setTextColor:UIColorFromRGB(BgTitleColor)];
                
            }else{
                [_imgIcon setImage:[UIImage imageNamed:@"icon_list_play"]];
                [_labTitle setTextColor:UIColorFromRGB(TextDarkColor)];
            }
        }
    }
}



-(IBAction)messageClick:(id)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:obj:)]){
        [self.delegate onItemClick:_tempModel type:3 obj:nil];
    }
//    if(self.delegate && [self.delegate respondsToSelector:@selector(onItemClick:type:)]){
//        [self.delegate onItemClick:_tempModel type:3];
//    };
}

-(IBAction)moreClick:(id)sender{
    
    ZZOperaterView *v = [[ZZOperaterView alloc] initWithShareType:(UIViewController *)self.delegate];
    v.operatorModel = _tempModel;
    [v show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
