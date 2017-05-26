//
//  ECWBSSRoom.h
//  CCPiPhoneSDK
//
//  Created by wmz on 2017/4/18.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ECBoardDocument;

@interface ECBoardRoom : NSObject

//会议ID
@property (nonatomic , copy) NSString *confId;

//当前文档ID
@property (nonatomic , copy) NSString *curDocid;

//当前文档页数
@property (nonatomic , copy) NSString *curPage;

//房间的所有文档
@property (nonatomic , copy) NSArray<ECBoardDocument *> *allDocs;

@end

@interface ECBoardDocument : NSObject

//文档名称
@property (nonatomic , copy) NSString *fileName;

//文档ID
@property (nonatomic , copy) NSString *documentId;

//文档总页数
@property (nonatomic , copy) NSString *pages;

@end
