//
//  SYChatViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYChatViewController.h"
#import "SYMessageService.h"

NSString *const SYChatViewControllerDidDeleteLastMessage = @"SYChatViewControllerDidDeleteLastMessage";

@interface SYChatViewController ()

@property (nonatomic, strong) SYMessageService *messageService;
@property (nonatomic, strong) NSMutableArray<SYMessageModel*> *messages;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYChatViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.messageService = [SYMessageService service];
        self.messages = [NSMutableArray array];
        
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
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubviews];
    [self loadData];
}

- (void)addSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:IDENTIFIER_COMMON_CELL];
    self.view = self.tableView;
}

- (void)loadData
{
    [self.messageService findByKey:self.contact.contactID result:^(id result) {
        
    }];
}

- (void)loadEarlierData
{
    
}

#pragma mark - Message handling
- (void)didSendMessage:(NSNotification *)notification
{
    NSUInteger index = [self.messages indexOfObject:notification.object];
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self performSelector:@selector(showSendingMarkInCell:) withObject:cell afterDelay:1.0];
}

// Show sending mark if the message hasn't been sent after 1 second
- (void)showSendingMarkInCell:(UITableViewCell *)cell
{
//    cell.sendingMark.hidden = NO;
    [cell setNeedsLayout];
}

- (void)didReceiveReceipt:(NSNotification *)notification
{
    [self.class cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMessage:(NSNotification *)notification
{
    NSArray *messageModels = notification.object;
    NSIndexSet *indexSet = [messageModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *messageModel, NSUInteger idx, BOOL *stop) {
        return [messageModel.sender isEqualToString:self.contact.contactID];
    }];
    [self.messages addObjectsFromArray:[messageModels objectsAtIndexes:indexSet]];
    
    self.contact.unreadMessageCount = 0;
    [[SYSocketManager manager] readMessagesFromReceiver:self.contact.contactID];
    
    [self refreshUI];
}

- (void)refreshUI
{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMON_CELL forIndexPath:indexPath];
}

@end
