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
    
    NSString *label = [self.headerShout shoutMessage];
    NSInteger num_lines = 1 + ([label length] / 35);
    
    NSUInteger labelHeight = 25 + num_lines * 25 - (num_lines - 1) * 4;
    
    self.headerLabel.text = label;
    UIView *headerView = [self.headerLabel superview];
    headerView.frame = CGRectMake(0, 0, headerView.frame.size.width, labelHeight);
    self.headerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.headerLabel.numberOfLines = 0;
    NSArray *names = @[@"JosiahHanna", @"Charlie", @"Craig", @"wildcat8", @"LebronJames"];
    int name = rand();
    name = name % 5;
    self.userNameLabel.text = @"JosiahHanna";
    self.headerLabel.frame = CGRectMake(0, self.userNameLabel.frame.size.height, self.headerLabel.frame.size.width, labelHeight);
    
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
        
        // Clear previous border lines
        //for (CALayer *layer in cell.layer.sublayers) {
          //  if(layer.frame.size.height == 1.01f)
            //    [layer removeFromSuperlayer];
        //}
        
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, 1.01f);
        topBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [cell.layer addSublayer:topBorder];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, 75, cell.frame.size.width, 1.01f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [cell.layer addSublayer:bottomBorder];
        
        UITextView *commentView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, cell.frame.size.width - 10, cell.frame.size.height - 35)];
        commentView.delegate = self;
        commentView.tag = 22;
        commentView.text = @"Shout back!";
        commentView.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:commentView];
        
        commentView.layer.borderWidth = 1;
        commentView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        
        
    }
    else if(indexPath.row == 0){
        
        static NSString *CellIdentifier = @"commentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Clear previous border lines
        //for (CALayer *layer in cell.layer.sublayers) {
          //  if(layer.frame.size.height == 1.01f)
            //    [layer removeFromSuperlayer];
        //}
        
        // Configure the cell...
        STRShout *cellShout = [self.commentList objectAtIndex:([self.commentList count] - 1)];
        cell.detailTextLabel.text = cellShout.shoutMessage;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.numberOfLines = 0;
        NSArray *names = @[@"JosiahHanna", @"Charlie", @"Craig", @"wildcat8", @"LebronJames"];
        int name = rand();
        name = name % 5;
        cell.textLabel.text = @"User Name";
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        CALayer *topBorder = [CALayer layer];
        NSInteger num_lines = 1 + ([cellShout.shoutMessage length] / 32);
        
        topBorder.frame = CGRectMake(0, 0, cell.frame.size.width, 1.01f);
        topBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [cell.layer addSublayer:topBorder];
        
        CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 20 + num_lines * 15 - (num_lines - 1) * 4, cell.frame.size.width, 1.01f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [cell.layer addSublayer:bottomBorder];

    }
    else{
        
        
        static NSString *CellIdentifier = @"commentCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        // Clear previous border lines
        for (CALayer *layer in cell.layer.sublayers) {
            if(layer.frame.size.height == 1.01f)
                [layer removeFromSuperlayer];
        }
        
        // Configure the cell...
        NSUInteger commentCount = [self.commentList count];
        STRShout *cellShout = [self.commentList objectAtIndex:(commentCount - indexPath.row - 1)];
        cell.detailTextLabel.text = cellShout.shoutMessage;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.numberOfLines = 0;
        NSArray *names = @[@"JosiahHanna", @"Charlie", @"Craig", @"wildcat8", @"LebronJames"];
        int name = rand();
        name = name % 5;
        cell.textLabel.text = @"User Name";
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        
        CALayer *bottomBorder = [CALayer layer];
        NSInteger num_lines = 1 + ([cellShout.shoutMessage length] / 32);
        
        bottomBorder.frame = CGRectMake(0.0f, 25 + num_lines * 15 - (num_lines - 1) * 4, cell.frame.size.width, 1.01f);
        bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        [cell.layer addSublayer:bottomBorder];
    
    }
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.row == [self.commentList count]){
        
        
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
 */
- (IBAction)clickedShoutBack:(id)sender {
    
    UIButton *shoutBack = (UIButton*)sender;
    UIView *cell = (UIView*)shoutBack.superview;
    UITextView *comment = (UITextView*)[cell viewWithTag:22];
    NSLog(@"comment: %@",comment.description);
    
    if(comment.text.length > 0 && comment.text.length <= 141){
        
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
    else{
        NSUInteger commentCount = [self.commentList count];
        STRShout *cellShout = [self.commentList objectAtIndex:(commentCount - indexPath.row - 1)];
        NSString *label = [cellShout shoutMessage];
        NSInteger num_lines = 1 + ([label length] / 32);
        
        return 25 + num_lines * 15 - (num_lines - 1) * 4;
    
    }
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

- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{

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
