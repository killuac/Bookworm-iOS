//
//  SYSocialShare.h
//  Bookworm
//
//  Created by Killua Liu on 3/10/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYSocialShareModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *normalImageName;
@property (nonatomic, copy) NSString *disabledImageName;

@end


@interface SYSocialShare : NSObject

@end
