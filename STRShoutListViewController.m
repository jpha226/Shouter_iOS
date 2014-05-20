//
//  STRShoutListViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRShoutListCell.h"
#import "STRShoutListViewController.h"
#import "STRLogInViewController.h"
#import "STRRegisterViewController.h"
#import "STRShout.h"
#import "STRPostShoutViewController.h"
#import "STRCommentViewController.h"
#import "STRShouterAPI.h"
#import "STRUser.h"
#import <CoreLocation/CoreLocation.h>
#import "STRUser.h"
#import "global.h"
@interface STRShoutListViewController ()



@end

@implementation STRShoutListViewController

@synthesize shoutList;
@synthesize locationManager;
@synthesize blockedUsers; // deprecated
@synthesize managedObjectContext;
@synthesize backgroundImage;
@synthesize viewBackGroundImage;
@synthesize indicator;

- (void)loadInitialData{
    
    
    [self refresh];
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    UIViewController *source = [segue sourceViewController];
    
    if([source isKindOfClass:[STRPostShoutViewController class]]){ // Just posted a shout
    
        NSString *newMessage = ((STRPostShoutViewController*)source).message;
        if (newMessage != nil) {
            [self.indicator startAnimating];
            // Post Shout and update list
            STRShout *newShout = [[STRShout alloc] init];
            newShout.shoutUserName = applicationUserName;
            newShout.shoutMessage = newMessage;
            newShout.phoneId = @"phone id";
            newShout.parentId = @"empty";
            
            // Fetch location
            [self startUpdatingCurrentLocation];
            CLLocation *currentLocation = [locationManager location];
            newShout.shoutLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
            newShout.shoutLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
            
            // Time stamp the shout
            NSDate* eventDate = currentLocation.timestamp;
            newShout.shoutTime = eventDate.description;
            
            
            [self.api postShout:newShout];
            self.didReturnFromCommentView = NO;
            [self updateList];
            
        }else{
            [self updateList];
        }
    }
    else if([source isKindOfClass:[STRCommentViewController class]]){
        
        [self updateList];
    }
    else if([source isKindOfClass:[STRRegisterViewController class]]){
        
        [self.indicator startAnimating];
        applicationUserName = (NSMutableString*)((STRRegisterViewController*)source).userName;
        NSLog(@"user name %@",applicationUserName);
        NSString *password = ((STRRegisterViewController*)source).password;
        [self.api registerUser:applicationUserName :password :password];
        

    }
    else{ // Just came from log-in screen
        
        // self.userName = ((STRLogInViewController*)source).userName;
        applicationUserName = [NSMutableString stringWithString:((STRLogInViewController*)source).userName];
        self.passWord = ((STRLogInViewController*)source).passWord;
        
    }
    
}

- (void)refreshView: (UIRefreshControl *) refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Shouts..."];
    
    // Refresh code goes here
    [self.indicator startAnimating];
    [self refresh];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",[formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
    
}

