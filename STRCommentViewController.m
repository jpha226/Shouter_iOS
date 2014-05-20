//
//  STRCommentViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRCommentViewController.h"
#import "STRShout.h"
#import "STRShoutListViewController.h"
#import "STRPostShoutViewController.h"
#import "STRShouterAPI.h"
#import "STRCommentCell.h"
#import "STRUtility.h"
#import "global.h"

@interface STRCommentViewController ()


@end

@implementation STRCommentViewController

@synthesize headerShout;
@synthesize commentList;
@synthesize blockedUsers;
@synthesize headerView;
@synthesize headerShoutTextView;
@synthesize commentButton;
@synthesize commentTextField;
@synthesize locationManager;

- (void)loadInitialData{
    
    self.api = [[STRShouterAPI alloc] init];
    [self.api setDelegate:self];
    [self refresh];
}

- (void) refresh
{
    if(applicationUserName != nil)
        [self.api getComment:applicationUserName :headerShout.shoutId];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.tableHeaderView = self.headerView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"loading view");
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shouter1small.jpg"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    
    //self.tableView.tableHeaderView = self.headerView;
    self.commentList = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    self.headerShoutTextView.text = headerShout.shoutMessage;
    CGRect frame = self.headerShoutTextView.frame;
    frame.size.height = self.headerShoutTextView.contentSize.height;
    self.headerShoutTextView.frame = frame;
    self.headerShoutTextView.layer.cornerRadius = 5.0;
    
    self.userNameLabel.text = self.headerShout.shoutUserName;
    
    CGRect headerFrame = self.headerView.frame;
    headerFrame.size.height = frame.size.height + 50.0;
    self.headerView.frame = headerFrame;
    
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    
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
    return [self.commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"commentCell";
    STRCommentCell* comCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(comCell == nil){
        
        comCell = [[STRCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    NSUInteger commentCount = [self.commentList count];
    STRShout *cellShout = [self.commentList objectAtIndex:indexPath.row];//(commentCount - indexPath.row - 1)];
    comCell.cellShout = cellShout;
        
    comCell.commentTextView.text = cellShout.shoutMessage;
    comCell.usernameLabel.text = cellShout.shoutUserName;
    comCell.commentTextView.layer.cornerRadius = 5.0;
    CGRect frame = comCell.commentTextView.frame;
    frame.size.height = comCell.commentTextView.contentSize.height;
    comCell.commentTextView.frame = frame;
    
   
    comCell.commentTextView.layer.borderWidth = 2.0f;
    comCell.commentTextView.layer.borderColor = [[UIColor blueColor] CGColor];
    
    // Like button
    comCell.likeCountLabel.text = [NSString stringWithFormat:@"%u",cellShout.likeCount];
    
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
    comCell.commentTimeLabel.text = timeString;
    
    // Deprecated for adding borders to cells vvvvvv
    //CALayer *bottomBorder = [CALayer layer];
    //NSInteger num_lines = 1 + ([cellShout.shoutMessage length] / 32);
    //bottomBorder.frame = CGRectMake(0.0f, 25 + num_lines * 15 - (num_lines - 1) * 4, cell.frame.size.width, 1.01f);
    //bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    //[cell.layer addSublayer:bottomBorder];
    return comCell;

}


- (IBAction)clickedCommentButton:(id)sender {
    
    NSString* commentText = self.commentTextField.text;
    
    
    if(commentText.length > 0 && commentText.length <= 141){
        [self startUpdatingCurrentLocation];
        CLLocation *currentLocation = [locationManager location];
        STRShout *newComment = [STRUtility prepareShoutResponse:commentText];
        
        
        if (newComment != nil) {
            
            if(self.headerShout.shoutId != nil){
                
                newComment.parentId = self.headerShout.shoutId;
                newComment.shoutUserName = applicationUserName;
                
                NSString *lat, *lon;
                if (currentLocation == nil) {
                    
                    lat = [NSString stringWithFormat:@"%f", 38.0373319];
                    lon = [NSString stringWithFormat:@"%f", 95.4953778];
                }
                else{
                    
                    lat = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                    lon = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
                
                newComment.shoutLatitude = lat;
                newComment.shoutLongitude = lon;
                
            }
            NSLog(@"%@",applicationUserName);
            [self.api postComment:newComment];
            [self.commentTextField endEditing:YES];
        }

        
    }
    self.commentTextField.text = @"";
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STRShout *cellShout = [self.commentList objectAtIndex:indexPath.row];
    NSString *label = [cellShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 47);
    
    // 1 line = 33
    // 2 lines = 50
    // 3 lines = 67
    // 4 lines = 83
    
    return 50 + num_lines * 27;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    STRShout *cellShout = [self.commentList objectAtIndex:([self.commentList count] - indexPath.row - 1)];
    
    [self.api userBlock:applicationUserName :cellShout.shoutUserName];
    [blockedUsers addObject:cellShout.shoutUserName];
    [self refresh];
    
    NSLog(@"User Blocked");
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Block User";
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"Shout back!"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Shout back!";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void) textViewDidChange:(UITextView *)textView
{
    UITableViewCell *cell = (UITableViewCell *)textView.superview;
    UITextView *commentView = (UITextView*)[cell viewWithTag:22];
    commentView.text = textView.text;
    
    NSInteger textLength = [textView.text length];
    
    if (textLength <= 141 && textLength > 0) {
        
        UINavigationItem *navBar = self.navigationItem;
        navBar.title = [NSString stringWithFormat:@"%d",141 - textLength];
        
    }
    else if(textLength == 0){
        
        UINavigationItem *navBar = self.navigationItem;
        navBar.title = @"Shouter";
    }
    
}


- (NSMutableArray*) onGetCommentReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception
{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
        
        NSArray* comments = [[shouts objectAtIndex:0] objectForKey:@"comments"];
       NSLog(@"comment return: %@", jsonDict);
        
        NSDictionary *shout;
        
        for (int i=0; i<[comments count]; i++) {
            
            shout = [comments objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            
            newShout.shoutUserName = [shout objectForKey:@"userName"];
            
            if(![blockedUsers containsObject:newShout.shoutUserName]){
            
                newShout.shoutId = [shout objectForKey:@"id"];
                newShout.shoutLatitude = [shout objectForKey:@"latitude"];
                newShout.shoutLongitude = [shout objectForKey:@"longitude"];
                newShout.shoutMessage = [shout objectForKey:@"message"];
                newShout.shoutTime = [shout objectForKey:@"timestamp"];
                newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
                newShout.isLikedByUser = [[shout objectForKey:@"liked"] boolValue];
                [tempList insertObject:newShout atIndex:0];
            
            }
        }
        self.api.shoutList = tempList;
        [self updateList];
    }
    
    return nil;
}

- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{

    NSError *error = nil;
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    NSLog(@"%@",jsonDict);
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"shouts"]; //2
        
        NSArray* comments = [[shouts objectAtIndex:0] objectForKey:@"comments"];
       
        
        NSDictionary *shout;
        
        for (int i=0; i<[comments count]; i++) {
            
            shout = [comments objectAtIndex:i];
            STRShout *newShout = [[STRShout alloc] init];
            
            newShout.shoutUserName = [shout objectForKey:@"userName"];
            
            if(![blockedUsers containsObject:newShout.shoutUserName]){
                
                newShout.shoutId = [shout objectForKey:@"id"];
                newShout.shoutLatitude = [shout objectForKey:@"latitude"];
                newShout.shoutLongitude = [shout objectForKey:@"longitude"];
                newShout.shoutMessage = [shout objectForKey:@"message"];
                newShout.shoutTime = [shout objectForKey:@"timestamp"];
                newShout.likeCount = [[shout objectForKey:@"numLikes"] integerValue];
                newShout.isLikedByUser = [[shout objectForKey:@"liked"] boolValue];
                [tempList insertObject:newShout atIndex:0];
                
            }
        }
        self.api.shoutList = tempList;
        [self updateList];

    }

}


- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception{}
- (void) onUpdateUserReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (void) onUserAuthenticateReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (void) onUserBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
}
- (void) onUserUnBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}

- (NSMutableArray*) onGetShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{return nil;}
- (void) onPostShoutReturn:(STRShouterAPI*)api :(NSData*) data :(NSException*)exception{}
- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{}
- (void)refreshDisplay:(UITableView *)tableView {
    [tableView reloadData];
}

- (void) updateList
{
    self.commentList = self.api.shoutList;
    [self.tableView reloadData];
    [self performSelector:(@selector(refreshDisplay:)) withObject:(self.tableView) afterDelay:0.05];
}

- (void) startUpdatingCurrentLocation
{
    
    if(self.locationManager == nil){
        NSLog(@"manager was nil");
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
        NSLog(@"location services enabled");
        
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


@end
