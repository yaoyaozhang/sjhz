//
//  ZZShareView.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/7.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZShareView.h"
#import <UShareUI/UShareUI.h>
#import "UIButtonUpDown.h"

#import "ZZUserHomeModel.h"
#import "ZZChapterModel.h"
#import "ZZKnowledgeTopicModel.h"
#import "ZZHZEngity.h"
#import "ZZQSModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <WXApi.h>


@interface ZZShareView(){
    ZZShareType zzShareType;
}

@property(nonatomic,strong) UIViewController *curVC;
@property(nonatomic,assign) ZZShareType type;
@property(nonatomic,strong) UIView *bottomView;

@end


@implementation ZZShareView

-(instancetype)initWithShareType:(ZZShareType)type vc:(UIViewController *)vc{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    if (self)
    {
//        JumpToBizProfileReq *req = [JumpToBizProfileReq new];req.username = @"gh_xxxxxxx"; // 原始ID
//        req.profileType = WXBizProfileType_Normal;//这里还可以选择硬件公众号req.extMsg = @"";
//        //选择硬件公众号，这里加入绑定设备的链接[WXApi sendReq:req];
        _type = type;
        
        _curVC = vc;
        self.backgroundColor = [UIColor clearColor];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisMenu)];
        [self addGestureRecognizer:tap];
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-180, ScreenWidth, 180)];
        _bottomView.backgroundColor = UIColorFromRGBAlpha(TextBlackColor, 0.7);
        [self addSubview:_bottomView];
        
        
        [self createShareButton:1];
        [self createShareButton:2];
        [self createShareButton:3];
        [self createShareButton:4];
        
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setFrame:CGRectMake(ScreenWidth/2-22, 180-64, 44, 44)];
        [btnClose setImage:[UIImage imageNamed:@"share_close"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(dissmisMenu) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btnClose];
    }
    
    return self;
}

