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
@property (nonatomic) CGRect keyboardFrame;

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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath isMemberOfClass:[NSIndexPath class]]) {
		if (indexPath.row == 0) {
			CGFloat tableViewHeight = self.tableView.frame.size.height;
			CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
			CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
			return tableViewHeight - statusBarHeight - navigationBarHeight -_keyboardFrame.size.height - 50;
		}
		
		if (indexPath.row == 1) {
			return 50;
		}
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

- (void)keyboardWillShow:(NSNotification *)notification
{
	NSDictionary *userInfo = [notification userInfo];
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardFrame];
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
						  withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];

}

- (void)keyboardDidShow:(NSNotification *)notification
{
		[self.dialog scrollDialogDown];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	_keyboardFrame = CGRectMake(0, 0, 0, 0);
	
	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
						  withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];
}

@end
