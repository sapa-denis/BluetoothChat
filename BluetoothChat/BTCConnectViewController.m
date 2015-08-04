//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "BTCConnectViewController.h"
#import "BTCChatViewController.h"
#import "SessionContainer.h"
#import "Message.h"


static NSString *const kServiceType = @"sapa-textchat";



@interface BTCConnectViewController () <SessionContainerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, strong) SessionContainer *sessionContainer;
@property (nonatomic, strong) NSMutableArray *messageContainer;

@end


@implementation BTCConnectViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSString *deviceName = [[UIDevice currentDevice] name];
	
	self.sessionContainer = [[SessionContainer alloc] initWithDisplayName:deviceName
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
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([tableView isEqual:self.chatTableView]) {
		return self.messageContainer.count;
	} else {
		return [super tableView:tableView numberOfRowsInSection:section];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEqual:self.chatTableView]) {
		Message *message = [self.messageContainer objectAtIndex:indexPath.row];
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
		
		cell.textLabel.text = message.messageText;
		cell.detailTextLabel.text = message.senderName;
		
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

- (void)receivedTranscript:(Transcript *)transcript
{
	
}

- (void)updateTranscript:(Transcript *)transcript
{
	
}

- (IBAction)sendButtonTouchUp:(id)sender
{
	[self.messageTextField resignFirstResponder];
	
	NSString *message = self.messageTextField.text;
	self.messageTextField.text = @"";
	if (![message isEqualToString:@""]) {
		[self.sessionContainer sendMessage:message];
	}
}

@end