-(void)createShareButton:(int) i{
    CGFloat y = 20;
    CGFloat itemW = (ScreenWidth-84 - 30)/4;
    CGFloat x = 42 + (i-1)*itemW + (i-1)*10;
    UIButtonUpDown *btn = [UIButtonUpDown buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(x, y, itemW, 78)];
    [btn setTitleColor:UIColorFromRGB(TextWhiteColor) forState:UIControlStateNormal];
    [btn.titleLabel setFont:ListTimeFont];
    [btn addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn];
    
    if(i==1){
        [btn setImage:[UIImage imageNamed:@"share_wechat"] forState:UIControlStateNormal];
        [btn setTitle:@"微信好友" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_WechatSession;
    }else if(i==2){
        [btn setImage:[UIImage imageNamed:@"share_wechat_circle"] forState:UIControlStateNormal];
        [btn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_WechatTimeLine;
    }else if(i==3){
        [btn setImage:[UIImage imageNamed:@"share_sina"] forState:UIControlStateNormal];
        [btn setTitle:@"新浪微博" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_Sina;
    }else if(i==4){
        [btn setImage:[UIImage imageNamed:@"share_qq"] forState:UIControlStateNormal];
        [btn setTitle:@"QQ好友" forState:UIControlStateNormal];
        btn.tag = UMSocialPlatformType_QQ;
    }
}

-(void)shareWithButton:(UIButtonUpDown *) shareButton{
    UMSocialPlatformType shareType = shareButton.tag;
    
    if(shareType == UMSocialPlatformType_WechatSession || shareType == UMSocialPlatformType_WechatTimeLine){
        [self shareButtonClick:shareButton];
        return;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *action = @"";
    if(_type == ZZShareTypeUser){
        ZZUserInfo *userModel = (ZZUserInfo *)_shareModel;
        if([@"" isEqual:convertToString(userModel.docName)]){
            userModel.docName = convertToString(userModel.accomplished);
        }
        
        action = [NSString stringWithFormat:@"sjhz://doctor?userId=%d",userModel.userId];
        
//        shareObject = [UMShareVideoObject shareObjectWithTitle:userModel.docName descr:convertToString(userModel.departmentName) thumImage:[UIImage imageNamed:@"Icon120"]];
//        shareObject.thumbImage = [UIImage imageNamed:@"Icon120"];
//        shareObject.thumbImage = convertToString(@"https://static.pgyer.com/static-20171115/images/newHome/header_marker.png");
        
        messageObject.text = userModel.docName;
        messageObject.title = convertToString(userModel.departmentName);
        
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.title = [NSString stringWithFormat:@"%@-%@",convertToString(userModel.docName),convertToString(userModel.departmentName)];
        shareObject.descr = convertToString(userModel.context);
//        shareObject.shareImage = convertToString(userModel.imageUrl);
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userModel.imageUrl];
        if (cachedImage == nil) {
            shareObject.thumbImage = thumbImage;
            shareObject.shareImage = thumbImage;
        }else {
            
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [shareObject setThumbImage:[UIImage imageWithData:UIImagePNGRepresentation(newImage)]];
            
            shareObject.shareImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        
        // 必须为视频
        messageObject.shareObject = shareObject;
    }else if(_type == ZZShareTypeChapter){
        ZZChapterModel *model = (ZZChapterModel *)_shareModel;
//        shareObject = [UMShareObject shareObjectWithTitle:model.author descr:model.title thumImage:model.picture];
//        shareObject.thumbImage = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
        
        messageObject.text = model.title;
        messageObject.title =convertToString(model.content);
        
        action = [NSString stringWithFormat:@"sjhz://news?id=%d",model.nid];
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        //        shareObject.shareImage = convertToString(userModel.imageUrl);
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.picture];
        if (cachedImage != nil) {
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            thumbImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        
        
        // 文章、音频、视频 1,2，3
        if(model.lclassify == 1){
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.title = convertToString(model.title);
            shareObject.descr = convertToString(model.content);
            
            shareObject.thumbImage = thumbImage;
            shareObject.shareImage = thumbImage;
            messageObject.shareObject = shareObject;
        }else if(model.lclassify == 2){
            UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:convertToString(model.title) descr:convertToString(model.content) thumImage:thumbImage];
            shareObject.musicUrl = model.addressUrl;
            messageObject.shareObject = shareObject;
            
        }else{
            UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:convertToString(model.title) descr:convertToString(model.content) thumImage:thumbImage];
            shareObject.videoUrl = model.addressUrl;
            messageObject.shareObject = shareObject;
        }
        
    }else if(_type == ZZShareTypeKnowledgeDetail){
        ZZKnowledgeTopicModel *model = (ZZKnowledgeTopicModel *)_shareModel;
        //        shareObject = [UMShareObject shareObjectWithTitle:model.author descr:model.title thumImage:model.picture];
        //        shareObject.thumbImage = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
        
        messageObject.text = convertToString(model.introduce).length > 100 ? [convertToString(model.introduce) substringToIndex:99]: convertToString(model.introduce);
        messageObject.title =  convertToString(model.className);
        
        action = [NSString stringWithFormat:@"sjhz://knowledge?id=%d",model.sid];
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        //        shareObject.shareImage = convertToString(userModel.imageUrl);
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.classUrl];
        if (cachedImage != nil) {
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            thumbImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.title = convertToString(messageObject.title);
        shareObject.descr = convertToString(messageObject.text);
        
        shareObject.thumbImage = thumbImage;
        shareObject.shareImage = thumbImage;
        messageObject.shareObject = shareObject;
        
    }else if(_type == ZZShareTypeHZResult){
        ZZHZEngity *model = (ZZHZEngity *)_shareModel;
//        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
        
        messageObject.text = model.caseName;
        messageObject.title = model.caseResult;
        
        action = [NSString stringWithFormat:@"sjhz://case?caseId=%d&state=%d",model.caseId,model.state];
//        messageObject.shareObject = shareObject;
    }else if(_type == ZZShareTypeLiangBiao || _type == ZZShareTypeWenJuan){
        ZZQSListModel *model = (ZZQSListModel *)_shareModel;
        //        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
        
        messageObject.text = model.quesName;
        messageObject.title =[NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],_type == ZZShareTypeLiangBiao?@"量表":@"问卷"];
        
        //        messageObject.shareObject = shareObject;
        if(_type == ZZShareTypeLiangBiao){
            action = [NSString stringWithFormat:@"sjhz://liangbiao?lbId=%d&type=%d",model.wenjuanId,model.type];
        }else{
            action = [NSString stringWithFormat:@"sjhz://wenjuan?wjId=%d&type=%d",model.wenjuanId,model.type];
        }
    }else if(_type == ZZShareTypeKnowledgeList){
//        ZZQSListModel *model = (ZZQSListModel *)_shareModel;
        //        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
        
        messageObject.text = @"";
        
        messageObject.title =[NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],@"精品课"];
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        UMShareWebpageObject *webOjb = [UMShareWebpageObject shareObjectWithTitle:messageObject.title descr:@"" thumImage:thumbImage];
        webOjb.webpageUrl = @"http://www.sanjiahuizhen.com/news/zhuanti/allCourse.html";
        action = [NSString stringWithFormat:@"sjhz://jpklist?type=2"];
       
                  
        messageObject.shareObject = webOjb;
    }else if(_type == ZZShareTypeUserImage){
        messageObject.text = @"";
        
        messageObject.title =[NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],[ZZDataCache getInstance].getLoginUser.userName];
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        UMShareImageObject *webOjb = [UMShareImageObject shareObjectWithTitle:messageObject.title descr:@"" thumImage:thumbImage];
        webOjb.shareImage = _shareModel;
        action = @"";
        
        
        messageObject.shareObject = webOjb;
    }
    
    
    messageObject.moreInfo = @{@"action":action};
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:_curVC completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
            [_curVC.view makeToast:@"分享失败！"];
        }else{
            NSLog(@"response data is %@",data);
//            [_curVC.view makeToast:@"分享成功！"];
        }
    }];
    
    if(![[UMSocialManager defaultManager] isInstall:shareType]){
        [self dissmisMenu];
    }
}


