//
//  NSString+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utility)

- (NSString *)MD5String;
- (NSString *)SHA1String;

- (NSString *)toBase62String;
- (NSString *)fromBase62String;
- (NSString *)increment;
- (NSString *)decrement;

- (NSString *)urlEncodingString;

- (BOOL)isValidMobile;
- (BOOL)isValidEmail;
- (BOOL)isValidPassword;
- (BOOL)isValidSMSCode;
- (BOOL)isValidHTTPURL;
- (BOOL)isSelfDomain;

- (BOOL)containsUnicodeCharacter;
- (BOOL)isNumberCharacter;
- (BOOL)isEmailCharacter;
- (BOOL)isNicknameCharacter;

- (CGFloat)widthWithFont:(UIFont *)font;
- (CGFloat)heightWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;

- (NSDate *)toDate;

@end
