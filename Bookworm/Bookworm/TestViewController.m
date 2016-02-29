//
//  TestViewController.m
//  Bookworm
//
//  Created by Killua Liu on 12/16/15.
//  Copyright (c) 2015 Syzygy. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (nonatomic, strong) NSMutableArray *viewControllerClasses;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Test View Contollers";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_COMMON];
    
    _viewControllerClasses = [NSMutableArray array];
    [SYClassGetSubClasses([UIViewController class]) enumerateObjectsUsingBlock:^(Class class, NSUInteger idx, BOOL *stop) {
        NSString *className = NSStringFromClass(class);
        if ([className hasPrefix:@"SY"] && ![className isEqual:@"SYScrollViewController"]) {
            [_viewControllerClasses addObject:NSStringFromClass(class)];
        }
    }];
    
    [self.viewControllerClasses sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewControllerClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [UITableViewCell cellWithTableView:tableView forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_COMMON forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _viewControllerClasses[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = _viewControllerClasses[indexPath.row];
    UIViewController *VC = [[NSClassFromString(className) alloc] init];
    
    if ([className isEqualToString:@"SYSignInUpViewController"]) {
        [self testSignInViewController];
    }
    
    [self showViewController:VC sender:self];
}

#pragma mark - Test methods
- (void)testSignInViewController
{
    
}

@end
