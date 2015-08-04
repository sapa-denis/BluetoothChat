//
//  ViewController.m
//  BluetoothChat
//
//  Created by Sapa Denys on 01.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "BTCConnectViewController.h"
#import "BTCChatViewController.h"
#import "SessionContainer.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString *const kServiceType = @"sapa-textchat";



@interface BTCConnectViewController () <SessionContainerDelegate>

@property (nonatomic, strong) MCPeerID* localPeerID;
@property (retain, nonatomic) SessionContainer *sessionContainer;

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

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - SessionContainerDelegate

- (void)receivedTranscript:(Transcript *)transcript
{
	
}

- (void)updateTranscript:(Transcript *)transcript
{
	
}

@end
