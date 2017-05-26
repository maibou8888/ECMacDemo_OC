//
//  ECImageMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/5/7.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECFileMessageBody.h"
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

/**
 *  图片消息体
 */
@interface ECImageMessageBody : ECFileMessageBody

/**
 @brief 附件是否下载完成
 */
@property (nonatomic)ECMediaDownloadStatus thumbnailDownloadStatus;

/**
 @brief 缩略图本地文件路径
 */
@property (nonatomic, strong) NSString *thumbnailLocalPath;

/**
 @brief 缩略图服务器远程文件路径
 */
@property (nonatomic, strong) NSString *thumbnailRemotePath;

/**
 @brief 图片的size
 */
@property (nonatomic, assign) CGSize size;

/**
 @method
 @brief 以文件路径构造文件对象
 @discussion
 @param filePath 磁盘文件全路径
 @param displayName 文件对象的显示名
 @result 文件对象
 */
- (id)initWithFile:(NSString *)filePath displayName:(NSString *)displayName;
@end
