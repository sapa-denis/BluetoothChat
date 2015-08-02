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

@interface BTCConnectViewController () <MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate>

@property (nonatomic, strong) MCSession *currentSession;

@property (nonatomic, weak) IBOutlet UIButton *connect;
@property (nonatomic, strong) MCBrowserViewController *browserViewController;

@property (nonatomic, strong) MCPeerID* localPeerID;
@property (nonatomic, strong) NSMutableArray *nearestPeers;

@end

@implementation BTCConnectViewController

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
}



#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
	
	[self performSegueWithIdentifier:@"MessageSegue" sender:self];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
	[self.connect setHidden:NO];
	
	[browserViewController dismissViewControllerAnimated:YES
											  completion:^{
												  
											  }];
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
