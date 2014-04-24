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
#import "STRShout.h"
#import "STRPostShoutViewController.h"
#import "STRCommentViewController.h"
#import "STRShouterAPI.h"
#import "STRUtility.h"
#import "STRUser.h"
#import <CoreLocation/CoreLocation.h>

@interface STRShoutListViewController ()


@end

@implementation STRShoutListViewController

@synthesize shoutList;
@synthesize locationManager;


- (void)loadInitialData{
    
    self.api = [[STRShouterAPI alloc] init];
    //[self.api register:@"phoneID" :@"first" :@"last" :@"blank"];
    [self.api setDelegate:self];
    [self refresh];
    
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    UIViewController *source = [segue sourceViewController];
    
    if([source isKindOfClass:[STRPostShoutViewController class]]){ // Just posted a shout
    
        STRShout *newShout = ((STRPostShoutViewController*)source).createShout;
        if (newShout != nil) {
        
            // Post Shout and update list
            [self.api postShout:newShout];
            [self updateList];
            
        }
    }
    else{ // Just came from log-in screen
        
        self.userName = ((STRLogInViewController*)source).userName;
        self.passWord = ((STRLogInViewController*)source).passWord;
        
    }
    
}

- (void)refreshView: (UIRefreshControl *) refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing Shouts..."];
    
    // Refresh code goes here
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
    CLLocation *currentLocation = [self.locationManager location];// = [STRUtility getUpToDateLocation];
    //[self getCurrentLocation];
    NSString *lat, *lon;
    if (currentLocation == nil) {
       
        lat = [NSString stringWithFormat:@"%f",100.0];//38.0373319];
        lon = [NSString stringWithFormat:@"%f",100.0 ];//95.4953778];
    }
    else{
        lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    
    [self.api getShout:lat :lon];
}

- (void) getCurrentLocation
{
    
    if(self.locationManager == nil){
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    }
    if([CLLocationManager locationServicesEnabled]){
        
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - CLLocationManagerDelegate

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
        NSLog(@"lat: %f", currentLocation.coordinate.latitude);
    }
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
    self.isLoggedIn = NO;
    self.passWord = @"password";
    if(!self.isLoggedIn){
        //[self performSegueWithIdentifier:@"logInIdentifier" sender:self];
        self.isLoggedIn = YES;
    }
    
    self.shoutList = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    //[self.tableView registerClass:[STRShoutListCell class] forCellReuseIdentifier:@"ListPrototypeCell"];
    [self getCurrentLocation];
    
    //[self.tableView registerNib:[UINib nibWithNibName:@"ShoutListCell" bundle:nil] forCellReuseIdentifier:@"ListPrototypeCell"];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
    action:@selector(refreshView:)
    forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
    return [self.shoutList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
    
    static NSString *shoutlistCellIdentifier = @"ListPrototypeCell";
    STRShoutListCell *customCell = (STRShoutListCell*)[tableView dequeueReusableCellWithIdentifier:shoutlistCellIdentifier];
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    customCell.cellShout = cellShout;
    if (customCell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShoutListCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
       
    }
    [customCell initCell];
    customCell.shoutMessageView.layer.cornerRadius = 5.0;
    
    customCell.usernameLabel.text = cellShout.phoneId;
    
    // Format text area of cell
    customCell.shoutMessageView.text = cellShout.shoutMessage;
    NSString *label = [cellShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 32);
    customCell.shoutMessageView.frame = CGRectMake(customCell.shoutMessageView.frame.origin.x, customCell.shoutMessageView.frame.origin.y, customCell.shoutMessageView.frame.size.width, 35 + num_lines*15);
    
    NSString *like = [NSString stringWithFormat:@"%u", cellShout.likeCount];
    customCell.likeCountLabel.text = like;
    
    NSTimeInterval epochTime = [cellShout.shoutTime doubleValue];
    NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:epochTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    customCell.shoutTimeLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    customCell.commentButton.tag = indexPath.row;
    customCell.likeCountLabel.text = [NSString stringWithFormat:@"%u",cellShout.likeCount];
    customCell.commentCountLabel.text = [NSString stringWithFormat:@"%u",cellShout.commentCount];
    
    return customCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    NSString *label = [cellShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 32);
    
    return 60 + num_lines * 15;
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
    
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
       
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
       
        NSDictionary *shout;
        
        for (int i=0; i<[shouts count]; i++) {
            
            shout = [shouts objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            newShout.shoutId = [shout objectForKey:@"id"];
            newShout.shoutLatitude = [shout objectForKey:@"latitude"];
            newShout.shoutLongitude = [shout objectForKey:@"longitude"];
            newShout.shoutMessage = [shout objectForKey:@"message"];
            newShout.phoneId = [shout objectForKey:@"userName"];
            newShout.shoutTime = [shout objectForKey:@"timestamp"];
            newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
            newShout.commentCount = [[shout objectForKey:@"numComments"] integerValue];
            //[tempList insertObject:newShout atIndex:0];
            [tempList addObject:newShout];
        }
        self.api.shoutList = tempList;
        [self updateList];
    }
    
    return nil;
}

- (void) onPostShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
        
        NSDictionary *shout;
        
        for (int i=0; i<[shouts count]; i++) {
            
            shout = [shouts objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            newShout.shoutId = [shout objectForKey:@"id"];
            newShout.shoutLatitude = [shout objectForKey:@"latitude"];
            newShout.shoutLongitude = [shout objectForKey:@"longitude"];
            newShout.shoutMessage = [shout objectForKey:@"message"];
            newShout.phoneId = [shout objectForKey:@"userName"];
            newShout.shoutTime = [shout objectForKey:@"timestamp"];
            newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
            newShout.commentCount = [[shout objectForKey:@"numComments"] integerValue];
            //[tempList insertObject:newShout atIndex:0];//([tempList count]-1)];
            [tempList addObject:newShout];
        }
        self.api.shoutList = tempList;
        [self updateList];
    }
}


- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSData*)result :(NSException*)exception
{
    
}

- (void) onUpdateUserReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserAuthenticateReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserUnBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}

- (void) updateList
{
    self.shoutList = self.api.shoutList;
    [self.tableView reloadData];
    [self.tableView reloadData];
}

@end
