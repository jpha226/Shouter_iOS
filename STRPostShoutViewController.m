//
//  STRPostShoutViewController.m
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRPostShoutViewController.h"
#import "STRShout.h"
#import <CoreLocation/CoreLocation.h>
#import "STRUtility.h"
#define MAX_LENGTH = 141;

@interface STRPostShoutViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shoutButton;

@end



@implementation STRPostShoutViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if (sender != self.shoutButton) return; // sender is not the post button
    
    if (self.textView.text.length > 0) { // There is a message typed
        
        self.createShout = [STRUtility prepareShoutResponse:self.textView.text]; // create shout to return
        
    }
}

// Deprecated function. Now handled with STRUtility.prepareShoutResponse
- (void) prepareShoutResponse
{
    self.createShout = [[STRShout alloc] init];
    self.createShout.shoutMessage = self.textView.text;
    
    // Get the location for the shout
    CLLocation *currentLocation = [STRUtility getUpToDateLocation];
    if (currentLocation == nil) {
        
        self.createShout.shoutLatitude = [NSString stringWithFormat:@"%f",69.0];
        self.createShout.shoutLongitude = [NSString stringWithFormat:@"%f",13.0];
    }
    else{
        self.createShout.shoutLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        self.createShout.shoutLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];    }
    
    // Time stamp the shout
    NSDate* eventDate = currentLocation.timestamp;
    self.createShout.shoutTime = eventDate.description;
    self.createShout.phoneId = @"phoneID";
    self.createShout.parentId = @"empty";
    // Assign phone ID / User to the shout
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.textView.delegate = self;
    self.textView.text = @"What's happening around you?";
    self.textView.textColor = [UIColor lightGrayColor];
    self.shoutButton.enabled = false;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When someone begins to edit the text view this function is called
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // The place holder text is on the text view
    if ([textView.text isEqualToString:@"What's happening around you?"]) {
        
        // Get rid of place holder text and prepare for typed message
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    
    }
    [textView becomeFirstResponder];
}

//
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    // If no text and editing is finished
    if ([textView.text isEqualToString:@""]) {
        
        // reset place holder text reset
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
        
    }
    [textView resignFirstResponder];
}

// Function for when a character is typed or deleted
- (void) textViewDidChange:(UITextView *)textView
{
    NSInteger textLength;
    textLength = [textView.text length];
    
    // There are characters typed but not too many
    if (textLength <= 141 && textLength > 0) {
        
        // Set character count and enable button
        UINavigationItem *navBar = self.navigationItem;
        navBar.title = [NSString stringWithFormat:@"%d",141 - textLength];
        navBar.rightBarButtonItem.enabled = true;
   
    }
    else if(textLength == 0){ // No text typed
        
        // Set navigation bar title
        UINavigationItem *navBar = self.navigationItem;
        navBar.title = @"Shouter";
        navBar.rightBarButtonItem.enabled = false;
        
    }
    else{ // Too many characters typed
        
        // Set negative character count and disable button
        UINavigationItem *navBar = self.navigationItem;
        navBar.title = [NSString stringWithFormat:@"%d",141 - textLength];
        navBar.rightBarButtonItem.enabled = false;
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   return YES;
}

@end
