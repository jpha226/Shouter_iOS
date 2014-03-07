//
//  STRLogInViewController.h
//  Shouter
//
//  Created by Kendall Foley on 3/6/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRLogInViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *passWordField;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *passWord;

@end