- (void)dissmisMenu{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = sheetViewF;
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)show{
    CGRect sheetViewF = self.frame;
    sheetViewF.origin.y = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = sheetViewF;
    } completion:^(BOOL finished) {
        
    }];
}




-(void)shareButtonClick:(UIButtonUpDown *) shareButton{
    UMSocialPlatformType shareType = shareButton.tag;
//    Byte* pBuffer = (Byte *)malloc(1024*100);
//    memset(pBuffer, 0, 1024*100);
//    NSData *data = [NSData dataWithBytes:pBuffer length:1024*100];
//    free(pBuffer);
    
    UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
    
    static NSString *kAppMessageAction = @"<action>sjhz</action>";
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = [NSString stringWithFormat:@"http://www.sanjiahuizhen.com/home.html?1=1"];
    ext.fileData = [@"三甲慧诊" dataUsingEncoding:NSUTF8StringEncoding];
    
    //分享网页给好友
    WXMediaMessage *message = [WXMediaMessage message];
    
    if(_type == ZZShareTypeUser){
        ZZUserInfo *userModel = (ZZUserInfo *)_shareModel;
        if([@"" isEqual:convertToString(userModel.docName)]){
            userModel.docName = convertToString(userModel.accomplished);
        }
        
        message.title = userModel.docName;
        message.description = convertToString(userModel.accomplished).length>100?[userModel.accomplished substringToIndex:100]:userModel.accomplished;
        message.messageExt = [NSString stringWithFormat:@"sjhz://doctor?userId=%d",userModel.userId];
        message.messageAction = kAppMessageAction;
        message.mediaTagName = nil;
        
//        [message setThumbImage:thumbImage];
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:userModel.imageUrl];
        
        if (cachedImage != nil) {
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            thumbImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        [message setThumbImage:thumbImage];
        ext.url = API_getShareDoctorDetail(userModel.userId, [ZZDataCache getInstance].getLoginUser.userId);
        
        
    }else if(_type == ZZShareTypeKnowledgeDetail){
        ZZKnowledgeTopicModel *model = (ZZKnowledgeTopicModel *)_shareModel;
        //        shareObject = [UMShareObject shareObjectWithTitle:model.author descr:model.title thumImage:model.picture];
        //        shareObject.thumbImage = @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4";
        
        message.description = convertToString(model.introduce).length > 100 ? [convertToString(model.introduce) substringToIndex:100]: convertToString(model.introduce);
        message.title =  convertToString(model.className);
        
        
        message.messageExt =  [NSString stringWithFormat:@"sjhz://knowledge?id=%d",model.sid];
        message.messageAction = kAppMessageAction;
        message.mediaTagName = nil;
        
        
        UIImage *thumbImage = [UIImage imageNamed:@"Icon120"];
        //        shareObject.shareImage = convertToString(userModel.imageUrl);
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.classUrl];
        if (cachedImage != nil) {
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            thumbImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        
        [message setThumbImage:thumbImage];
        
        ext.url = API_getKnowledgeDetailH5(model.sid);
        
        
        WXWebpageObject *page = [WXWebpageObject object];
        page.webpageUrl = ext.url;
        message.mediaObject = page;
    }else if(_type == ZZShareTypeChapter){
        ZZChapterModel *model = (ZZChapterModel *)_shareModel;
        
        message.title = convertToString(model.title);
        message.description = convertToString(model.title).length>100?[model.title substringToIndex:100]:model.title;
        message.messageExt = [NSString stringWithFormat:@"sjhz://news?id=%d",model.nid];
        message.messageAction = kAppMessageAction;
        message.mediaTagName = nil;
//        [message setThumbImage:thumbImage];
        
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.picture];
        
        if (cachedImage != nil) {
            CGSize newsize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(newsize);
            [cachedImage drawInRect:CGRectMake(0, 0, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            thumbImage = [UIImage imageWithData:UIImagePNGRepresentation(newImage)];
        }
        [message setThumbImage:thumbImage];
        
        
        // 文章、音频、视频 1,2，3
        if(model.lclassify == 1){
            WXImageObject *shareObject = [WXImageObject object];
            shareObject.imageData =  UIImagePNGRepresentation(thumbImage);
            message.mediaObject = shareObject;
        }else if(model.lclassify == 2){
            WXMusicObject *shareObject = [WXMusicObject object];
            shareObject.musicUrl =  model.addressUrl;
            message.mediaObject = shareObject;
        }else{
            WXVideoObject *shareObject = [WXVideoObject object];
            shareObject.videoUrl = model.addressUrl;
            message.mediaObject = shareObject;
        }
        
        ext.url = API_getChapterDetail(model.nid);
    }else if(_type == ZZShareTypeHZResult){
        ZZHZEngity *model = (ZZHZEngity *)_shareModel;
        
        message.title = model.caseName;
        message.description = convertToString(model.caseResult).length>100?[model.caseResult substringToIndex:100]:model.caseResult;
        message.messageExt = [NSString stringWithFormat:@"sjhz://case?caseId=%d&state=%d",model.caseId,model.state];
        message.messageAction = kAppMessageAction;
        message.mediaTagName = nil;
        [message setThumbImage:thumbImage];
    }else if(_type == ZZShareTypeLiangBiao || _type == ZZShareTypeWenJuan){
        ZZQSListModel *model = (ZZQSListModel *)_shareModel;
        //        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
        message.title = [NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],_type == ZZShareTypeLiangBiao?@"量表":@"问卷"];
        message.description =model.quesName;
        if(_type == ZZShareTypeLiangBiao){
            message.messageExt = [NSString stringWithFormat:@"sjhz://liangbiao?lbId=%d&type=%d",model.wenjuanId,model.type];
        }else{
            message.messageExt = [NSString stringWithFormat:@"sjhz://wenjuan?wjId=%d&type=%d",model.wenjuanId,model.type];
        }
        message.messageAction = kAppMessageAction;
        message.mediaTagName = nil;
        [message setThumbImage:thumbImage];
        //        messageObject.shareObject = shareObject;
    }else if(_type == ZZShareTypeKnowledgeList){
        //        shareObject = [UMShareObject shareObjectWithTitle:model.caseName descr:model.caseResult thumImage:nil];
       
        message.messageExt = [NSString stringWithFormat:@"sjhz://jpklist?type=2"];
        
        message.title = [NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],@"精品课"];
        message.description = @"";
        message.messageAction = kAppMessageAction;
        
        WXWebpageObject *webOjb = [WXWebpageObject object];
        webOjb.webpageUrl = @"http://www.sanjiahuizhen.com/news/zhuanti/allCourse.html";
        
        ext.url = webOjb.webpageUrl;
        
        message.mediaObject = webOjb;
    }else if(_type == ZZShareTypeUserImage){
//        message.messageExt = [NSString stringWithFormat:@"sjhz://jpklist?type=2"];
//        message.messageExt = @"";
//        message.title = [NSString stringWithFormat:@"%@-%@",[ZZCoreTools getAppName],[ZZDataCache getInstance].getLoginUser.userName];
//        message.description = @"";
        message.messageAction = kAppMessageAction;
        
        WXImageObject *webOjb = [WXImageObject object];
        webOjb.imageData = UIImageJPEGRepresentation(_shareModel,1);
        
        
        message.mediaObject = webOjb;
    }
    
