#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class Message;

@protocol SessionContainerDelegate;


@interface SessionContainer : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, weak) id<SessionContainerDelegate> delegate;


- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType;

- (Message *)sendMessage:(NSString *)message;

@end


@protocol SessionContainerDelegate <NSObject>

- (void)receivedMessage:(Message *)transcript;
- (void)updateTranscript:(Message *)transcript;

@end
