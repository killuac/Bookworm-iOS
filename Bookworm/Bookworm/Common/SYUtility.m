//
//  SYUtility.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import "SYUtility.h"

@implementation SYUtility

#pragma mark - File path helper method
NSString *FetchOrCreateFilePath(NSString *path)
{
    NSString *lastPathComponent = @"";
    if (path.pathExtension && ![path.pathExtension isEmpty]) {
        lastPathComponent = path.lastPathComponent;
        path = [path stringByDeletingLastPathComponent];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return [lastPathComponent isEmpty] ? path : [path stringByAppendingPathComponent:lastPathComponent];
}

NSString *DocumentFilePath(NSString *fileName)
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *CacheFilePath(NSString *fileName)
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *TemporaryFilePath(NSString *fileName)
{
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *path = [tmpDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *PlistFilePath(NSString *fileName)
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

#pragma mark - Runtime helper method
NSArray* ClassGetSubClasses(Class superClass)
{
    NSMutableArray *classArray = [NSMutableArray array];
    
    int classCount = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    classes = (__unsafe_unretained Class*) malloc(sizeof(Class) * classCount);
    classCount = objc_getClassList(classes, classCount);
    
    for (int i = 0; i < classCount; i++) {
        Class class = classes[i];
        do{
            class = class_getSuperclass(class);
        } while(class && class != superClass);
        
        if (!class) continue;
        
        [classArray addObject:classes[i]];
    }
    free(classes);
    
    return classArray;
}

void SwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL isAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (isAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
