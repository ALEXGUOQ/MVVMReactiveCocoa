//
//  MRCUtil.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCUtil : NSObject

@end

@interface NSString (Util)

// Judging the string is not nil or empty.
//
// Returns YES or NO.
- (BOOL)isExist;

- (NSString *)firstLetter;

- (BOOL)isMarkdown;

- (NSString *)escapeSingleQuote;

@end

@interface UIColor (Util)

// Generating a new image by the color.
//
// Returns a new image.
- (UIImage *)color2Image;

@end

@interface NSNull (MRCUtil)

- (NSNull *)escapeSingleQuote;

@end
