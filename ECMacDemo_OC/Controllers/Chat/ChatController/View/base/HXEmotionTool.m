//
//  HWEmotionTool.m
//
//  Created by han on 16-10-23.
//


#import "HXEmotionTool.h"
#import <MJExtension/MJExtension.h>

@implementation HXEmotionTool

static NSMutableArray *_recentEmotions;

static NSArray  *_defaultEmotions, *_lxhEmotions;

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ECEmoji" ofType:@"plist"];
        _defaultEmotions = [self mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

@end
