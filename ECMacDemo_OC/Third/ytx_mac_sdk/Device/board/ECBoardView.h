//
//  wbssView.h
//  Hello_Triangle
//
//  Created by Sean Lee on 16/6/23.
//  Copyright © 2016年 Daniel Ginsburg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>

/**
 * 白板显示类
 */
@interface ECBoardView : UIView

/**
 @brief 白板是否可编辑
 */
@property (nonatomic, assign) BOOL isEdit;

@end
