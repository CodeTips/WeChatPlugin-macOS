//
//  MMStatus.h
//  WeChatTimeLine
//
//  Created by nato on 2017/1/22.
//  Copyright © 2017年 github:natoto. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MMStatusMediaObjectType) {
    MMStatusMediaObjectTypeNone,
    MMStatusMediaObjectTypeImage,
    MMStatusMediaObjectTypeLink,
};

@class MMStatusMediaObject;

@interface MMStatus : NSObject

@property (nonatomic, assign) NSUInteger statusId;
@property (nonatomic, strong) NSString *profileImageURLString;
@property (nonatomic, strong) NSImage *profileImage;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *sourceString; 
@property (nonatomic, strong) NSAttributedString *contentAttributedString;
@property (nonatomic, assign) MMStatusMediaObjectType mediaType;
@property (nonatomic, strong) MMStatusMediaObject *mediaObject;

- (void)updateWithSnsObject:(SnsObject *)snsObject;

-(void)valiateData;

- (BOOL)hasSource;
- (BOOL)hasContent;
- (BOOL)hasMediaObject;

@end



@interface MMStatusSimple : NSObject

@property (nonatomic, assign) NSUInteger statusId;
@property (nonatomic, strong) NSString *profileImageURLString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *sourceString;
@property (nonatomic, strong) NSString * contentstring; 
@property (nonatomic, assign) MMStatusMediaObjectType mediaType;
@property (nonatomic, strong) MMStatusMediaObject *mediaObject;

- (void)updateWithSnsObject:(SnsObject *)snsObject;

 
@end
