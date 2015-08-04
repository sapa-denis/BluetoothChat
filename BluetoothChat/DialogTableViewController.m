//
//  DialogTableViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "DialogTableViewController.h"
#import "Message.h"

@implementation DialogTableViewController

#pragma mark - UITableViewDataSource

-(instancetype)init
{
	self = [super init];
	if (self) {
		_messagesContainer = [NSMutableArray arrayWithArray:@[]];
	}
	return self;
}

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
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
	
	cell.textLabel.text = message.messageText;
	if ([message.senderName isEqualToString:self.sessionManager.session.myPeerID.displayName]) {
		cell.detailTextLabel.text = @"Me";
	} else {
		cell.detailTextLabel.text = message.senderName;
	}
	
	return cell;

}

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
	
	NSUInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
	if (numberOfRows) {
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

@end
