#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class Message;

@protocol SessionManagerStateDelegate;
@protocol SessionManagerChatDelegate;



@interface SessionManager : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, weak) id<SessionManagerChatDelegate> chatDelegate;
@property (nonatomic, weak) id<SessionManagerStateDelegate> stateDelegate;


- (id)initWithDisplayName:(NSString *)displayName serviceType:(NSString *)serviceType;

- (Message *)sendMessage:(NSString *)message;

@end


@protocol SessionManagerStateDelegate <NSObject>

- (void)foundCompanion;
- (void)lostAllCompanion;

@end

@protocol SessionManagerChatDelegate <NSObject>

- (void)receivedMessage:(Message *)message;

@end
