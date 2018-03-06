//
//  MMStatusLinkMediaObject.h
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusMediaObject.h"

@interface MMStatusLinkMediaObject : MMStatusMediaObject

@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *linkURLString;

@end
