//
//  SYMessageViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMessageViewController.h"
#import "SYMessageTableViewCell.h"
#import "SYChatViewController.h"

@interface SYMessageViewController ()

@property (nonatomic, strong) NSMutableArray<SYContactModel*> *contacts;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYMessageViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.contacts = [NSMutableArray array];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReadMessage:)
                                                     name:SYSocketDidReadMessageNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDeleteLastMessage:)
                                                     name:SYChatViewControllerDidDeleteLastMessage
                                                   object:nil];
        
        self.KVOController = [FBKVOController controllerWithObserver:self];
        [self.KVOController observe:self.messageService keyPath:@"totalUnreadMessageCount" options:0 block:^(id observer, id object, NSDictionary *change) {
            NSUInteger badge = self.messageService.totalUnreadMessageCount;
            self.tabBarItem.badgeValue = (badge > 0 ? @(badge).stringValue : nil);
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
        }];
    }
    return self;
}

- (SYMessageService *)messageService
{
    return [SYSocketManager manager].messageService;
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
}

- (void)addSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SYMessageTableViewCell class] forCellReuseIdentifier:IDENTIFIER_COMMON_CELL];
    self.view = self.tableView;
}

- (void)updateNavigationBar
{
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImageName:@"button_contact_list" target:self action:@selector(showContactViewControllerFromMessageViewController:)];
    
//    self.KVOController = [FBKVOController controllerWithObserver:self];
//    [self.KVOController observe:[SYSocketManager manager] keyPath:@"readyState" options:0 block:^(id observer, id object, NSDictionary *change) {
//        if ([SYSocketManager manager].isConnecting) {
//            UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
//            UILabel *titleLabel = [UILabel labelWithText:HUD_CONNECTING_IM_SERVER attributes:self.navigationBar.titleTextAttributes];
//            [titleView addSubview:titleLabel];
//            
//            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//            activityIndicator.color = titleLabel.textColor;
//            [activityIndicator startAnimating];
//            [titleView addSubview:activityIndicator];
//            
//            titleLabel.center = titleView.center;
//            titleLabel.centerX += (activityIndicator.width + SMALL_MARGIN) / 2;
//            activityIndicator.center = titleLabel.center;
//            activityIndicator.right = titleLabel.left - SMALL_MARGIN;
//            self.navigationItem.titleView = titleView;
//        } else {
//            self.navigationItem.titleView = nil;
//            self.navigationItem.title = TAB_TITLE_MESSAGE;
//        }
//    }];
}

- (void)loadData
{
    [self loadData:nil];
}

- (void)loadData:(SYNoParameterBlockType)completion
{
    SYContactModel *model = [SYContactModel model];
    model.lastMessage = [SYMessageModel model];
    model.lastMessage.content = @"最后一条消息";
    model.lastMessage.isSending = YES;
    model.nickname = @"云中行走";
    model.lastMessage.timestamp = [[NSDate date] timeIntervalSince1970];
    model.unreadMessageCount = 10;
    [self.contacts addObject:model];
    
    [self.contactService findByKey:self.userID result:^(NSArray<SYContactModel*> *result) {
        [self.contacts addObjectsFromArray:result];
        [self refreshUI];
        if (completion) completion();
    }];
}

- (void)refreshUI
{
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    [self.tableView reloadData];
}

#pragma mark - Message handling
- (SYContactModel *)contactWithUserId:(NSString *)userId
{
    NSUInteger index = [self.contacts indexOfObjectPassingTest:^BOOL(SYContactModel *contactModel, NSUInteger idx, BOOL *stop) {
        return [contactModel.contactID isEqualToString:userId];
    }];
    return (index != NSNotFound) ? self.contacts[index] : nil;
}

- (void)didSendMessage:(NSNotification *)notification
{
    SYMessageModel *messageModel = notification.object;
    SYContactModel *receiver = [self contactWithUserId:messageModel.receiver];
    NSUInteger index = 0;
    
    if (receiver) {
        receiver.lastMessage = messageModel;
        index = [self.contacts indexOfObject:receiver];
        [self showSendingMarkAtRow:index];
        [self refreshUI];
    } else {
        [self loadData:^{
            [self showSendingMarkAtRow:index];
        }];
    }
}

// Show sending mark if the message hasn't been sent after 1 second
- (void)showSendingMarkAtRow:(NSUInteger)row
{
    id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell performSelector:@selector(showSendingMark) withObject:nil afterDelay:1.0];
}

- (void)didReceiveReceipt:(NSNotification *)notification
{
    SYMessageModel *messageModel = notification.object;
    SYContactModel *receiver = [self contactWithUserId:messageModel.receiver];
    if (receiver) {
        NSUInteger index = [self.contacts indexOfObject:receiver];
        id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [[cell class] cancelPreviousPerformRequestsWithTarget:cell];
        [cell hideSendingMark];
    }
}

/**
 *  Play received sound and assign message to each contact
 */
