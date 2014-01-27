//
//  STRCommentViewController.h
//  Shouter
//
//  Created by Aimee Goffinet on 1/23/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STRShout.h"

@interface STRCommentViewController : UITableViewController

@property NSMutableArray *commentList;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property STRShout *headerShout;

@end
