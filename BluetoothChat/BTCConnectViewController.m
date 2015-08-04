//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "BTCConnectViewController.h"
#import "SessionContainer.h"
#import "Message.h"


static NSString *const kServiceType = @"sapa-textchat";



@interface BTCConnectViewController () <SessionContainerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, strong) SessionContainer *sessionContainer;
@property (nonatomic, strong) NSMutableArray *messagesContainer;

@end


@implementation BTCConnectViewController

- (void)viewDidLoad
{
	_messagesContainer = [NSMutableArray arrayWithArray:@[]];
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_deviceName = [[UIDevice currentDevice] name];
	
	self.sessionContainer = [[SessionContainer alloc] initWithDisplayName:_deviceName
															  serviceType:kServiceType];
	_sessionContainer.delegate = self;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.tableView]) {
		if (indexPath.row == 0) {
			CGFloat tableViewHeight = self.tableView.frame.size.height;
			CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
			CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
			return tableViewHeight - statusBarHeight - navigationBarHeight - 50;
		}
		
		if (indexPath.row == 1) {
			//		CGSize size = [self.messageTextField systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
			return 50;
		}
		
		return [super tableView:tableView heightForRowAtIndexPath:indexPath];
	} else {
		return 44;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([tableView isEqual:self.chatTableView]) {
		return self.messagesContainer.count;
	} else {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.chatTableView]) {
		Message *message = [self.messagesContainer objectAtIndex:indexPath.row];
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
		
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

- (IBAction)swipeOnMessegeFieldCell:(UIPanGestureRecognizer *)sender
{
	CGFloat offsetByY = [sender velocityInView:self.tableView].y;
	if (offsetByY > 0) {
		[self.messageTextField resignFirstResponder];
	} else if (offsetByY < 0) {
		[self.messageTextField becomeFirstResponder];
	}
}

#pragma mark - SessionContainerDelegate

- (void)receivedMessage:(Message *)message
{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self insertNewMessage:message];
	});
}

#pragma mark - IBAction

- (IBAction)sendButtonTouchUp:(id)sender
{
	[self.messageTextField resignFirstResponder];
	
	NSString *message = self.messageTextField.text;
	self.messageTextField.text = @"";
	if (![message isEqualToString:@""]) {
		Message *newMessage =[self.sessionContainer sendMessage:message];
		[self insertNewMessage:newMessage];
	}
}

#pragma mark - private methods

- (void)insertNewMessage:(Message *)message
{
	[self.messagesContainer addObject:message];
	
	[self.chatTableView beginUpdates];
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:([self.messagesContainer count] - 1) inSection:0];
	[self.chatTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							  withRowAnimation:UITableViewRowAnimationFade];
	
	[self.chatTableView endUpdates];
	
	NSUInteger numberOfRows = [self.chatTableView numberOfRowsInSection:0];
	if (numberOfRows) {
		[self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

@end
