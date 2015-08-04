//
//  Message.m
//  BluetoothChat
//
//  Created by Denis Sapa on 04.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithText:(NSString *)messgeText
			   andSenderName:(NSString *)senderName
{
	self = [super init];
	if (self) {
		_messageText = messgeText;
		_senderName = senderName;
	}
	return self;
}

@end
