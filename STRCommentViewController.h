//
//  STRCommentViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShout.h"
#import "STRShouterAPI.h"
#import <CoreLocation/CoreLocation.h>

@interface STRCommentViewController : UITableViewController <ShouterAPIDelegate, UITextViewDelegate, CLLocationManagerDelegate>;

@property NSMutableArray *commentList;
@property NSMutableSet *blockedUsers;

@property (strong, nonatomic) IBOutlet UITextView *headerShoutTextView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property CLLocationManager *locationManager;


@property STRShout *headerShout;
@property STRShouterAPI *api;

-(void) updateList;

@end
