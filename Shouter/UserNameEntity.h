//
//  UserNameEntity.h
//  Shouter
//
//  Created by Kendall Foley on 5/3/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserNameEntity : NSManagedObject

@property (nonatomic, retain) NSString * deviceUserName;

@end
