//
//  ZCTTMLEmojiLabell.h
//  ZCTTMLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TTTAttributedLabel.h"


typedef NS_OPTIONS(NSUInteger, ZCTTMLEmojiLabelLinkType) {
    ZCTTMLEmojiLabelLinkTypeURL = 0,
    ZCTTMLEmojiLabelLinkTypeEmail,
    ZCTTMLEmojiLabelLinkTypePhoneNumber,
    ZCTTMLEmojiLabelLinkTypeAt,
    ZCTTMLEmojiLabelLinkTypePoundSign,
};


@class ZCTTMLEmojiLabel;
@protocol ZCTTMLEmojiLabelDelegate <TTTAttributedLabelDelegate>

@optional
- (void)ZCMLEmojiLabel:(ZCTTMLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(ZCTTMLEmojiLabelLinkType)type;


@end

@interface ZCTTMLEmojiLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式
@property (nonatomic, copy) NSString *customEmojiBundleName; //自定义表情图片所存储的bundleName xxxx.bundle格式

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, weak) id<ZCTTMLEmojiLabelDelegate> delegate; //点击连接的代理方法
#pragma clang diagnostic pop

@property (nonatomic, copy, readonly) id emojiText; //外部能获取text的原始副本

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;


-(void)setLinkColor:(UIColor *) color;

/**
 *  提取A标签中的内容
 *
 *  @param searchText 输入内容
    text,返回实际文本
    arr,返回的字典，包含内容
        realFromIndex:链接的点击坐标，长度同htmlText
        url:标签的URL
        htmlText:标签显示内容
 *
 *  @return
 */
-(NSMutableDictionary *) getTextADict:(NSString *) searchText;


@end