// This function gets shouts for the current location and updates the list
- (void) refresh
{
    //[self.locationManager startUpdatingLocation];
    [self startUpdatingCurrentLocation];
    CLLocation *currentLocation = [self.locationManager location];// = [STRUtility getUpToDateLocation];
    
    NSString *lat, *lon;
    if (currentLocation == nil) {
        NSLog(@"nil location");
        lat = [NSString stringWithFormat:@"%f",100.0];//38.0373319];
        lon = [NSString stringWithFormat:@"%f",100.0 ];//95.4953778];
    }
    else{
        
        lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    if (applicationUserName != nil) {
        
        [self.api getShout:applicationUserName :lat :lon];
        [self.locationManager stopUpdatingLocation];
    }
    
}

- (void) startUpdatingCurrentLocation
{
    
    if(self.locationManager == nil){
        NSLog(@"start updating");
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
        
        NSLog(@"start updating");
        [self.locationManager startUpdatingLocation];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"denied");
    }
    else
        [self.locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [locationManager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"latitude %+.6f, longitude %+.6f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    }
    
    [locationManager stopUpdatingLocation];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouter1small.jpg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    self.api = [[STRShouterAPI alloc] init];
    [self.api setDelegate:self];
    
    // Progress indicator
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    // Location services
    if(self.locationManager==nil){
        self.locationManager=[[CLLocationManager alloc] init];
        //I'm using ARC with this project so no need to release
        
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=500;
    }
   
    if(applicationUserName != nil)
        self.isLoggedIn = YES;
    else
        self.isLoggedIn = NO;
        
    if(!self.isLoggedIn){
        
        self.isLoggedIn = YES;
        
        //[self performSegueWithIdentifier:@"LogIn" sender:self]; // This line can be used to create a Log-in view
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Log In" message:@"Type your stuff" delegate:self cancelButtonTitle:@"Log In" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert addButtonWithTitle:@"Register"];
       
        [alert show];
        
        
    }else{
        
        self.shoutList = [[NSMutableArray alloc] init];
        [self loadInitialData];
        self.didReturnFromCommentView = YES;
        
    }
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
    action:@selector(refreshView:)
    forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self loadInitialData];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        [self.indicator startAnimating];
        NSString* username = (NSMutableString*)[[alertView textFieldAtIndex:0] text];
        NSString *password = [[alertView textFieldAtIndex:1] text];
       
        
        [self.api userAuthenticate:username :password];
        
    }
    else if (buttonIndex == 1){
        [self performSegueWithIdentifier:@"RegisterSegue" sender:self];
        NSLog(@"segue to register");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.shoutList count] < 1) {
        return 1;
    }
    return [self.shoutList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *shoutlistCellIdentifier = @"ListPrototypeCell";
    STRShoutListCell *customCell = (STRShoutListCell*)[tableView dequeueReusableCellWithIdentifier:shoutlistCellIdentifier];
    
    if (customCell == nil) {
        
        customCell = [[STRShoutListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shoutlistCellIdentifier];
       
    }
    
    [customCell initCell];
    
    if([shoutList count] < 1){
        customCell.shoutMessageView.text = @"Sorry, there appears to be no one shouting nearby you at this time";
        customCell.usernameLabel.text = @"Team Shouter";
        customCell.shoutTimeLabel.text = @"";
        CGRect frame = customCell.shoutMessageView.frame;
        frame.size.height = customCell.shoutMessageView.contentSize.height;
        customCell.shoutMessageView.frame = frame;
        customCell.shoutMessageView.layer.cornerRadius = 5.0;
        customCell.shoutMessageView.layer.borderWidth = 2.0f;
        customCell.shoutMessageView.layer.borderColor = [[UIColor blueColor] CGColor];
        
        return customCell;
    }
    
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    customCell.cellShout = cellShout;
    
    customCell.usernameLabel.text = cellShout.shoutUserName;
    
    // Format text area of cell
    customCell.shoutMessageView.text = cellShout.shoutMessage;
    
    CGRect frame = customCell.shoutMessageView.frame;
    frame.size.height = customCell.shoutMessageView.contentSize.height;
    customCell.shoutMessageView.frame = frame;
    customCell.shoutMessageView.layer.cornerRadius = 5.0;
    customCell.shoutMessageView.layer.borderWidth = 2.0f;
    customCell.shoutMessageView.layer.borderColor = [[UIColor blueColor] CGColor];
    //NSLog(@"height for %@: %f",customCell.shoutMessageView.text, frame.size.height);
    
    
    
    // Update like count
    NSString *like = [NSString stringWithFormat:@"%lu", (unsigned long)cellShout.likeCount];
    customCell.likeCountLabel.text = like;
    
    // Shout post time
    NSTimeInterval epochTime = [cellShout.shoutTime doubleValue];
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:epochTime];
    NSDate* currentDate = [[NSDate alloc] init];
    NSTimeInterval distanceBetweenTimes = [currentDate timeIntervalSinceDate:date];
    NSInteger elapsedTime = distanceBetweenTimes;
    NSString *timeString;
    if(elapsedTime < 60)
        timeString = [NSString stringWithFormat:@"%d s ago", elapsedTime];
    else if(distanceBetweenTimes < 3600)
        timeString = [NSString stringWithFormat:@"%d m ago", elapsedTime / 60];
    else if(elapsedTime < 3600 * 24)
        timeString = [NSString stringWithFormat:@"%d h ago", elapsedTime / 3600];
    else
        timeString = [NSString stringWithFormat:@"%d d ago", elapsedTime / 3600 / 24];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    customCell.shoutTimeLabel.text = timeString;// [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    
    customCell.commentButton.tag = indexPath.row;
    customCell.commentCountLabel.text = [NSString stringWithFormat:@"%u",cellShout.commentCount];
    
    return customCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([shoutList count] < 1)
        return 141;
        
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    NSString *label = [cellShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 29);
    
    // 1 line = 33
    // 2 lines = 50
    // 3 lines = 67
    // 4 lines = 83 NSLog(@"height in func: %d",40 + num_lines*17);
    return 60 + num_lines*27;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* userName;
    
    if([shoutList count] > 0)
        userName = [[shoutList objectAtIndex:indexPath.row] shoutUserName];
    else
        return YES;
    if([userName isEqualToString:applicationUserName]){
        
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    if(cellShout.shoutUserName != applicationUserName){
        
        if(userBlockedUsers == nil)
            userBlockedUsers = [[NSMutableSet alloc] init];
            
        [userBlockedUsers addObject:cellShout.shoutUserName];
        [self.api userBlock:applicationUserName :cellShout.shoutUserName];
    
    
        [self refresh];
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Block User";
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCommentView"]) {
      
        // Get the new view controller using [segue destinationViewController].
        STRCommentViewController *viewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Pass the selected object to the new view controller.
        viewController.headerShout = [self.shoutList objectAtIndex:indexPath.row];
        
        
    }
    else if([segue.identifier isEqualToString:@"buttonToCommentView"]){
        
        STRCommentViewController *viewController = [segue destinationViewController];
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // Pass the selected object to the new view controller.
        viewController.headerShout = [self.shoutList objectAtIndex:[sender tag]];
        
        
    }
    
}

- (NSMutableArray*) onGetShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    NSLog(@"getShoutReturn %@",jsonDict);
    if (error != nil) {
         NSLog(@"Error parsing JSON: %@",jsonDict);
    }
    else {
       
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
       
        NSDictionary *shout;
        
        for (int i=0; i<[shouts count]; i++) {
            
            shout = [shouts objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            
            newShout.shoutUserName = [shout objectForKey:@"userName"];
            
            if(![userBlockedUsers containsObject:newShout.shoutUserName]){
                
                newShout.shoutId = [shout objectForKey:@"id"];
                newShout.shoutLatitude = [shout objectForKey:@"latitude"];
                newShout.shoutLongitude = [shout objectForKey:@"longitude"];
                newShout.shoutMessage = [shout objectForKey:@"message"];
                STRUser* newUser = [[STRUser alloc] init];
                newShout.shoutPoster = newUser;
                newShout.shoutTime = [shout objectForKey:@"timestamp"];
                newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
                newShout.commentCount = [[shout objectForKey:@"numComments"] integerValue];
                BOOL boolValue = [[shout objectForKey:@"liked"] boolValue];
                //NSLog(@"bool: %d",boolValue);
                newShout.isLikedByUser = boolValue;
                [tempList addObject:newShout];
                
            }
        }
        self.api.shoutList = tempList;
        [self updateList];
        [self.indicator stopAnimating];
    }
    
    return nil;
}

- (void) onPostShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON: %@",jsonDict);
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
        
        NSDictionary *shout;
        
        for (int i=0; i<[shouts count]; i++) {
            
            shout = [shouts objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            
            newShout.shoutUserName = [shout objectForKey:@"userName"];
            
            if(![userBlockedUsers containsObject:newShout.shoutUserName]){
                
                newShout.shoutId = [shout objectForKey:@"id"];
                newShout.shoutLatitude = [shout objectForKey:@"latitude"];
                newShout.shoutLongitude = [shout objectForKey:@"longitude"];
                newShout.shoutMessage = [shout objectForKey:@"message"];
                STRUser* newUser = [[STRUser alloc] init];
                newShout.shoutPoster = newUser;
                newShout.shoutTime = [shout objectForKey:@"timestamp"];
                newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
                newShout.commentCount = [[shout objectForKey:@"numComments"] integerValue];
                NSString* boolValue = [shout objectForKey:@"idsLiked"];
                //NSLog(@"%@",boolValue);
                [tempList addObject:newShout];
                
            }

        }
        self.api.shoutList = tempList;
        [self updateList];
        [self.indicator stopAnimating];
    }
}


- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSLog(@"On create return %@",jsonDict);
    if (error != nil) {
        NSLog(@"Error parsing JSON: %@",jsonDict);
        
        
    }
    else {
        
        NSArray *users = [jsonDict objectForKey:@"user"];
        NSDictionary *user = [users objectAtIndex:0];
        
        applicationUserName = [user objectForKey:@"userName"];
        self.shoutList = [[NSMutableArray alloc] init];
        [self loadInitialData];
        self.didReturnFromCommentView = YES;
        self.isLoggedIn = YES;
        NSLog(@"logged in: %@", applicationUserName);
        [self.indicator stopAnimating];
        
    }
}

- (void) onUpdateUserReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserAuthenticateReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    
    if (error != nil) {
        NSLog(@"Error parsing JSON: %@",jsonDict);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Log In" message:@"Type your stuff" delegate:self cancelButtonTitle:@"Log In" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alert addButtonWithTitle:@"Register"];
        
        [alert show];
    }
    else {
        
        NSArray *users = [jsonDict objectForKey:@"user"];
        NSDictionary *user = [users objectAtIndex:0];
        
        applicationUserName = [user objectForKey:@"userName"];
        self.shoutList = [[NSMutableArray alloc] init];
        [self loadInitialData];
        self.didReturnFromCommentView = YES;
        self.isLoggedIn = YES;
        NSLog(@"logged in: %@", applicationUserName);
        [self.indicator stopAnimating];
        
    }
    
}
- (void) onUserBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserUnBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (NSMutableArray*) onGetCommentReturn:(STRShouterAPI*)api :(NSData*)result :(NSException*)exception{return nil;}
- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}

- (void)refreshDisplay:(UITableView *)tableView {
    [tableView reloadData];
}

- (void) updateList
{
    self.shoutList = self.api.shoutList;
    [self.tableView reloadData];
    self.shoutList = self.api.shoutList;
    [self performSelector:(@selector(refreshDisplay:)) withObject:(self.tableView) afterDelay:0.05];
}

-(void) viewDidAppear:(BOOL)animated{
    
    if(self.didReturnFromCommentView)
        [self refresh];
    else
        self.didReturnFromCommentView = YES;
    
}



@end
