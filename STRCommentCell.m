//
//  STRCommentCell.m
//  Shouter
//
//  Created by Kendall Foley on 3/9/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRCommentCell.h"
#import "STRShout.h"
#import "global.h"

@implementation STRCommentCell

@synthesize api;
@synthesize cellShout;
@synthesize commentTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) initCell{
    
    [self.api setDelegate:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeButtonPressed:(id)sender {
    
    if(cellShout.isLikedByUser){
        NSUInteger likeCount = [self.likeCountLabel.text intValue];
        likeCount = likeCount - 1;
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d",likeCount];
        [self.api unLikeShout:applicationUserName :cellShout.shoutId];
        cellShout.isLikedByUser = NO;
    }
    else{
        NSUInteger likeCount = [self.likeCountLabel.text intValue];
        likeCount = likeCount + 1;
        self.likeCountLabel.text = [NSString stringWithFormat:@"%d",likeCount];
        [self.api likeShout:applicationUserName :cellShout.shoutId];
        cellShout.isLikedByUser = YES;
    }
    NSLog(@"%@",applicationUserName);
}

- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    //NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        
    }
    
    
}
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    //NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
        
        
        
    }
    
}



@end
