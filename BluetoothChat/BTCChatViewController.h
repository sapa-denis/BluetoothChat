//
//  BTCChatViewController.h
//  BluetoothChat
//
//  Created by Sapa Denys on 02.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCSession;

@interface BTCChatViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *nearestPeers;
@property (nonatomic, strong) MCSession *currentSession;

@end
