//
//  STRShoutListViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "STRShouterAPI.h"
#import "STRShout.h"

@interface STRShoutListViewController : UITableViewController <ShouterAPIDelegate, CLLocationManagerDelegate>

@property NSMutableArray *shoutList;
@property CLLocationManager *locationManager;
@property (nonatomic) STRShouterAPI *api;
@property (nonatomic) BOOL isLoggedIn;
@property NSString* userName;
@property NSString* passWord;

- (void) updateList;

@end
