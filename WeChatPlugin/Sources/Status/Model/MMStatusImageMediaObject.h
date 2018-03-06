//
//  MMStatusImageMediaObject.h
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusMediaObject.h"

@interface MMStatusImageInfo : NSObject

@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

@end

@interface MMStatusImageMediaObject : MMStatusMediaObject

@property (nonatomic, strong) NSArray *imageInfos;

@end
