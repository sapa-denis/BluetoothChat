//
//  MessageMeTableViewCell.h
//  BluetoothChat
//
//  Created by Denis Sapa on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface MessageMeTableViewCell : UITableViewCell

- (void)setupWithMessage:(Message *)message;

@end
