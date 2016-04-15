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
    if (path.pathExtension.length) {
        lastPathComponent = path.lastPathComponent;
        path = [path stringByDeletingLastPathComponent];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    return (lastPathComponent.length ? [path stringByAppendingPathComponent:lastPathComponent] : path);
}

NSString *SYDocumentFilePath(NSString *fileName)
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *SYApplicationSupportFilePath(NSString *fileName)
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *SYCacheFilePath(NSString *fileName)
{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *SYTemporaryFilePath(NSString *fileName)
{
    NSString *tmpDir = NSTemporaryDirectory();
    NSString *path = [tmpDir stringByAppendingPathComponent:fileName];
    return FetchOrCreateFilePath(path);
}

NSString *SYPlistFilePath(NSString *fileName)
{
    return [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
}

#pragma mark - Runtime helper method
NSArray* SYClassGetSubClasses(Class superClass)
{
    NSMutableArray *classArray = [NSMutableArray array];
    
//    int classCount = objc_getClassList(NULL, 0);
//    Class *classes = (__unsafe_unretained Class*) malloc(sizeof(Class) * classCount);
//    classCount = objc_getClassList(classes, classCount);
//    for (int i = 0; i < classCount; i++) {
//        Class class = classes[i];
//        do{
//            class = class_getSuperclass(class);
//        } while(class && class != superClass);
//
//        if (!class) continue;
//        
//        [classArray addObject:classes[i]];
//    }
//    free(classes);
    
    unsigned int classCount = 0;
    Class *classes = objc_copyClassList(&classCount);
    for (int i = 0; i < classCount; i++) {
        Class class = classes[i];
        do{
            class = class_getSuperclass(class);
        } while(class && class != superClass);

        if (class) {
            [classArray addObject:classes[i]];
        }
    }
    free(classes);
    
    return classArray;
}

void SYSwizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector, BOOL isClassMethod)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = isClassMethod ? class_getClassMethod(class, originalSelector) : class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = isClassMethod ? class_getClassMethod(class, swizzledSelector) : class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    Class cls = isClassMethod ? object_getClass(class) : class;
    BOOL isAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (isAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
