//
//  STRRegisterViewController.m
//  Shouter
//
//  Created by Kendall Foley on 3/7/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRRegisterViewController.h"

@interface STRRegisterViewController ()

@end

@implementation STRRegisterViewController

@synthesize passwordField;
@synthesize retypePasswordField;
@synthesize usernameField;
@synthesize registerButton;
@synthesize userName;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.passwordField.secureTextEntry = YES;
    self.retypePasswordField.secureTextEntry = YES;
    self.registerButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)usernameFieldChanged:(id)sender {
    
    if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0 && [self.passwordField.text isEqualToString:self.retypePasswordField.text]) {
        self.registerButton.enabled = YES;
    }
    else{
        self.registerButton.enabled = NO;
    }
    
}
- (IBAction)passwordFieldChanged:(id)sender {
    if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0 && [self.passwordField.text isEqualToString:self.retypePasswordField.text]) {
        self.registerButton.enabled = YES;
    }
    else{
        self.registerButton.enabled = NO;
    }
    
}

- (IBAction)retypePasswordFieldChanged:(id)sender {

    if (self.usernameField.text.length > 0 && self.passwordField.text.length > 0 && [self.passwordField.text isEqualToString:self.retypePasswordField.text]) {
        self.registerButton.enabled = YES;
    }
    else{
        self.registerButton.enabled = NO;
        
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.registerButton) return;
    self.userName = self.usernameField.text;
    self.password = self.passwordField.text;
    
    
}

@end
