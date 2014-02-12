//
//  STRPostCommentCell.h
//  Shouter
//
//  Created by Kendall Foley on 2/12/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STRPostCommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *inputText;
@property (nonatomic, weak) IBOutlet UIButton *postComment;

@end