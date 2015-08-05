//
//  MessageMeTableViewCell.m
//  BluetoothChat
//
//  Created by Denis Sapa on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "MessageMeTableViewCell.h"
#import "Message.h"

@interface MessageMeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;

@end

@implementation MessageMeTableViewCell

- (void)setupWithMessage:(Message *)message
{
	self.messageLabel.text = message.messageText;
	self.senderNameLabel.text = message.senderName;
}

@end
