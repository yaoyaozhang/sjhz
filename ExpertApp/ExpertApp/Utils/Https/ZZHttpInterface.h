
//  ZCLibInterface.h
//  ExpertLib
//
//  Created by lizhihui on 2017/4/17.
//  Copyright © 2017年 zhichi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreText/CoreText.h>
/**
 * 接口
 */
////////////////////////////////////////////////////////////////

#define API_HOST @"http://47.94.131.85:8080"
//#define API_HOST @"http://ycl.ngrok.cc/sjhz-yu"
//#define API_HOST @"http://192.168.99.123:8080"
//#define API_HOST @"http://219.142.225.69:8123"
//#define API_HOST @"http://192.168.8.102:8080"

/**
 *  发送验证码
 */
#define API_SendSms [NSString stringWithFormat:@"%@/user/appSendSms",API_HOST]
#define API_ProtocolUser [NSString stringWithFormat:@"%@/Protocol/user_protocol.html",API_HOST]
#define API_ProtocolDoctor [NSString stringWithFormat:@"%@/Protocol/doctor_protocol.html",API_HOST]


#define API_updateDoctorDn [NSString stringWithFormat:@"%@/doctor/updateDoctorDn",API_HOST]


#define API_Register [NSString stringWithFormat:@"%@/user/appRegUser",API_HOST]


#define API_UploadFile [NSString stringWithFormat:@"%@/file/upload",API_HOST]



#define API_Login [NSString stringWithFormat:@"%@/user/appLogin",API_HOST]


#define API_FindUserInfoByUserId [NSString stringWithFormat:@"%@/user/appGetUserInfoById",API_HOST]


#define API_FindUserByThirdId [NSString stringWithFormat:@"%@/user/thirdLogin",API_HOST]

#define API_findUserFriend [NSString stringWithFormat:@"%@/user/getUserToUser",API_HOST]


#define API_UpdatePwd [NSString stringWithFormat:@"%@/user/appFindPassWord",API_HOST]


#define API_UpdateUserInfo [NSString stringWithFormat:@"%@/user/appUpdateUser",API_HOST]


#define API_SaveCase [NSString stringWithFormat:@"%@/comconCase/add",API_HOST]
#define API_SaveSportCase [NSString stringWithFormat:@"%@/sportCase/add",API_HOST]

#define API_DelCase [NSString stringWithFormat:@"%@/comconCase/delCase",API_HOST]


///////////////////////////////患者相关/////////////////
#define API_saveHealth [NSString stringWithFormat:@"%@/symptom/saveHealth",API_HOST]
#define API_serHealthList [NSString stringWithFormat:@"%@/symptom/serHealthList",API_HOST]
#define API_delHealth [NSString stringWithFormat:@"%@/symptom/delHealth",API_HOST]
#define API_serHealthById [NSString stringWithFormat:@"%@/symptom/serHealthById",API_HOST]


///////////////////////////////症状相关/////////////////
#define API_symptonList [NSString stringWithFormat:@"%@/symptom/symptonList",API_HOST]
#define API_symptonWt [NSString stringWithFormat:@"%@/symptom/symptonWt",API_HOST]
#define API_saveSymptonWt [NSString stringWithFormat:@"%@/symptom/saveSymptonWt",API_HOST]


#define API_getUserPom [NSString stringWithFormat:@"%@/symptom/getUserPom",API_HOST]

// 获取会诊记录详情
#define API_symptonInterrogation [NSString stringWithFormat:@"%@/symptom/symptonInterrogation",API_HOST]


#define API_searchWikit [NSString stringWithFormat:@"%@/symptom/searchWikit",API_HOST]

// 根据档案id查询会诊记录
#define API_serachDocCaseByHealthId [NSString stringWithFormat:@"%@/doctor/serachDocCaseByHealthId",API_HOST]




/**
 添加会诊记录

 @param 不可空
 @return
 */
#define API_AddDiscussCase [NSString stringWithFormat:@"%@/doctor/selectDoctor",API_HOST]
#define API_AddOtherDoctor [NSString stringWithFormat:@"%@/doctor/selectOtherDoctor",API_HOST]


/**
 确定会诊

 @param 不可空
 @return
 */
#define API_SetCaseStateByDoctor [NSString stringWithFormat:@"%@/doctor/doSomeByDoctor",API_HOST]


/**
 填写会诊结果

 @param 不可空
 @return
 */
#define API_WriteCaseResult [NSString stringWithFormat:@"%@/doctor/upResultCase",API_HOST]



/**
 获取会诊结果

 @param 不可空
 @return
 */
#define API_GetCaseResult [NSString stringWithFormat:@"%@/doctor/getCaseResult",API_HOST]



/**
 获取会诊讨论内容

 @param 不可空
 @return
 */
#define API_GetCaseTalk [NSString stringWithFormat:@"%@/doctor/getTalkCase",API_HOST]



/**
 保存会诊记录

 @param 不可空
 @return
 */
