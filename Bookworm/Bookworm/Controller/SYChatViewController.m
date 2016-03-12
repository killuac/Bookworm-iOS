//
//  SYChatViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYChatViewController.h"
#import "SYBubbleTableViewCell.h"

NSString *const SYChatViewControllerDidDeleteLastMessage = @"SYChatViewControllerDidDeleteLastMessage";

@interface SYChatViewController ()

@property (nonatomic, strong) NSMutableArray<SYMessageModel*> *messages;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYChatViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        _messages = [NSMutableArray array];
        [self addObservers];
    }
    return self;
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSendMessage:)
                                                 name:SYSocketDidSendMessageNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveReceipt:)
                                                 name:SYSocketDidReceiveReceiptNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessage:)
                                                 name:SYSocketDidReceiveMessageNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateNavigationBar];
    [self addSubviews];
    [self loadData];
    [self readAllMessages];
}

- (void)updateNavigationBar
{
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_more" target:self action:@selector(moreActionInChatViewController:)];
}

- (void)addSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER_COMMON];
    self.view = self.tableView;
}

- (void)loadData
{
//    [self.messageService findByParameters:@[self.contact.contactID, [NSDate date]] result:^(NSArray *result) {
//        [self.messages addObjectsFromArray:result];
//    }];
}

- (void)refreshUI
{
    
}

- (void)loadEarlierData
{
    
}

#pragma mark - Message handling
- (void)didSendMessage:(NSNotification *)notification
{
    NSUInteger index = [self.messages indexOfObject:notification.object];
    [self showSendingMarkAtRow:index];
}

// Show sending mark if the message hasn't been sent after 1 second
- (void)showSendingMarkAtRow:(NSInteger)row
{
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell performSelector:@selector(showSendingActivityIndicator) withObject:nil afterDelay:1.0];
}

- (void)didReceiveReceipt:(NSNotification *)notification
{
    SYMessageModel *receiptModel = notification.object;
    NSUInteger index = [self.messages indexOfObjectPassingTest:^BOOL(SYMessageModel *msgModel, NSUInteger idx, BOOL *stop) {
        return ([msgModel.sender isEqualToString:receiptModel.sender] && msgModel.messageID == receiptModel.messageID);
    }];
    
    if (index != NSNotFound) {
        id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [[cell class] cancelPreviousPerformRequestsWithTarget:cell];
        [cell dismissSendingActivityIndicator];
    }
}

- (void)didReceiveMessage:(NSNotification *)notification
{
    NSArray *messageModels = notification.object;
    NSIndexSet *indexSet = [messageModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *messageModel, NSUInteger idx, BOOL *stop) {
        return [messageModel.sender isEqualToString:self.contact.contactID];
    }];
    [self.messages addObjectsFromArray:[messageModels objectsAtIndexes:indexSet]];
    
    [self readAllMessages];
    [self refreshUI];
}

- (void)readAllMessages
{
    if (self.contact.unreadMessageCount) {
        self.contact.unreadMessageCount = 0;
        [self.messageService updateInboxWithSenderID:self.contact.contactID];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_COMMON forIndexPath:indexPath];
}

#pragma mark - Event handling
- (void)moreActionInChatViewController:(UIBarButtonItem *)barButtonItem
{
    
}

@end
