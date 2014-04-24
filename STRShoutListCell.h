//
//  STRShoutListCell.h
//  Shouter
//
//  Created by Kendall Foley on 3/6/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShout.h"
#import "STRShouterAPI.h"

@interface STRShoutListCell : UITableViewCell <ShouterAPIDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *shoutMessageView;

@property (strong, nonatomic) IBOutlet UIButton *commentButton;

@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *shoutTimeLabel;
@property STRShout* cellShout;
@property CGPoint originalCenter;
@property BOOL deleteOnDragRelease;
@property (nonatomic) STRShouterAPI *api;

@property UIGestureRecognizer *swipeRecognizer;

-(void) initCell;

@end
