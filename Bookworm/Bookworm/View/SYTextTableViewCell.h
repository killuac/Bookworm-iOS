//
//  SYTextTableViewCell.h
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTextView.h"

@interface SYTextTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *textField;
@property (nonatomic, strong, readonly) SYTextView *textView;

// Below methods only support UITextField
- (void)showSuccess;
- (void)showErrorWithText:(NSString *)text;
- (void)showWarningWithText:(NSString *)text;
- (void)dismissTip;

@end
