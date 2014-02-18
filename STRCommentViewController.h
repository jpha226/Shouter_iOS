//
//  STRCommentViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShout.h"
#import "STRShouterAPI.h"

@interface STRCommentViewController : UITableViewController <ShouterAPIDelegate, UITextViewDelegate>;

@property NSMutableArray *commentList;

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UITextView *postCommentView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@property STRShout *headerShout;
@property STRShouterAPI *api;

-(void) updateList;

@end
