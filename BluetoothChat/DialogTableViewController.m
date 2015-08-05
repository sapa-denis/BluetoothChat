//
//  DialogTableViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "DialogTableViewController.h"
#import "Message.h"
#import "SessionManager.h"
#import "MessageMeTableViewCell.h"



@interface DialogTableViewController () <UITableViewDelegate, UITableViewDataSource, SessionManagerChatDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *messagesContainer;

@end


@implementation DialogTableViewController



- (instancetype)initWithSessionMagager:(SessionManager *)manager
						  andTableView:(UITableView *)tableView
{
	self = [super init];
	if (self) {
		_messagesContainer = [NSMutableArray arrayWithArray:@[]];
		_sessionManager = manager;
		_sessionManager.chatDelegate = self;
		
		_tableView = tableView;
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[_tableView reloadData];
	}
	return self;
}

- (instancetype)init
{
	return [self initWithSessionMagager:nil andTableView:nil];
}

- (void)scrollDialogDown
{
	NSUInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
	if (numberOfRows) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messagesContainer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Message *message = [self.messagesContainer objectAtIndex:indexPath.row];
	
	MessageMeTableViewCell *cell;
	if ([message.senderName isEqualToString:self.sessionManager.session.myPeerID.displayName]) {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageMeCell"];
	} else {
		cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCompanionCell"];
	}
	[cell setupWithMessage:message];
	
	return cell;
}

#pragma mark - SessionManagerChatDelegate

- (void)receivedMessage:(Message *)message
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self insertNewMessage:message];
	});
}

- (void)insertNewMessage:(Message *)message
{
	[self.messagesContainer addObject:message];
	
	[self.tableView beginUpdates];
	
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:([self.messagesContainer count] - 1) inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							  withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView endUpdates];
	
	[self scrollDialogDown];
}

@end
