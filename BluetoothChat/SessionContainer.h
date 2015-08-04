#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class Transcript;

@protocol SessionContainerDelegate;


@interface SessionContainer : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, weak) id<SessionContainerDelegate> delegate;


- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType;

- (Transcript *)sendMessage:(NSString *)message;

@end


@protocol SessionContainerDelegate <NSObject>

- (void)receivedTranscript:(Transcript *)transcript;
- (void)updateTranscript:(Transcript *)transcript;

@end
