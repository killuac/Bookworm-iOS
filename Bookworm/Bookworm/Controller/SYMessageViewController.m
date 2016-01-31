//
//  SYMessageViewController.m
//  Bookworm
//
//  Created by Killua Liu on 1/29/16.
//  Copyright © 2016 Syzygy. All rights reserved.
//

#import "SYMessageViewController.h"
#import "SYMessageTableViewCell.h"
#import "SYContactService.h"
#import "SYChatViewController.h"

@interface SYMessageViewController ()

@property (nonatomic, strong) SYContactService *contactService;
@property (nonatomic, strong) SYMessageService *messageService;
@property (nonatomic, strong) NSMutableArray<SYContactModel*> *contacts;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SYMessageViewController

#pragma mark - Life cycle
- (instancetype)init
{
    if (self = [super init]) {
        self.contactService = [SYContactService service];
        self.messageService = [SYMessageService service];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubviews];
//    [self updateNavigationBar];
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
    self.KVOController = [FBKVOController controllerWithObserver:self];
    [self.KVOController observe:[SYSocketManager manager] keyPath:@"readyState" options:0 block:^(id observer, id object, NSDictionary *change) {
        if ([SYSocketManager manager].isConnecting) {
            UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
            UILabel *titleLabel = [UILabel labelWithText:HUD_CONNECTING_IM_SERVER attributes:self.navigationBar.titleTextAttributes];
            [titleView addSubview:titleLabel];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.color = titleLabel.textColor;
            [activityIndicator startAnimating];
            [titleView addSubview:activityIndicator];
            
            titleLabel.center = titleView.center;
            titleLabel.centerX += (activityIndicator.width + SMALL_MARGIN) / 2;
            activityIndicator.center = titleLabel.center;
            activityIndicator.right = titleLabel.left - SMALL_MARGIN;
            self.navigationItem.titleView = titleView;
        } else {
            self.navigationItem.titleView = nil;
            self.navigationItem.title = TAB_TITLE_MESSAGE;
        }
    }];
}

- (void)loadData
{
    [self.contactService findByKey:[GVUserDefaults standardUserDefaults].userID result:^(NSArray<SYContactModel*> *result) {
        [self.contacts addObjectsFromArray:result];
    }];
}

#pragma mark - Message handling
- (void)didSendMessage:(NSNotification *)notification
{
    SYMessageModel *messageModel = notification.object;
    NSUInteger index = [self.contacts indexOfObjectPassingTest:^BOOL(SYContactModel *contact, NSUInteger idx, BOOL * stop) {
        return [contact.contactID isEqualToString:messageModel.receiver];
    }];
    
    if (index != NSNotFound) {
        [self.contacts[index] setLastMessage:messageModel];
        id cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self performSelector:@selector(showSendingMarkInCell:) withObject:cell afterDelay:1.0];
        [self refreshUI];
    }
}

// Show sending mark if the message hasn't been sent after 1 second
- (void)showSendingMarkInCell:(SYMessageTableViewCell *)cell
{
    cell.sendingMark.hidden = NO;
    [cell setNeedsLayout];
}

- (void)didReceiveReceipt:(NSNotification *)notification
{
    [self.class cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMessage:(NSNotification *)notification
{
    NSArray *messageModels = notification.object;
    
    for (SYContactModel *contact in self.contacts) {
        NSIndexSet *indexSet = [messageModels indexesOfObjectsPassingTest:^BOOL(SYMessageModel *messageModel, NSUInteger idx, BOOL *stop) {
            return [messageModel.sender isEqualToString:contact.contactID];
        }];
        contact.lastMessage = [messageModels objectsAtIndexes:indexSet].lastObject;
        
        // If visible view controller is chat VC, unread message count is 0.
        if ([self.visibleViewController isKindOfClass:[SYChatViewController class]]) {
            contact.unreadMessageCount = 0;
        } else {
            contact.unreadMessageCount += indexSet.count;
        }
    }
    
    if (self.messageService.totalUnreadMessageCount) {
        // TODO: Play alert sound
    }
    
    [self refreshUI];
}

- (void)didDeleteLastMessage:(NSNotification *)notification
{
    SYContactModel *contactModel = notification.object;
    SYMessageModel *messageModel = [self.messageService findLastMessageWithContact:contactModel.contactID];
    
    NSUInteger index = [self.contacts indexOfObject:contactModel];
    [self.contacts[index] setLastMessage:messageModel];
}

- (void)refreshUI
{
    [self.contacts sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastMsgTime" ascending:NO]]];
    [self.tableView reloadData];
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
    
    [self showChatViewControllerFromContactList];
    
    SYContactModel *contact = self.contacts[indexPath.row];
    if (contact.unreadMessageCount) {
        [[SYSocketManager manager] readMessagesFromReceiver:contact.contactID];
    }
}

- (void)showChatViewControllerFromContactList
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
    [self.contactService deleteWithModel:contact];
    [[SYSocketManager manager] deleteMessagesFromReceiver:contact.contactID];
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

@end
