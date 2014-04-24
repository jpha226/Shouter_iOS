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
- (void) registerUser: (NSString*) userName :(NSString*) password :(NSString*) passwordConfirm;
- (NSMutableArray*) getShout: (NSString*) latitude :(NSString*) longitude;
- (NSMutableArray*) getComment: (NSString*) parentID;
- (void) postComment: (STRShout*) message;
- (void) likeShout: (NSString*) userName :(NSString*) shoutID;
- (void) unLikeShout: (NSString*) userName :(NSString*) shoutID;
- (void) upadateUser: (NSString*) userName;
- (void) userAuthenticate: (NSString*) userName :(NSString*) passWord;
- (void) userBlock: (NSString*) userName :(NSString*) blockedUserName;
- (void) userUnBlock: (NSString*) userName :(NSString*) blockedUserName;

@end


@protocol ShouterAPIDelegate <NSObject>
- (NSMutableArray*) onGetShoutReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onPostShoutReturn:(STRShouterAPI*)api :(NSData*) data :(NSException*)exception;
- (NSMutableArray*) onGetCommentReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception;
- (void) onPostCommentReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onRegistrationReturn:(STRShouterAPI*)api :(NSMutableString*)result :(NSException*)exception;
- (void) onShoutLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onShoutUnLikeReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onUpdateUserReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onUserAuthenticateReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onUserBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;
- (void) onUserUnBlockReturn:(STRShouterAPI*)api :(NSData*)data :(NSException*)exception;

@end
