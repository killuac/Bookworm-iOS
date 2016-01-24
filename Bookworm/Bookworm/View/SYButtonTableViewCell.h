//
//  SYButtonTableViewCell.h
//  Bookworm
//
//  Created by Killua Liu on 1/22/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYButtonTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIButton *normalButton;

@property (nonatomic, strong, readonly) UIButton *topLinkButton;
@property (nonatomic, strong, readonly) UIButton *bottomLinkButton;
@property (nonatomic, strong, readonly) UIButton *leftLinkButton;
@property (nonatomic, strong, readonly) UIButton *rightLinkButton;

@end
