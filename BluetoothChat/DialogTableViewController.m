//
//  DialogTableViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "DialogTableViewController.h"

@implementation DialogTableViewController

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
	if ([tableView isEqual:self.chatTableView]) {
		Message *message = [self.messagesContainer objectAtIndex:indexPath.row];
		
		UITableViewCell *cell = [self.chatTableView dequeueReusableCellWithIdentifier:@"MessageCell"];
		
		cell.textLabel.text = message.messageText;
		if ([message.senderName isEqualToString:self.deviceName]) {
			cell.detailTextLabel.text = @"Me";
		} else {
			cell.detailTextLabel.text = message.senderName;
		}
		
		return cell;
	} else {
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
}

@end