#define API_SaveTalkCase [NSString stringWithFormat:@"%@/doctor/saveTalkCase",API_HOST]



/**
 查询会诊列表

 @param 不可空 type 0 用户1、医生
 @return
 */
#define API_SearchDocCase [NSString stringWithFormat:@"%@/doctor/serachDocCase",API_HOST]


#define API_SearchDocCaseByState [NSString stringWithFormat:@"%@/doctor/serachDocCaseByState",API_HOST]


/**
 查询病例

 @param 不可空 1 是普通 ，2运动  userid
 @return
 */
#define API_SearchAllCase [NSString stringWithFormat:@"%@/comconCase/serachAllCase",API_HOST]
#define API_SearchCaseDetail [NSString stringWithFormat:@"%@/comconCase/serachCase",API_HOST]



#define API_findBaseInfo [NSString stringWithFormat:@"%@/baseInfo/info",API_HOST]

// 用户首页
#define API_findUserHome [NSString stringWithFormat:@"%@/doctor/findHome",API_HOST]

// 搜索医生
#define API_searchDoctor [NSString stringWithFormat:@"%@/doctor/findDoctorAll",API_HOST]

// 关注的医生
#define API_getMyDoctorList [NSString stringWithFormat:@"%@/doctor/getMyDoctorInfo",API_HOST]



/**
 取消关注

 @param 不可空 <#不可空 description#>
 @return <#return value description#>
 */
#define API_delMyDoctorList [NSString stringWithFormat:@"%@/doctor/delUserToUser",API_HOST]


/**
 评价会诊结果
 @param 不可空
 @return
 */
#define API_getTalkAssess [NSString stringWithFormat:@"%@/doctor/saveTalkAssess",API_HOST]


// 收藏文章
/**
 nid	String	新闻ID(不可空)
 uid	String	用户ID(不可空)
 collectiontType	String	收藏类型(不可空)[1:收藏,2:取消收藏]
 @return
 */
#define API_CollectChapter [NSString stringWithFormat:@"%@/comment/opertionCollection",API_HOST]



/**
 用户收藏列表

 @param nid <#nid description#>
 @return <#return value description#>
 */
#define API_findUserChapterList [NSString stringWithFormat:@"%@/news/appFindNewsByUserId",API_HOST]


/**
 查询医生详情页的文章

 @param nid
 @return
 */
#define API_FindDoctorInfoByUserId [NSString stringWithFormat:@"%@/doctor/lookDoctor",API_HOST]
#define API_findDoctorHomeChapter [NSString stringWithFormat:@"%@/news/appFindNewsDocId",API_HOST]
#define API_findDoctorChapterList [NSString stringWithFormat:@"%@/news/appFindNewsAllDocId",API_HOST]
#define API_getChapterList [NSString stringWithFormat:@"%@/news/appFindNewsByNewsType",API_HOST]

//#define API_getChapterDetail(nid) [NSString stringWithFormat:@"%@/news/bronews.html?nid=%d",API_HOST,nid]
#define API_getChapterDetail(nid) [NSString stringWithFormat:@"%@/news/wz/chapter.html?nid=%d",API_HOST,nid]


#define API_SendChapterComment [NSString stringWithFormat:@"%@/comment/appSaveComment",API_HOST]
#define API_findChapterComment [NSString stringWithFormat:@"%@/comment/findCommentById",API_HOST]


/**
 关注医生或用户

 @return toUserId
 */
#define API_followUserDoctor [NSString stringWithFormat:@"%@/doctor/followDoctor",API_HOST]
#define API_delCaseById [NSString stringWithFormat:@"%@/doctor/delCaseById",API_HOST]



/**
 支付接口

 @return
 */
#define API_payOrder [NSString stringWithFormat:@"%@/pay/createOrder",API_HOST]


#define API_findNewsTops [NSString stringWithFormat:@"%@/comment/findMessageTop10",API_HOST]
#define API_findNews [NSString stringWithFormat:@"%@/comment/findMessage",API_HOST]
#define API_updateMessage [NSString stringWithFormat:@"%@/comment/updateMessage",API_HOST]



/**
 查询问卷

 @return quesId
 */
#define API_serachWenJuan [NSString stringWithFormat:@"%@/question/serachWenJuan",API_HOST]
#define API_saveWenJuan [NSString stringWithFormat:@"%@/question/saveAnswer",API_HOST]
#define API_findWenjuanList [NSString stringWithFormat:@"%@/question/serachWenJuanList",API_HOST]
#define API_findLiangBiaoList [NSString stringWithFormat:@"%@/question/serachLiangbiaoList",API_HOST]

#define API_findWenjuanDetail [NSString stringWithFormat:@"%@/question/serachWenJuanAnswer",API_HOST]
#define API_checkWenjuanByUserId [NSString stringWithFormat:@"%@/question/serachWenJuanByUserId",API_HOST]






#define API_saveRemarkName [NSString stringWithFormat:@"%@/user/saveUserRemark",API_HOST]



