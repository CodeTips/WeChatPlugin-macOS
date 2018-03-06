//
//  MMTimeLineMgr.h
//  WeChatPlugin
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMTimeLineMgrDelegate.h"

@class MMStatus;

@interface MMTimeLineMgr : NSObject

@property (nonatomic, weak) id<MMTimeLineMgrDelegate> delegate;

- (void)updateTimeLineHead;
- (void)updateTimeLineTail;

- (NSUInteger)getTimeLineStatusCount;
- (MMStatus *)getTimeLineStatusAtIndex:(NSUInteger)index;

@property (nonatomic, strong) NSMutableArray * jsonlist;


@end
