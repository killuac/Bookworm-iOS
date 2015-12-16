//
//  SYUtility.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYUtility : NSObject

NSString *CacheFilePath(NSString *fileName);
NSString *DocumentFilePath(NSString *fileName);
NSString *TemporaryFilePath(NSString *fileName);
NSString *PlistFilePath(NSString *fileName);
NSString *PlistFilePathInLanguageBundle(NSString *fileName);

NSArray *ClassGetSubClasses(Class superClass);
void SwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@end
