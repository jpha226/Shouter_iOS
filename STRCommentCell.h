//
//  STRCommentCell.h
//  Shouter
//
//  Created by Kendall Foley on 3/9/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *commentLikeButton;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;

@end
