//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

#import "ChatViewController.h"
#import "SessionManager.h"
#import "Message.h"
#import "DialogTableViewController.h"


static NSString *const kServiceType = @"sapa-textchat";



@interface ChatViewController () <SessionManagerStateDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *messagesContainer;

@property (nonatomic, strong) DialogTableViewController *dialog;

@end


@implementation ChatViewController

- (void)viewDidLoad
{
	_messagesContainer = [NSMutableArray arrayWithArray:@[]];
	[super viewDidLoad];
	[_sendButton setEnabled:NO];
	
	_deviceName = [[UIDevice currentDevice] name];
	_sessionManager = [[SessionManager alloc] initWithDisplayName:_deviceName
														  serviceType:kServiceType];
	_sessionManager.stateDelegate = self;
	
	_dialog = [[DialogTableViewController alloc] initWithSessionMagager:self.sessionManager
														   andTableView:self.chatTableView];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		CGFloat tableViewHeight = self.tableView.frame.size.height;
		CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
		CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
		return tableViewHeight - statusBarHeight - navigationBarHeight - 50;
	}
	
	if (indexPath.row == 1) {
		return 50;
	}
	
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - SessionContainerDelegate


- (void)foundCompanion
{
	[self.sendButton setEnabled:YES];
}

- (void)lostAllCompanion
{
	[self.sendButton setEnabled:NO];
}

#pragma mark - IBAction

- (IBAction)sendButtonTouchUp:(id)sender
{
	[self.messageTextField resignFirstResponder];
	
	NSString *message = self.messageTextField.text;
	self.messageTextField.text = @"";
	if (![message isEqualToString:@""]) {
		[self.sessionManager sendMessage:message];
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

@end
