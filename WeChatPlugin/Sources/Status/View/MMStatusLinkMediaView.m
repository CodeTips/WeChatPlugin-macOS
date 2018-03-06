//
//  MMStatusLinkMediaView.m
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusLinkMediaView.h"

@implementation MMStatusLinkMediaView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wantsLayer = true;
    self.layer.backgroundColor = [NSColor colorWithWhite:0.9 alpha:1.0].CGColor;
    self.iconImageView.wantsLayer = true;
    self.iconImageView.layer.backgroundColor = [NSColor colorWithWhite:0.9 alpha:1.0].CGColor;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
