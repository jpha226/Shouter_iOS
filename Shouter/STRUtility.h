//
//  STRUtility.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "STRShout.h"

@interface STRUtility : NSObject

+ (CLLocation*)getUpToDateLocation;
+ (STRShout*)prepareShoutResponse: (NSString*)message;

@end
