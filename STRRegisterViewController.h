//
//  STRRegisterViewController.h
//  Shouter
//
//  Created by Kendall Foley on 3/7/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRRegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *retypePasswordField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *password;

@end
