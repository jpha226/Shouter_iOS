//
//  STRShouterAPI.h
//  Shouter
//
//  Created by Kendall Foley on 1/27/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STRShout.h"


@protocol ShouterAPIDelegate;

@interface STRShouterAPI : NSObject

@property (retain, nonatomic) id <ShouterAPIDelegate> delegate;
@property (nonatomic) NSMutableArray *shoutList;
@property NSURLConnection *currentConnection;
@property (retain, nonatomic) NSMutableData *returnData;
@property NSURLConnection *connection;

- (void) postShout:(STRShout *)message;
- (void) register: (NSString*) phoneID :(NSString*) first :(NSString*) last :(NSString*) regID;
- (NSMutableArray*) getShout: (NSString*) latitude :(NSString*) longitude;
- (NSMutableArray*) getComment: (NSString*) parentID;
- (void) postComment: (STRShout*) message;
- (NSMutableArray*) getShoutList;

@end


@protocol ShouterAPIDelegate <NSObject>
- (NSMutableArray*) onGetShoutReturn:(STRShouterAPI*)api :(NSMutableData*)data :(NSException*)exception;
- (void) onPostShoutReturn:(STRShouterAPI*)api :(NSMutableData*) data :(NSException*)exception;
- (NSMutableArray*) onGetCommentReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception;
- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSMutableData*)data :(NSException*)exception;
- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception;


@end
