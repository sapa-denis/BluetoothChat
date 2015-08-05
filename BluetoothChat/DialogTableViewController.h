//
//  DialogTableViewController.h
//  BluetoothChat
//
//  Created by Sapa Denys on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SessionManager;

@interface DialogTableViewController : NSObject

- (instancetype)initWithSessionMagager:(SessionManager *)manager andTableView:(UITableView *)tableView;
- (void)scrollDialogDown;
@end
