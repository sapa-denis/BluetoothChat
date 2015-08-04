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



@interface BTCConnectViewController () <UITableViewDelegate, UITableViewDataSource, SessionContainerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (nonatomic, strong) MCPeerID* localPeerID;
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.messageContainer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Message *message = [self.messageContainer objectAtIndex:indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];

	cell.textLabel.text = message.messageText;
	cell.detailTextLabel.text = message.senderName;
	
	return cell;
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
