//
//  DialogTableViewController.h
//  BluetoothChat
//
//  Created by Sapa Denys on 05.08.15.
//  Copyright (c) 2015 Sapa Denys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@interface DialogTableViewController : NSObject <UITableViewDelegate, UITableViewDataSource, SessionManagerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) SessionManager *sessionManager;
@property (nonatomic, strong) NSMutableArray *messagesContainer;

@end
