//
//  ECWhiteBoardManager.h
//  CCPiPhoneSDK
//
//  Created by wmz on 2017/4/11.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#ifdef SDK_Ver_WhiteBoard
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import "ECManagerBase.h"
#import "ECError.h"
#import "ECBoardRoom.h"

//撤销类型
typedef NS_ENUM(NSUInteger,ECUndoType) {
    ECUndo_Self = 0,    //撤销自己
    ECUndo_All = 1,     //撤销全部
};

//画线类型
typedef NS_ENUM(NSUInteger,ECLineShape) {
    ECLineShape_NONE = 0,
    ECLineShape_FREE = 1,
    ECLineShape_LINE = 2,
    ECLineShape_ANGLE = 3,
    ECLineShape_TRIANGLE = 4,
    ECLineShape_CIRCLE	= 5,
    ECLineShape_ELLIPSE = 6,
    ECLineShape_DASH_LINE = 7,
    ECLineShape_ARROW_MARK = 8,
    ECLineShape_ARROW_MARK1 = 9,
    ECLineShape_TEXTURE = 10,
    ECLineShape_SHAPE_END
};

@protocol ECWhiteBoardManager <ECManagerBase>

/**
 @brief  设置白板数据存储目录
 @param  dataPath 目录(此目录要求固定，目录内有文件创建，删除，写，读等权限)
 @return 0:成功 非0失败
 */
- (NSInteger)setDataPath:(NSString *)dataPath;

/**
 @brief  会议打开白板
 @param  confId 会议ID
 @param  completion 执行结果回调block
 */

- (void)open:(NSString *)confId completion:(void(^)(ECError* error ,ECBoardRoom *room))completion;

/**
 @brief  会议关闭白板
 @param  confId 会议ID
 @param  completion 执行结果回调block
 */
- (void)close:(NSString *)confId completion:(void(^)(ECError* error))completion;

/**
 @brief  文档上传
 @param  path 文件全路径
 @param  completion 执行结果回调block
 */
- (void)uploadDocWithPath:(NSString *)path completion:(void(^)(ECError* error ,NSNumber *state ,NSNumber *docId))completion;

/**
 @brief  设置文档的背景颜色。默认为黑色
 @param  color 背景颜色
 @return 0:成功 非0失败
 */
- (NSInteger)setDocBackgroundColor:(UIColor *)color;

/**
 @brief  文档共享
 @param  docId 文档id。为0表示白板，其他表示具体的文档
 @param  completion 执行结果回调block
 */
- (void)shareDocWitId:(int)docId completion:(void(^)(ECError* error ,NSNumber *currentPageIndex, NSNumber *pageNum))completion;

/**
 @brief  清除当前页的画线
 @param  userId 如果为NULL，则清除当前页的所有画线，否则只清除此用户的画线
 @param  completion 执行结果回调block
 */
- (void)clearCurrentPageWithUserId:(NSString *)userId completion:(void(^)(ECError* error))completion;

/**
 @brief  调到指定页面
 @param  pageIndex 页码
 @param  completion 执行结果回调block
 */
- (void)gotoPageIndex:(int)pageIndex completion:(void(^)(ECError* error ,NSNumber *currentPage ,NSNumber *pages))completion;

/**
 @brief  跳到下一页
 @param  completion 执行结果回调block
 */
- (void)gotoNextPageWithCompletion:(void(^)(ECError* error ,NSNumber *currentPage ,NSNumber *pages))completion;

/**
 @brief  跳到上一页
 @param  completion 执行结果回调block
 */
- (void)gotoPrevPageWithCompletion:(void(^)(ECError* error ,NSNumber *currentPage ,NSNumber *pages))completion;

/**
 @brief  撤销
 @param  type 撤销类型
 @param  completion 执行结果回调block
 */
- (void)drawUndoWithType:(ECUndoType)type completion:(void(^)(ECError* error))completion;

/**
 @brief  恢复
 @param  completion 执行结果回调block
 */
- (void)drawRedoWithCompletion:(void(^)(ECError* error))completion;

/**
 @brief  设置线的形状
 @param  lineShape 形状
 @return 0:成功 非0失败
 */
- (NSInteger)setLineShape:(ECLineShape)lineShape;

/**
 @brief  设置线的颜色
 @param  color 线颜色
 @return 0:成功 非0失败
 */
- (NSInteger)setLineColor:(UIColor *)color;

/**
 @brief  设置线的宽度
 @param  width 线宽[1 ~ 30]
 @return 0:成功 非0失败
 */
- (NSInteger)setlineWidth:(int)width;

/**
 @brief  获取橡皮擦 注:目前只可以在白板上使用
 @return 0:成功 非0失败
 */
- (NSInteger)getEraser;

/**
 @brief  获取画笔
 @return 0:成功 非0失败
 */
- (NSInteger)getPen;

@end
#endif
