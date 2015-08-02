//
//  BTCChatViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 02.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "BTCChatViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface BTCChatViewController () <MCSessionDelegate>

@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;

@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;

@end

@implementation BTCChatViewController

- (void)viewDidAppear:(BOOL)animated
{
	self.currentSession.delegate = self;
}

- (IBAction)buttonSendTouchUp:(id) sender
{
	NSString *message = self.messageField.text;
	NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	if (![self.currentSession sendData:data
							   toPeers:self.currentSession.connectedPeers
							  withMode:MCSessionSendDataReliable
								 error:&error]) {
		NSLog(@"[Error] %@", error);
	}
}

- (IBAction)buttonDisconnectTouchUp:(id) sender
{
	[self closeConnection];
}

- (void)closeConnection
{
	[self.currentSession disconnect];
	self.nearestPeers = nil;
	self.currentSession = nil;
	[self.disconnectButton setHidden:YES];
	
	[self dismissViewControllerAnimated:YES
							 completion:^{
		
	}];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	switch (state) {
		case MCSessionStateConnected:
			NSLog(@"connected");
			break;
		case MCSessionStateNotConnected:
			NSLog(@"disconnected");
			[self closeConnection];
			break;
		default:
			break;
	}
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
	NSString *message =
	[[NSString alloc] initWithData:data
						  encoding:NSUTF8StringEncoding];
	NSLog(@"%@", message);
	self.chatTextView.text = [NSString stringWithFormat:@"%@\n%@", self.chatTextView.text, message];
}

//- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
//{}

//- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
//{}

//- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
//{}

@end
