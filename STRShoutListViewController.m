//
//  STRShoutListViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRShoutListViewController.h"
#import "STRShout.h"
#import "STRPostShoutViewController.h"
#import "STRCommentViewController.h"
#import "STRShouterAPI.h"
#import "STRUtility.h"
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
    STRPostShoutViewController *source = [segue sourceViewController];
    STRShout *newShout = source.createShout;
    if (newShout != nil) {
        //[self.shoutList insertObject:newShout atIndex:0];
        //[self.tableView reloadData];
        [self.api postShout:newShout];
        [self updateList];
        
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

- (void) refresh
{
    CLLocation *currentLocation = [self.locationManager location];// = [STRUtility getUpToDateLocation];
    //[self getCurrentLocation];
    NSString *lat, *lon;
    if (currentLocation == nil) {
        NSLog(@"nil location");
        lat = [NSString stringWithFormat:@"%f",69.0];
        lon = [NSString stringWithFormat:@"%f",13.0];
    }
    else{
        lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    [self.api getShout:lat :lon];
}

- (void) getCurrentLocation
{
    NSLog(@"hey");
    if(self.locationManager == nil){
        NSLog(@"in here");
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    }
    if([CLLocationManager locationServicesEnabled]){
        NSLog(@"enabled");
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shoutList = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    [self getCurrentLocation];
    
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
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Clear previous border lines
    for (CALayer *layer in cell.layer.sublayers) {
        if(layer.frame.size.height == 1.01f)
            [layer removeFromSuperlayer];
    }
    
    // Configure the cell...
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = cellShout.shoutMessage;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = @"User Name";
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    CALayer *bottomBorder = [CALayer layer];
    NSInteger num_lines = 1 + ([cellShout.shoutMessage length] / 32);
    
    bottomBorder.frame = CGRectMake(0.0f, 20 + num_lines * 15 - (num_lines - 1) * 4, cell.frame.size.width, 1.01f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    
    [cell.layer addSublayer:bottomBorder];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STRShout *cellShout = [self.shoutList objectAtIndex:indexPath.row];
    NSString *label = [cellShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 32);
    return 20 + num_lines * 15 - (num_lines - 1) * 4;
    
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
    
}

- (NSMutableArray*) onGetShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    //NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
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
            newShout.phoneId = [shout objectForKey:@"phoneID"];
            newShout.shoutTime = [shout objectForKey:@"timestamp"];
            [tempList insertObject:newShout atIndex:0];
            
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
            newShout.phoneId = [shout objectForKey:@"phoneID"];
            newShout.shoutTime = [shout objectForKey:@"timestamp"];
            [tempList insertObject:newShout atIndex:0];
            
        }
        self.api.shoutList = tempList;
        [self updateList];
    }
}


- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception
{
    
}

- (void) updateList
{
    self.shoutList = self.api.shoutList;
    [self.tableView reloadData];
}

@end
