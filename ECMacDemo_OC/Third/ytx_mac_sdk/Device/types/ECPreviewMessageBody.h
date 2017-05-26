//
//  ECPreviewMessageBody.h
//  CCPiPhoneSDK
//
//  Created by admin on 16/3/18.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ECFileMessageBody.h"

@interface ECPreviewMessageBody : ECFileMessageBody

/**
 @brief 抓取的内容的地址
 */
@property (nonatomic, copy) NSString *url;

/**
 @brief 抓取的文章表头
 */
@property (nonatomic, copy) NSString *title;

/**
 @brief 抓取的文章描述
 */
@property (nonatomic, copy) NSString *desc;

/**
 @brief 缩略图服务器远程文件路径
 */
@property (nonatomic, copy) NSString *thumbnailRemotePath;

/**
 @brief 附件是否下载完成
 */
@property (nonatomic)ECMediaDownloadStatus thumbnailDownloadStatus;

/**
 @brief 缩略图本地文件路径
 */
@property (nonatomic, strong) NSString *thumbnailLocalPath;

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
