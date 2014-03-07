//
//  STRLogInViewController.m
//  Shouter
//
//  Created by Kendall Foley on 3/6/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRLogInViewController.h"

@interface STRLogInViewController ()

@end


@implementation STRLogInViewController

@synthesize userNameField;
@synthesize passWordField;
@synthesize userName;
@synthesize passWord;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.logInButton) return;
    self.userName = self.userNameField.text;
    self.passWord = self.passWordField.text;
    
    
}


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
    self.passWordField.secureTextEntry = YES;
    self.logInButton.enabled = NO;
    [self.userNameField addTarget:self action:@selector(userTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passWordField addTarget:self action:@selector(passwordTextDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userTextDidChange:(id)sender {
    if(self.userNameField.text.length > 0 && self.passWordField.text.length > 0){
        self.logInButton.enabled = YES;
    }
    else{
        self.logInButton.enabled = NO;
    }
}

- (IBAction)passwordTextDidChange:(id)sender {
    
    if(self.passWordField.text.length > 0 && self.userNameField.text.length > 0){
        self.logInButton.enabled = YES;
    }
    else{
        self.logInButton.enabled = NO;
    }
}

@end
