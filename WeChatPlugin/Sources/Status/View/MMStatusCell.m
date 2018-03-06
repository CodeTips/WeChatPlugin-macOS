//
//  MMStatusCell.m
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import "MMStatusCell.h"
#import "MMStatusMediaView.h"
#import "MMStatusImageMediaView.h"
#import "MMStatusLinkMediaView.h"
#import "MMStatus.h"
#import "MMStatusMediaObject.h"
#import "MMStatusImageMediaObject.h"
#import "MMStatusLinkMediaObject.h"

@implementation MMStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.wantsLayer = true;
    self.profileImageView.layer.borderWidth = 0.5;
    self.profileImageView.layer.borderColor = [NSColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.layer.masksToBounds = true;
}

- (void)updateMediaView:(MMStatusMediaView *)mediaView {
    [self.mediaRealView removeFromSuperview];
    self.mediaRealView = nil;
    self.mediaRealView = mediaView;
    [self addSubview:mediaView];
    self.mediaRealView.translatesAutoresizingMaskIntoConstraints = false;
    if (self.mediaRealView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.mediaRealView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.mediaView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
    }
}

- (void)updateViewWithStatus:(MMStatus *)status {
    _status = status;
    [_status valiateData];
    MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
    if (_status.profileImage)
    {
        self.profileImageView.image = _status.profileImage;
    }
    else
    {
        self.profileImageView.image = [service defaultAvatarImage];
        [service getAvatarImageWithUrl:status.profileImageURLString completion:^(NSImage *image) {
            _status.profileImage = image;
            self.profileImageView.image = image;
        }];
    }

    self.nameTextField.stringValue = status.nameString?status.nameString:@"";
    self.tagTextField.stringValue = [NSString stringWithFormat:@"%@%@", status.timeString, [status hasSource] ? [NSString stringWithFormat:@" - %@", status.sourceString] : @""];
    self.toContentTextFieldLayoutConstraint.active = [status hasContent];
    self.toTagTextFieldLayoutConstraint.active = ![status hasContent];
    self.contentTextField.attributedStringValue = status.contentAttributedString;
    
    if ([status hasMediaObject]) {
        switch (status.mediaType) {
            case MMStatusMediaObjectTypeImage: {
                MMStatusImageMediaObject *mediaObject = (MMStatusImageMediaObject *)status.mediaObject;
                MMStatusImageMediaView *mediaView = (MMStatusImageMediaView *)self.mediaRealView;
                for (NSImageView *imageView in mediaView.imageViews) {
                    imageView.hidden = true;
                }
                for (NSInteger i = 0; i < mediaObject.imageInfos.count; i ++) {
                    MMStatusImageInfo *imageInfo = mediaObject.imageInfos[i];
                    NSImageView *imageView = mediaView.imageViews[i];
                    imageView.hidden = false;
                    imageView.image = nil;
                    
                    if (imageInfo.image)
                    {
                        imageView.imageScaling = mediaObject.imageInfos.count > 1 ? NSImageScaleAxesIndependently : NSImageScaleProportionallyUpOrDown;
                        imageView.image = imageInfo.image;
                    }
                    else
                    {
                        MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
                        [service getAvatarImageWithUrl:imageInfo.imageURLString completion:^(NSImage *image) {
                            if (mediaObject.imageInfos.count > 1) {
                                imageInfo.image = [self scaleToFillImage:image size:imageView.frame.size];;
                                imageView.imageScaling = NSImageScaleAxesIndependently;
                            }
                            else
                            {
                                imageInfo.image = image;
                                imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
                            }
                            imageView.image = imageInfo.image;
                        }];
                    }
                }
            }
                break;
            case MMStatusMediaObjectTypeLink: {
                MMStatusLinkMediaObject *mediaObject = (MMStatusLinkMediaObject *)status.mediaObject;
                MMStatusLinkMediaView *mediaView = (MMStatusLinkMediaView *)self.mediaRealView;
                mediaView.iconImageView.image = nil;
                if (mediaObject.image)
                {
                    mediaView.iconImageView.image = mediaObject.image;
                }
                else
                {
                    MMAvatarService *service = [[CBGetClass(MMServiceCenter) defaultCenter] getService:CBGetClass(MMAvatarService)];
                    [service getAvatarImageWithUrl:mediaObject.imageURLString completion:^(NSImage *image) {
                        mediaObject.image = image;
                        mediaView.iconImageView.image = image;
                    }];
                }
                mediaView.titleTextField.stringValue = mediaObject.title;
            }
                break;
            default:
                break;
        }
    }
}

