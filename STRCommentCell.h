//
//  STRCommentCell.h
//  Shouter
//
//  Created by Kendall Foley on 3/9/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShouterAPI.h"
#import "STRShout.h"

@interface STRCommentCell : UITableViewCell <ShouterAPIDelegate>

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *commentLikeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentTimeLabel;

@property STRShouterAPI* api;
@property STRShout* cellShout;

-(void) initCell;

@end
