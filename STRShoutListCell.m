//
//  STRShoutListCell.m
//  Shouter
//
//  Created by Kendall Foley on 3/6/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRShoutListCell.h"
#import "STRShouterAPI.h"

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
       
        UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}

- (void) initCell{
    
    self.api = [[STRShouterAPI alloc] init];
    [self.api setDelegate:self];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)likeButtonPressed:(id)sender {
    
    [self.api likeShout:@"username" :cellShout.shoutId];
    NSUInteger count = cellShout.likeCount;
    count++;
    likeCountLabel.text = [NSString stringWithFormat:@"%u",count];
    NSLog(@"like");
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 1
    NSLog(@"handlePan");
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current centre location
        originalCenter = self.center;
    }
    
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width / 2;
        
    }
    
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!deleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
    }
}

- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {
    
        NSLog(@"on like return");
        
    }
    
    
}
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception{
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.");
    }
    else {}
    
}

@end
