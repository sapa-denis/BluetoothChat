@import MultipeerConnectivity;

#import "SessionContainer.h"

@interface SessionContainer() <MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@end

@implementation SessionContainer


- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType
{
    if (self = [super init]) {
        MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:displayName];

        _session = [[MCSession alloc] initWithPeer:peerID securityIdentity:nil encryptionPreference:MCEncryptionRequired];
        _session.delegate = self;

        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:peerID discoveryInfo:nil serviceType:serviceType];
        _advertiser.delegate = self;
		
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:peerID serviceType:serviceType];
        _browser.delegate = self;

        [_advertiser startAdvertisingPeer];
        [_browser startBrowsingForPeers];
    }
    return self;
}

// On dealloc we should clean up the session by disconnecting from it.
- (void)dealloc
{
    [_browser stopBrowsingForPeers];
    [_advertiser stopAdvertisingPeer];
    [_session disconnect];
}

// Helper method for human readable printing of MCSessionState.  This state is per peer.
- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";

        case MCSessionStateConnecting:
            return @"Connecting";

        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

#pragma mark - Public methods

//- (void)openSearchBrouserFromViewController:(UIViewController *)parentController
//{
//	MCBrowserViewController *browserViewController =
//	[[MCBrowserViewController alloc] initWithBrowser:_browser
//											 session:self.session];
//	
//	
//	browserViewController.delegate = self;
//	
//	[parentController presentViewController:browserViewController
//								   animated:YES
//								 completion:^{
//									 [_advertiser startAdvertisingPeer];
//									 [_browser startBrowsingForPeers];
//								 }];
//}

// Instance method for sending a string bassed text message to all remote peers
- (Transcript *)sendMessage:(NSString *)message
{
//    // Convert the string into a UTF8 encoded data
//    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
//    // Send text message to all connected peers
//    NSError *error;
//    [self.session sendData:messageData toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
//    // Check the error return to know if there was an issue sending data to peers.  Note any peers in the 'toPeers' array argument are not connected this will fail.
//    if (error) {
//        NSLog(@"Error sending message to peers [%@]", error);
//        return nil;
//    }
//    else {
//        // Create a new send transcript
//        return [[Transcript alloc] initWithPeerID:_session.myPeerID message:message direction:TRANSCRIPT_DIRECTION_SEND];
//    }
		return nil;
}

#pragma mark - MCSessionDelegate methods

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
//    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
//
//    NSString *adminMessage = [NSString stringWithFormat:@"'%@' is %@", peerID.displayName, [self stringForPeerConnectionState:state]];
//    // Create an local transcript
//    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:adminMessage direction:TRANSCRIPT_DIRECTION_LOCAL];
//
//    // Notify the delegate that we have received a new chunk of data from a peer
//    [self.delegate receivedTranscript:transcript];
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
//    // Decode the incoming data to a UTF8 encoded string
//    NSString *receivedMessage = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
//    // Create an received transcript
//    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID message:receivedMessage direction:TRANSCRIPT_DIRECTION_RECEIVE];
//    
//    // Notify the delegate that we have received a new chunk of data from a peer
//    [self.delegate receivedTranscript:transcript];
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
//    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
//    // Create a resource progress transcript
//    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageName:resourceName progress:progress direction:TRANSCRIPT_DIRECTION_RECEIVE];
//    // Notify the UI delegate
//    [self.delegate receivedTranscript:transcript];
}

// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
//    // If error is not nil something went wrong
//    if (error)
//    {
//        NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
//    }
//    else
//    {
//        // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant locatation immediately.
//        // Write to documents directory
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], resourceName];
//        if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path] toPath:copyPath error:nil])
//        {
//            NSLog(@"Error copying resource to documents directory");
//        }
//        else {
//            // Get a URL for the path we just copied the resource to
//            NSURL *imageUrl = [NSURL fileURLWithPath:copyPath];
//            // Create an image transcript for this received image resource
//            Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID imageUrl:imageUrl direction:TRANSCRIPT_DIRECTION_RECEIVE];
//            [self.delegate updateTranscript:transcript];
//        }
//    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
}

#pragma mark - MCNearbyServiceBrowserDelegate methods

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
//    NSLog(@"foundPeer: %@", peerID.displayName);
//    if (([_session.myPeerID.displayName compare:peerID.displayName] == NSOrderedDescending)) {
//        NSLog(@"invitePeer: %@", peerID.displayName);
//        [browser invitePeer:peerID toSession:_session withContext:nil timeout:30.0];
//    }
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer: %@", peerID.displayName);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingPeer: %@", error);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"didReceiveInvitationFromPeer: %@", peerID.displayName);
    invitationHandler(YES, _session);
}

@end
