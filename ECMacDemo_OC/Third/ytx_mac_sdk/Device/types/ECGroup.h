//
//  ECGroupInfo.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 群组的类型
 */
typedef NS_ENUM(NSUInteger, ECGroupScope){
    
    /** 无  */
    ECGroupType_None=0,
    
    /** 临时组(上限100人)  */
    ECGroupType_Temp=1,
    
    /** 普通组(上限300人) */
    ECGroupType_Normal,
    
    /** 普通组高级(上限500人) */
    ECGroupType_Normal_Senior,
    
    /** VIP组(上限1000人) */
    ECGroupType_VIP,
    
    /** 高级VIP组(上限2000人) */
    ECGroupType_VIP_Senior,
} ;


/**
 * 群组加入模式
 */
typedef NS_ENUM(NSUInteger,ECGroupPermMode){
    
    /** 无 */
    ECGroupPermMode_None=0,
    
    /** 直接加入 */
    ECGroupPermMode_DefaultJoin=1,
    
    /** 需要身份验证 */
    ECGroupPermMode_NeedIdAuth,
    
    /** 私有群组 */
    ECGroupPermMode_PrivateGroup
} ;


/**
 * 群组信息类
 */
@interface ECGroup : NSObject

/**
 @property
 @brief groupId 群组id
 */
@property (nonatomic, copy) NSString *groupId;

/**
 @property
 @brief owner 群组所有者（创建者）
 */
@property (nonatomic, copy) NSString *owner;

/**
 @property
 @brief createdTime 群组创建时间
 */
@property (nonatomic, copy) NSString *createdTime;

/**
 @property
 @brief name 群组名称
 */
@property (nonatomic, copy) NSString *name;

/**
 @property
 @brief members 群成员
 */
@property (nonatomic, strong) NSArray *members;

/**
 @property
 @brief declared 群公告
 */
@property (nonatomic, copy) NSString *declared;

/**
 @property
 @brief remark 群备注，用于用户扩展字段
 */
@property (nonatomic, copy) NSString* remark;

/**
 @property
 @brief mode 群组加入的模式
 */
@property (nonatomic, assign) ECGroupPermMode mode;

/**
 @property
 @brief type 群类型
 */
@property (nonatomic, assign) ECGroupScope scope;

/**
 @property
 @brief memberCount 成员个数
 */
@property (nonatomic, assign) NSInteger memberCount;

/**
 @property
 @brief type （同学、朋友、同事等）
 1: 同学 2: 朋友 3: 同事  4：亲友  5：闺蜜  6：粉丝   7：基友 8：驴友  9：出国  10：家政  11：小区   12：比赛   50：其他    这些类型用下拉列表列出来。
 */
@property (nonatomic, assign) NSInteger type;

/**
 @property
 @brief province 省份
 */
@property (nonatomic, copy) NSString *province;

/**
 @property
 @brief city 城市
 */
@property (nonatomic, copy) NSString *city;

/**
 @property
 @brief isDismiss 创建者退出，群组是否解散
 */
@property (nonatomic, assign) BOOL isDismiss;

/**
 @property
 @brief isDiscuss 是否讨论组模式
 */
@property (nonatomic, assign) BOOL isDiscuss;

/**
 @property
 @brief isNotice 群消息设置 YES:提示 NO:不提示(免打扰)
 */
@property (nonatomic, assign) BOOL isNotice;

/**
 @property
 @brief isPushAPNS 群推送设置 YES:推送苹果服务器 NO:不推送
 */
@property (nonatomic, assign) BOOL isPushAPNS;


/**
 @method
 @brief 创建群组
 @param groupId 群组id
 */
-(ECGroup *)initWithID:(NSString *)groupId;

@end
