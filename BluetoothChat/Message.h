//
//  Message.h
//  BluetoothChat
//
//  Created by Denis Sapa on 04.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

- (instancetype)initWithText:(NSString *)messgeText
			   andSenderName:(NSString *)senderName;

@property (nonatomic, copy) NSString *senderName;
@property (nonatomic, copy) NSString *messageText;

@end
