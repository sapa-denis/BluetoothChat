#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class Message;

@protocol SessionManagerDelegate;


@interface SessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, weak) id<SessionManagerDelegate> delegate;


- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType;

- (Message *)sendMessage:(NSString *)message;

@end


@protocol SessionManagerDelegate <NSObject>

- (void)receivedMessage:(Message *)message;
- (void)foundCompanion;

@end
