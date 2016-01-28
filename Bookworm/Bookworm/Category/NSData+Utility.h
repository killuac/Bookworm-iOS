//
//  NSData+Utility.h
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utility)

- (NSString *)toMD5String;
- (NSString *)toSHA1String;

@end
