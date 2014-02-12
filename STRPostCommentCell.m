//
//  STRPostCommentCell.m
//  Shouter
//
//  Created by Kendall Foley on 2/12/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRPostCommentCell.h"

@implementation STRPostCommentCell

@synthesize inputText, postComment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
