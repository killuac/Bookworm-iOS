//
//  SYTabBarController.h
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYUserService.h"
#import "SYMessageService.h"
#import "SYContactService.h"

@interface SYTabBarController : UITabBarController <UITabBarControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) SYUserService *userService;
@property (nonatomic, strong, readonly) SYMessageService *messageService;
@property (nonatomic, strong, readonly) SYContactService *contactService;

@end
