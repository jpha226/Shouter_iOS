//
//  STRShout.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STRUser.h"

@interface STRShout : NSObject

@property NSString *shoutMessage;
@property NSString *phoneId;
@property STRUser *shoutPoster;
@property NSString *shoutLatitude;
@property NSString *shoutLongitude;
@property NSString *parentId;
@property NSString *shoutId;
@property NSString *shoutTime;
@property NSUInteger likeCount;
@property NSUInteger commentCount;

@end
