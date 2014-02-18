//
//  STRUtility.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRUtility.h"
#import "STRShout.h"
#import <CoreLocation/CoreLocation.h>

@implementation STRUtility

// Gets the location for tagging shouts
+ (CLLocation*)getUpToDateLocation
{
    
    CLLocationManager *locationManager;
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
    
    CLLocation *location = nil;
    
    // Get a location in here
    location = [locationManager location];
    
    
    [locationManager stopUpdatingLocation];
    
    return location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        //NSLog(@"latitude: %@",currentLocation.coordinate.latitude);
    }
}

+ (STRShout*) prepareShoutResponse: (NSString*)message{
    
    STRShout *returnShout = [[STRShout alloc] init];
    returnShout.shoutMessage = message;
    // Get the location for the shout
    CLLocation *currentLocation = [STRUtility getUpToDateLocation];
    
    if (currentLocation == nil) {
        NSLog(@"nil location");
        returnShout.shoutLatitude = [NSString stringWithFormat:@"%f",69.0];
        returnShout.shoutLongitude = [NSString stringWithFormat:@"%f",13.0];
    }
    else{
        returnShout.shoutLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        returnShout.shoutLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    
    // Time stamp the shout
    NSDate* eventDate = currentLocation.timestamp;
    returnShout.shoutTime = eventDate.description;
    returnShout.phoneId = @"phoneID";
    returnShout.parentId = @"empty";
    // Assign phone ID / User to the shout
    
    NSLog(@"latitude: %f, longitude %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    return returnShout;
}



@end
