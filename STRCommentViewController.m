//
//  STRCommentViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRCommentViewController.h"
#import "STRShout.h"
#import "STRPostShoutViewController.h"
#import "STRShouterAPI.h"
#import "STRPostCommentCell.m"
#import "STRUtility.h"

@interface STRCommentViewController ()


@end

@implementation STRCommentViewController

@synthesize headerShout;
@synthesize commentList;
@synthesize headerLabel;

- (void)loadInitialData{
    
    self.api = [[STRShouterAPI alloc] init];
    [self.api setDelegate:self];
    [self refresh];
}

- (void) refresh
{
    [self.api getComment:headerShout.shoutId];
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
    self.commentList = [[NSMutableArray alloc] init];
    [self loadInitialData];
    self.headerLabel.text = self.headerShout.shoutMessage;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.commentList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if(indexPath.row == [self.commentList count]){
        
        static NSString *CellIdentifier = @"postCommentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        CALayer *topBorder = [CALayer layer];
        
        topBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 1.0f);
        
        topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                      alpha:1.0f].CGColor;
        [cell.layer addSublayer:topBorder];
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 75, cell.frame.size.width, 1.0f);
        
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        [cell.layer addSublayer:bottomBorder];
    }
    else{
        
        static NSString *CellIdentifier = @"commentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        // Configure the cell...
        int shoutCount = [self.commentList count] - 1;
        STRShout *cellShout = [self.commentList objectAtIndex:(shoutCount - indexPath.row)];
        cell.textLabel.text = cellShout.shoutMessage;
         cell.detailTextLabel.text = @"User Name";
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 1.0f);
        topBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                         alpha:1.0f].CGColor;
        [cell.layer addSublayer:topBorder];
        
        
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.row == [self.commentList count]){
        
        static NSString *CellIdentifier = @"postCommentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    else{
        
        static NSString *CellIdentifier = @"commentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        int shoutCount = [self.commentList count] - 1;
        STRShout *cellShout = [self.commentList objectAtIndex:(shoutCount - indexPath.row)];
        cell.textLabel.text = cellShout.shoutMessage;
    }
    
    [self.tableView reloadData];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)clickedShoutBack:(id)sender {
    
    UIButton *shoutBack = (UIButton*)sender;
    UIView *cell = (UIView*)shoutBack.superview;
    UITextField *comment = (UITextField*)[cell viewWithTag:22];
    NSLog(@"%@",comment.text);
    
    if(comment.text.length > 0){
        
        STRShout *newComment = [STRUtility prepareShoutResponse:comment.text];
        
        if (newComment != nil) {
            
            if(self.headerShout.shoutId != nil){
                
                newComment.parentId = self.headerShout.shoutId;
                
            }
            
            [self.api postComment:newComment];
        }

        
    }
    comment.text = @"";
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.commentList.count) {
        return YES;
    }
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.commentList.count) {
        return 75;
    }
    else
        return 45;
    
}

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (NSMutableArray*) onGetCommentReturn:(STRShouterAPI*)api :(NSMutableData*)data :(NSException*)exception
{
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"onGetSR: %@",response);
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"comments"]; //2
        //NSLog(@"shouts: %@", shouts);
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

- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSMutableData*)data :(NSException*)exception{

    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        NSArray* shouts = [jsonDict objectForKey:@"comments"]; //2
        //NSLog(@"shouts: %@", shouts);
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


- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception{}


- (void) updateList
{
    self.commentList = self.api.shoutList;
    [self.tableView reloadData];
}

@end
