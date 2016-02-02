//
//  SYBubbleTableViewCell.m
//  Bookworm
//
//  Created by Killua Liu on 2/2/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYBubbleTableViewCell.h"

@implementation SYBubbleTableViewCell

- (void)showSendingActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.tag = 1000;
    [activityIndicator startAnimating];
    [self.contentView addSubview:activityIndicator];
}

- (void)dismissSendingActivityIndicator
{
    UIView *activityIndicator = [self.contentView viewWithTag:1000];
    [activityIndicator removeFromSuperview];
}

@end