//    朋友圈   from=timeline&isappinstalled=0
//    微信群   from=groupmessage&isappinstalled=0
//    好友分享 from=singlemessage&isappinstalled=0
//    if(shareType == UMSocialPlatformType_WechatTimeLine){
//        ext.url = [ext.url stringByAppendingString:@"&from=timeline&isappinstalled=0"];
//    }else{
//        ext.url = [ext.url stringByAppendingString:@"&from=singlemessage&isappinstalled=0"];
//    }
    
    if(_type == ZZShareTypeChapter || _type == ZZShareTypeUser || _type == ZZShareTypeKnowledgeList || _type == ZZShareTypeKnowledgeDetail){
        WXWebpageObject *obj = [WXWebpageObject object];
        obj.webpageUrl = ext.url;
        message.mediaObject = obj;
    }else if(_type != ZZShareTypeUserImage){
        ext.extInfo = message.messageExt;
        message.mediaObject = ext;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    
    req.scene = WXSceneSession;
    if(shareType == UMSocialPlatformType_WechatTimeLine){
        //分享网页到朋友圈
        req.scene = WXSceneTimeline;
    }
    
    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
                [_curVC.view makeToast:@"分享失败！"];
            }else{
        //        NSLog(@"response data is %@",data);
        //        [_curVC.view makeToast:@"分享成功！"];
            }

        [self dissmisMenu];
    }];
//    BOOL isOK = [WXApi sendReq:req];
}

    
@end
