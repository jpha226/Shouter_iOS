//
//  STRShoutListViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShouterAPI.h"
#import "STRShout.h"

@interface STRShoutListViewController : UITableViewController <ShouterAPIDelegate>

@property NSMutableArray *shoutList;
@property (nonatomic) STRShouterAPI *api;

- (void) updateList;

@end
