//
//  STRPostShoutViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRPostShoutViewController.h"
#import "STRShout.h"
#import <CoreLocation/CoreLocation.h>
#import "STRUtility.h"


@interface STRPostShoutViewController ()


@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shoutButton;

@end



@implementation STRPostShoutViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.shoutButton) return;
    if (self.textView.text.length > 0) {
        
        //[self prepareShoutResponse];
        self.createShout = [STRUtility prepareShoutResponse:self.textView.text];
        
    }
}

// Deprecated function. Now handled with STRUtility.prepareShoutResponse
- (void) prepareShoutResponse
{
    self.createShout = [[STRShout alloc] init];
    self.createShout.shoutMessage = self.textView.text;
    
    // Get the location for the shout
    CLLocation *currentLocation = [STRUtility getUpToDateLocation];
    if (currentLocation == nil) {
        NSLog(@"nil location");
        self.createShout.shoutLatitude = [NSString stringWithFormat:@"%f",69.0];
        self.createShout.shoutLongitude = [NSString stringWithFormat:@"%f",13.0];
    }
    else{
        self.createShout.shoutLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        self.createShout.shoutLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    
    // Time stamp the shout
    NSDate* eventDate = currentLocation.timestamp;
    self.createShout.shoutTime = eventDate.description;
    self.createShout.phoneId = @"phoneID";
    self.createShout.parentId = @"empty";
    // Assign phone ID / User to the shout
    
    NSLog(@"latitude: %f, longitude %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
