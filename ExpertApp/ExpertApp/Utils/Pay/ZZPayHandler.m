//
//  ZZPayHandler.m
//  ExpertApp
//
//  Created by zhangxy on 2017/9/13.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ZZPayHandler.h"

#import <WXApi.h>

#import <AlipaySDK/AlipaySDK.h>

@implementation ZZPayHandler

+(void)startJumppay:(int)userId payType:(ZZPayType)payType type:(int)type otherId:(NSString *)otherId desc:(NSString *)desc prict:(CGFloat)price result:(void (^)(int code, NSString *msg))payResult{
    ZZUserInfo *loginUser = [ZZDataCache getInstance].getLoginUser;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:convertIntToString(loginUser.userId) forKey:@"userId"];
    NSString *orderName = @"test";
    // 1，文章，2 会诊，3打赏
    if(type == 1){
       orderName = [NSString stringWithFormat:@"打赏文章--%@",desc];
    }else if(type == 2){
        orderName = [NSString stringWithFormat:@"会诊支付--%@",desc];
    }else{
        orderName = [NSString stringWithFormat:@"打赏医生--%@",desc];
    }
    [dict setObject:orderName forKey:@"orderName"];
    [dict setObject:[NSString stringWithFormat:@"%f",0.01] forKey:@"orderPrice"];
    
    [dict setObject:(payType == ZZPayTypeWX)?@"wx":@"zfb" forKey:@"payType"];
    
    
    [SVProgressHUD show];
    [ZZRequsetInterface post:API_payOrder param:dict timeOut:HttpGetTimeOut start:^{
        
    } finish:^(id response, NSData *data) {
        
        NSLog(@"返回数据：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    } complete:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        if(payType == ZZPayTypeWX){
            [self jumpToWXBizPay:dict[@"retData"] result:payResult];
        }else{
            [self jumpToAliPay:dict[@"retData"] result:payResult];
        }
        
    } fail:^(id response, NSString *errorMsg, NSError *connectError) {
        [SVProgressHUD dismiss];
        if(payResult){
            payResult(1,errorMsg);
        }
    } progress:^(CGFloat progress) {
        
    }];
}


+ (void)jumpToWXBizPay:(NSDictionary *) resultDict result:(void (^)(int code, NSString *msg))payResult{
        NSString *payInfo = [resultDict objectForKey:@"payInfo"];
        NSDictionary *dict= [NSJSONSerialization JSONObjectWithData:[convertToString(payInfo) dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        if (payInfo != nil && dict){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            BOOL isOK = [WXApi sendReq:req];
            //日志输出
            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@ ---- %d",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign,isOK);
            
//            [[UIApplication sharedApplication].delegate.window makeToast:@"支付成功"];
//            payResult(0,[dict objectForKey:@"retmsg"]);
        }else{
            if(payResult){
                payResult(2,@"服务器返回错误，未获取到支付对象");
            }
        }
    
}


+(void)jumpToAliPay:(NSDictionary *) dict result:(void (^)(int code, NSString *msg))payResult{
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = dict[@"payInfo"];
    if (orderString != nil) {
//        NSString *signedString = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB";
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderString, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"sjhz" callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if(resultDic){
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if(payResult){
                    NSString *returnStr;
                    
                    if([resultDic[@"resultStatus"] intValue] == 9000){
                        returnStr = @"支付成功";
                    }else{
                        switch (orderState) {
                            case 8000:
                                returnStr=@"订单正在处理中";
                                break;
                            case 4000:
                                returnStr=@"订单支付失败";
                                break;
                            case 6001:
                                returnStr=@"订单取消";
                                break;
                            case 6002:
                                returnStr=@"网络连接出错";
                                break;
                                
                            default:
                                break;
                        }
                        
//                        payResult(1,returnStr);
                    }
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:returnStr delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }];
    }
}

@end
