//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "BTCConnectViewController.h"
#import "BTCChatViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString *const kServiceType = @"sapa-textchat";

@interface BTCConnectViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, strong) MCSession *currentSession;

@property (nonatomic, weak) IBOutlet UIButton *connect;
@property (nonatomic, strong) MCBrowserViewController *browserViewController;

@property (nonatomic, strong) MCPeerID* localPeerID;
@property (nonatomic, strong) NSMutableArray *nearestPeers;

@end

@implementation BTCConnectViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.connect setHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	_nearestPeers = [NSMutableArray new];
	
	_localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
	
	_currentSession = [[MCSession alloc] initWithPeer:self.localPeerID
									 securityIdentity:nil
								 encryptionPreference:MCEncryptionRequired];
	
	_currentSession.delegate = self;
	
	
	
	MCNearbyServiceAdvertiser *advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:kServiceType];
	advertiser.delegate = self;
	
	MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID
																	   serviceType:kServiceType];
	browser.delegate = self;
	
	[advertiser startAdvertisingPeer];
	[browser startBrowsingForPeers];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}



- (IBAction)buttonConnectTouchUp:(id) sender
{
	self.nearestPeers = [NSMutableArray new];
	MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID
																	   serviceType:kServiceType];
	browser.delegate = self;
	
//	MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:kServiceType session:self.currentSession];
//	[[MCBrowserViewController alloc] initWithBrowser:browser
//											 session:self.currentSession];
	[browser startBrowsingForPeers];
	
	/*
	browserViewController.delegate = self;
	[self presentViewController:browserViewController
					   animated:YES
					 completion:^{
						 
					 }];
	
	[self.connect setHidden:YES];
	 */
	
//	MCNearbyServiceAdvertiser *advertiser =
//	[[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
//									  discoveryInfo:nil
//										serviceType:kServiceType];
//	advertiser.delegate = self;
//	[advertiser startAdvertisingPeer];
}

#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
	[browserViewController.browser stopBrowsingForPeers];
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
	
	[self performSegueWithIdentifier:@"MessageSegue" sender:self];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
	[browserViewController.browser stopBrowsingForPeers];
	[self.connect setHidden:NO];
	
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
	switch (state) {
		case MCSessionStateConnected:
			NSLog(@"connected");
			break;
		case MCSessionStateNotConnected:
			NSLog(@"disconnected");
//			[self closeConnection];
			break;
		default:
			break;
	}
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
	[self.nearestPeers addObject:peerID];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
	[self.nearestPeers removeObject:peerID];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
	NSLog(@"didNotStartAdvertisingPeer: %@", error);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
	NSLog(@"didReceiveInvitationFromPeer: %@", peerID.displayName);
	invitationHandler(YES, self.currentSession);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
	if ([segue.identifier isEqualToString:@"MessageSegue"]) {
		BTCChatViewController *destination = [segue destinationViewController];
		destination.nearestPeers = self.nearestPeers;
		destination.currentSession = self.currentSession;
	}
}

@end
