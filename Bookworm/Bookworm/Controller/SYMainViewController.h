//
//  SYMainViewController.h
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright © 2015 Syzygy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYScrollViewController.h"

@interface SYMainViewController : SYScrollViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end