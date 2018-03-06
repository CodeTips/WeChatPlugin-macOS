//
//  NSString+XMLDictionary.m
//  WeChatManagerClient
//
//  Created by nato on 2016/11/11.
//  Copyright © 2016年 nato. All rights reserved.
//

#import "NSString+XMLDictionary.h"
#import "XMLReader.h"

@implementation NSString (XMLDictionary)

- (NSDictionary *)xmlDictionary {
    return [XMLReader dictionaryForXMLString:self error:nil];
}

@end
