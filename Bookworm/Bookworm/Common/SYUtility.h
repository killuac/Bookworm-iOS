//
//  SYUtility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUtility : NSObject

NSString *SYDocumentFilePath(NSString *fileName);
NSString *SYApplicationSupportFilePath(NSString *fileName);
NSString *SYCacheFilePath(NSString *fileName);
NSString *SYTemporaryFilePath(NSString *fileName);
NSString *SYPlistFilePath(NSString *fileName);

NSArray *SYClassGetSubClasses(Class superClass);
void SYSwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector, BOOL isClassMethod);

@end