- (NSImage*)scaleToFillImage:(NSImage*)image size:(NSSize)size
{
    NSImage *scaleToFillImage = [NSImage imageWithSize:self.bounds.size
                                               flipped:NO
                                        drawingHandler:^BOOL(NSRect dstRect) {
                                            
                                            NSSize imageSize = [image size];
                                            NSSize imageViewSize = size; // Yes, do not use dstRect.
                                            
                                            NSSize newImageSize = imageSize;
                                            
                                            CGFloat imageAspectRatio = imageSize.height/imageSize.width;
                                            CGFloat imageViewAspectRatio = imageViewSize.height/imageViewSize.width;
                                            
                                            if (imageAspectRatio < imageViewAspectRatio) {
                                                // Image is more horizontal than the view. Image left and right borders need to be cropped.
                                                newImageSize.width = imageSize.height / imageViewAspectRatio;
                                            }
                                            else {
                                                // Image is more vertical than the view. Image top and bottom borders need to be cropped.
                                                newImageSize.height = imageSize.width * imageViewAspectRatio;
                                            }
                                            
                                            NSRect srcRect = NSMakeRect(imageSize.width/2.0-newImageSize.width/2.0,
                                                                        imageSize.height/2.0-newImageSize.height/2.0,
                                                                        newImageSize.width,
                                                                        newImageSize.height);
                                            
                                            [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
                                            
                                            [image drawInRect:dstRect // Interestingly, here needs to be dstRect and not self.bounds
                                                     fromRect:srcRect
                                                    operation:NSCompositingOperationCopy
                                                     fraction:1.0
                                               respectFlipped:YES
                                                        hints:@{NSImageHintInterpolation: @(NSImageInterpolationHigh)}];
                                            
                                            return YES;
                                        }];
    return scaleToFillImage;
}

#pragma mark - Event

- (void)mouseUp:(NSEvent *)event {
    CGPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
    
    if ([self.status hasMediaObject]) {
        switch (self.status.mediaType) {
            case MMStatusMediaObjectTypeLink: {
                BOOL isClickLinkView = [self mouse:point inRect:self.mediaRealView.frame];
                if (isClickLinkView) {
                    if ([self.delegate respondsToSelector:@selector(cell:didClickMediaLink:)]) {
                        [self.delegate cell:self didClickMediaLink:[(MMStatusLinkMediaObject *)self.status.mediaObject linkURLString]];
                    }
                }
                break;
            }
            case MMStatusMediaObjectTypeImage:{
                
                __block NSInteger selectindex = -1;
                [self.mediaRealView.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BOOL isClickLinkView = [self mouse:point inRect:obj.frame];
                    if (isClickLinkView) {
                        selectindex = idx;
                    }
                }];
//                BOOL isClickLinkView = [self mouse:point inRect:self.mediaRealView.frame];
                if (selectindex >= 0) {
                    MMStatusImageMediaObject * media = (MMStatusImageMediaObject *)self.status.mediaObject;
                    NSArray * images =  media.imageInfos;
                    if (images.count > selectindex && [self.delegate respondsToSelector:@selector(cell:didClickMediaImage:)]) {
                        [self.delegate cell:self didClickMediaImage:media.imageInfos[selectindex]];
                    }
                }

                break;
            }
            default:
                break;
        }
    }
}

- (void)mouseDown:(NSEvent *)event {
    
}

#pragma mark - Height

+ (CGFloat)calculateHeightForStatus:(MMStatus *)status inTableView:(NSTableView *)tableView {
    CGFloat height = 55;
    if ([status hasContent]) {
        height += 5;
        NSRect rect = [status.contentAttributedString boundingRectWithSize:NSMakeSize(tableView.frame.size.width - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        height += rect.size.height; 
    }
    if ([status hasMediaObject]) {
        switch (status.mediaType) {
            case MMStatusMediaObjectTypeImage: {
                CGFloat imageSize = (tableView.frame.size.width - 80) / 3.0;
                MMStatusImageMediaObject *mediaObject = (MMStatusImageMediaObject *)status.mediaObject;
                NSInteger rowCount = (mediaObject.imageInfos.count - 1) / 3 + 1;
                MMStatusImageInfo *imageInfo = mediaObject.imageInfos.firstObject;
                if (mediaObject.imageInfos.count == 1 && (imageInfo.imageWidth > imageInfo.imageHeight)) {
                    height += imageInfo.imageHeight / (imageInfo.imageWidth / imageSize);
                }
                else
                {
                    height += (NSInteger)(rowCount * imageSize);
                }
            }
                break;
            case MMStatusMediaObjectTypeLink:
                height += 40;
            default:
                break;
        }
    }
    height += 10;
    return height;
}

@end