- (void)didReceiveMessage:(NSNotification *)notification
{
    // If have anyone unread inbox message, play received sound.
    NSArray *messageModels = notification.object;
    NSIndexSet *indexSet = [messageModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *msgModel, NSUInteger idx, BOOL *stop) {
        return (msgModel.isInboxMessage && !msgModel.isRead);
    }];
    if (indexSet.count) {
        if ([self.visibleViewController isKindOfClass:[SYChatViewController class]]) {
            [SYSoundPlayer playMessageReceivedSound];
        } else {
            [SYSoundPlayer playMessageReceivedAlert];
        }
    }
    
    // Assign the last message(inbox/outbox) to each contact
    // Assign unread inbox message count to each contact
    [self.contacts enumerateObjectsUsingBlock:^(SYContactModel *contact, NSUInteger idx, BOOL *stop) {
        NSIndexSet *indexSet = [messageModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *msgModel, NSUInteger idx, BOOL *stop) {
            return ([msgModel.sender isEqualToString:contact.contactID] || [msgModel.receiver isEqualToString:contact.contactID]);
        }];
        NSArray *subMsgModels = [messageModels objectsAtIndexes:indexSet];
        contact.lastMessage = subMsgModels.lastObject;
        
        indexSet = [subMsgModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *msgModel, NSUInteger idx, BOOL *stop) {
            return (msgModel.isInboxMessage && !msgModel.isRead);
        }];
        contact.unreadMessageCount += indexSet.count;
    }];
    
    [self refreshUI];
}

- (void)didReadMessage:(NSNotification *)notification
{
    SYMessageModel *msgModel = notification.object;
    SYContactModel *sender = [self contactWithUserId:msgModel.sender];
    if (sender && sender.unreadMessageCount) {
        sender.unreadMessageCount = 0;
        [self refreshUI];
    }
}

- (void)didDeleteLastMessage:(NSNotification *)notification
{
    SYMessageModel *msgModel = notification.object;
    NSString *contactID = msgModel.isInboxMessage ? msgModel.sender : msgModel.receiver;
    SYContactModel *contactModel = [self contactWithUserId:contactID];
    
    [self.messageService findLastOneWithContactID:contactID result:^(SYMessageModel *lastMsgModel) {
        if (lastMsgModel) {
            contactModel.lastMessage = lastMsgModel;
        } else {
            [self.contacts removeObject:contactModel];
        }
        [self refreshUI];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYContactModel *contact = self.contacts[indexPath.row];
    SYMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER_COMMON_CELL forIndexPath:indexPath];
    cell.titleLabel.text = contact.nickname;
    cell.subtitleLabel.text = contact.lastMessage.content;
    cell.genderIconView.image = IMG_GENDER_ICON(contact.gender);
    [cell.avatarImageView sy_setImageWithURL:contact.avatarURL];
    
    if ([[NSDate date] timeIntervalSinceDate:contact.lastMessage.dateTime] > 2 * 24 * 3600) {
        cell.timeLabel.text = [contact.lastMessage.dateTime toShortDateString];
    } else {
        cell.timeLabel.text = [contact.lastMessage.dateTime toShortTimeString];
    }
    
    if (contact.unreadMessageCount > 0) {
        cell.badgeLabel.hidden = NO;
        cell.badgeLabel.text = @(contact.unreadMessageCount).stringValue;
    } else {
        cell.badgeLabel.hidden = YES;
    }
    
    if (contact.lastMessage.isSending) {
        [cell showSendingMark];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SYMessageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.badgeLabel.hidden = YES;
    
    [self showChatViewControllerFromMessageViewController];
    
    SYContactModel *contact = self.contacts[indexPath.row];
    if (contact.unreadMessageCount) {
        [self.messageService updateIsReadStatusWithSenderID:contact.contactID];
    }
}

- (void)showChatViewControllerFromMessageViewController
{
    SYChatViewController *chatVC = [[SYChatViewController alloc] init];
    chatVC.contact = self.contacts[self.selectedIndexPath.row];
    self.hidesBottomBarWhenPushed = YES;
    [self showViewController:chatVC sender:self];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYContactModel *contact = self.contacts[indexPath.row];
    NSString *title = contact.isFollowed ? BUTTON_TITLE_UNFOLLOW : BUTTON_TITLE_FOLLOW;
    
    UITableViewRowAction *follow =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title
                                     handler:^(UITableViewRowAction * action, NSIndexPath * indexPath) {
                                         [self followOrUnfollowInMessageViewControllerAtIndexPath:indexPath];
                                     }];
    
    UITableViewRowAction *delete =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:BUTTON_TITLE_DELETE
                                     handler:^(UITableViewRowAction * action, NSIndexPath * indexPath) {
                                         [self deleteContactMessagesAtIndexPath:indexPath];
                                     }];
    
    return @[delete, follow];
}

- (void)deleteContactMessagesAtIndexPath:(NSIndexPath *)indexPath
{
    SYContactModel *contact = self.contacts[indexPath.row];
    [self.contacts removeObjectAtIndex:indexPath.row];
    [self.contactService deleteByKey:contact.contactID result:nil];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)followOrUnfollowInMessageViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    SYContactModel *contact = self.contacts[indexPath.row];
    contact.isFollowed ? contact.relationship-- : contact.relationship++;
    [self.contactService updateWithModel:contact result:^(id result) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)markReadOrUnreadMessageAtIndexPath:(NSIndexPath *)indexPath
{
    SYContactModel *contact = self.contacts[indexPath.row];
    contact.lastMessage.isRead = !contact.lastMessage.isRead;
    contact.unreadMessageCount = (contact.lastMessage.isRead) ? 0 : 1;
    [self.messageService updateWithModel:contact.lastMessage result:^(id result) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - Event handling
- (void)showContactViewControllerFromMessageViewController:(UIBarButtonItem *)barButtonItem
{
    
}

@end
