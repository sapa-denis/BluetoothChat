//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString *const kServiceType = @"sapa-textchat";

@interface ViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCSession *currentSession;
@property (nonatomic, weak) IBOutlet UITextField *txtMessage;
@property (nonatomic, weak) IBOutlet UIButton *connect;
@property (nonatomic, weak) IBOutlet UIButton *disconnect;
@property (nonatomic, strong) MCBrowserViewController *browserViewController;

@property (nonatomic, strong) MCPeerID* localPeerID;
@property (nonatomic, strong) NSMutableArray *nearestPeers;

@end

@implementation ViewController

- (void)viewDidLoad
{
	_nearestPeers = [NSMutableArray new];
	_localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
	
	_currentSession = [[MCSession alloc] initWithPeer:self.localPeerID
									 securityIdentity:nil
								 encryptionPreference:MCEncryptionNone];
	self.currentSession.delegate = self;
	
	[super viewDidLoad];
	[self.connect setHidden:NO];
	[self.disconnect setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)buttonSendTouchUp:(id) sender
{
	NSString *message = @"Hello, World!";
	NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	if (![self.currentSession sendData:data
							   toPeers:self.nearestPeers
							  withMode:MCSessionSendDataReliable
								 error:&error]) {
		NSLog(@"[Error] %@", error);
	}
}

- (IBAction)buttonConnectTouchUp:(id) sender
{
	self.nearestPeers = [NSMutableArray new];
	MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID
																	   serviceType:kServiceType];
	browser.delegate = self;
	
	MCBrowserViewController *browserViewController =
	[[MCBrowserViewController alloc] initWithBrowser:browser
											 session:self.currentSession];
	browserViewController.delegate = self;
	[self presentViewController:browserViewController
					   animated:YES
					 completion:^{
						 [browser startBrowsingForPeers];
					 }];
	
	[self.connect setHidden:YES];
	[self.disconnect setHidden:NO];
}

- (IBAction)buttonDisconnectTouchUp:(id) sender
{
	[self.currentSession disconnect];
	self.nearestPeers = nil;
	self.currentSession = nil;
	[self.connect setHidden:NO];
	[self.disconnect setHidden:YES];
}

#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
	[self.connect setHidden:NO];
	[self.disconnect setHidden:YES];
	
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{}

//- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
//{}

//- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
//{}

//- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
//{}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	[self.nearestPeers addObject:peerID];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	[self.nearestPeers removeObject:peerID];
}

@end
