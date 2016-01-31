//
//  SYChatViewController.h
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYContactModel.h"

FOUNDATION_EXPORT NSString *const SYChatViewControllerDidDeleteLastMessage;

@interface SYChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SYContactModel *contact;

@end
