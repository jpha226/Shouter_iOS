//
//  STRShoutListCell.m
//  Shouter
//
//  Created by Kendall Foley on 3/6/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRShoutListCell.h"
#import "STRShouterAPI.h"
#import "global.h"

@implementation STRShoutListCell

@synthesize usernameLabel;
@synthesize shoutTimeLabel;
@synthesize likeButton;
@synthesize commentButton;
@synthesize commentCountLabel;
@synthesize likeCountLabel;
@synthesize shoutMessageView;
@synthesize deleteOnDragRelease;
@synthesize originalCenter;
@synthesize cellShout;
@synthesize api;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        //NSLog(@"init with coder");
        
    }
    return self;
}

- (void) initCell{
    
    self.api = [[STRShouterAPI alloc] init];
    //NSLog(@"init cell");
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
}


- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
       
        NSString *shout = [jsonDict objectForKey:@"isLiked"];
        NSLog(@"%@",shout);
    }
    
    
}
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
    
        NSString *shout = [jsonDict objectForKey:@"isLiked"];
        NSLog(@"%@",shout);
    
    }
    
}

@end
