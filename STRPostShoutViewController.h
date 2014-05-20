//
//  STRPostShoutViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/22/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShout.h"
#import "STRShouterAPI.h"

@interface STRPostShoutViewController : UIViewController <UITextViewDelegate>

@property STRShout *createShout;
@property NSString *message;
@property (strong, nonatomic) IBOutlet UITextView *textView;


@end

