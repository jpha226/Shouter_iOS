//
//  STRAppDelegate.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRAppDelegate.h"
#import "STRShoutListViewController.h"
#import "UserNameEntity.h"
#import "global.h"

@implementation STRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // For push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    NSLog(@"orig dev username: %@",applicationUserName);
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"UserNameEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"deviceUserName"]);
    }
    //if ([fetchedObjects count] > 1)
      //  applicationUserName = [[fetchedObjects objectAtIndex:0] valueForKey:@"deviceUserName"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"storedUserName"; // the key for the data
    NSString *blockedKey = @"storedBlockedNames";
    
    NSString *fromDefaults = [defaults stringForKey:key];
    NSArray *blockedUsers = (NSArray*)[defaults objectForKey:blockedKey];
    
    if(fromDefaults != nil)
        applicationUserName = [[NSMutableString alloc] initWithString:fromDefaults];
    if(blockedUsers != nil)
        userBlockedUsers = [[NSMutableSet alloc] initWithArray:blockedUsers];
    
    NSLog(@"UserName: %@",applicationUserName);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *storedVal = applicationUserName;
    NSString *key = @"storedUserName"; // the key for the data
    NSString *blockedKey = @"storedBlockedNames";
    
    NSArray *blockedUsers = [userBlockedUsers allObjects];
    [defaults setObject:storedVal forKey:key];
    [defaults setObject:blockedUsers forKey:blockedKey];
    [defaults synchronize]; // this method is optional
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"will term");
    NSManagedObjectContext *context = [self managedObjectContext];
    UserNameEntity *deviceUser = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"UserNameEntity"
                                  inManagedObjectContext:context];
    deviceUser.deviceUserName = applicationUserName;
    
    NSError *error;
    //if (![context save:&error]) {
      //  NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    //}
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *storedVal = applicationUserName;
    NSString *key = @"storedUserName"; // the key for the data
    NSString *blockedKey = @"storedBlockedNames";
    
    NSArray *blockedUsers = [userBlockedUsers allObjects];
    [defaults setObject:storedVal forKey:key];
    [defaults setObject:blockedUsers forKey:blockedKey];
    [defaults synchronize]; // this method is optional
    
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShouterAppDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShouterAppDataModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma - push notifications

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	UINavigationController *navigationController = (UINavigationController*)_window.rootViewController;
    STRShoutListViewController *shoutListViewController = (STRShoutListViewController*)[navigationController.viewControllers objectAtIndex:0];
    
    //DataModel *dataModel = shoutListViewController.dataModel;
	//NSString *oldToken = [dataModel deviceToken];
    
	NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
    
	//[dataModel setDeviceToken:newToken];
    
	//if ([dataModel joinedChat] && ![newToken isEqualToString:oldToken])
	//{
		//[self postUpdateRequest];
	//}
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

@end
