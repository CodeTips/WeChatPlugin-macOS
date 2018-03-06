//
//  MMStatusImageMediaView.m
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusImageMediaView.h"

@implementation MMStatusImageMediaView

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageViews = @[self.imageView0, self.imageView1, self.imageView2, self.imageView3, self.imageView4, self.imageView5, self.imageView6, self.imageView7, self.imageView8];
    for (NSImageView *imageView in _imageViews) {
        imageView.imageAlignment = NSImageAlignTopLeft;
        imageView.wantsLayer = true;
        imageView.layer.borderColor = [NSColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
    }
}

@end
