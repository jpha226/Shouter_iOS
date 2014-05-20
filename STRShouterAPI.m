//
//  STRShouterAPI.m
//  Shouter
//
//  Created by Kendall Foley on 1/27/14.
//  Copyright (c) 2014 Shouter. All rights reserved.
//

#import "STRShouterAPI.h"
#import "STRShout.h"

@implementation STRShouterAPI

@synthesize delegate;

/*- (void) setDelegate: (id<ShouterAPIDelegate>) d
{
    self.delegate = d;
}*/

- (void) registerUser: (NSString*) userName :(NSString*) password :(NSString*) passwordConfirm
{
    NSString *path = @"/api/user/create?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    [restCallString appendString:@"&password="];
    [restCallString appendString:password];
    [restCallString appendString:@"&passwordConfirm="];
    [restCallString appendString:passwordConfirm];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onRegistrationReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}

- (void)postShout:(STRShout *)message
{
    NSString *path = @"/api/shout/create?devKey=sh0ut3r&";
    NSLog(@"post shout lat: %@",message.shoutLatitude);
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSMutableString *bodyData = [[NSMutableString alloc] initWithString:@"userName="];
    
    [bodyData appendString:message.shoutUserName];
    [bodyData appendString:@"&message="];
    [bodyData appendString:message.shoutMessage];
    [bodyData appendString:@"&latitude="];
    [bodyData appendString:message.shoutLatitude];
    [bodyData appendString:@"&longitude="];
    [bodyData appendString:message.shoutLongitude];
    [bodyData appendString:@"&parentId="];
    [bodyData appendString:message.parentId];
    
    
    [restRequest setHTTPMethod:@"POST"];
    [restRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onPostShoutReturn:self :data :nil];
            
        }
    }];
    
    
}

- (NSMutableArray*) getShout: (NSString*) userName :(NSString*) latitude :(NSString*) longitude
{
    NSString *path = @"/api/shout/search?devKey=sh0ut3r&";
   NSLog(@"get shout lat: %@",latitude);
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"latitude="];
    [restCallString appendString:latitude];
    [restCallString appendString:@"&longitude="];
    [restCallString appendString:longitude];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
          
            [self.delegate onGetShoutReturn:self :data :nil];
            
        }
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    return self.shoutList;
}

- (void) postComment: (STRShout*) message
{
    NSString *path = @"/api/shout/comment/create?devKey=sh0ut3r";
    
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSMutableString *bodyData = [[NSMutableString alloc] initWithString:@"&userName="];
    
    [bodyData appendString:message.shoutUserName];
    [bodyData appendString:@"&message="];
    [bodyData appendString:message.shoutMessage];
    [bodyData appendString:@"&shoutId="];
    [bodyData appendString:message.parentId];
    
    
    [restRequest setHTTPMethod:@"POST"];
    [restRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onPostCommentReturn:self :data :nil];
        }
    }];
    
}

- (NSMutableArray*) getComment: (NSString*) userName :(NSString*) parentID
{
    NSString *path = @"/api/shout/comment/search?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&shoutId="];
    [restCallString appendString:parentID];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
   
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
           
            [self.delegate onGetCommentReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    return self.shoutList;
}

- (void) likeShout: (NSString*) userName :(NSString*) shoutID{
    
    NSString *path = @"/api/shout/like?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&shoutId="];
    [restCallString appendString:shoutID];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
           
            [self.delegate onShoutLikeReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}
- (void) unLikeShout: (NSString*) userName :(NSString*) shoutID{
    
    NSString *path = @"/api/shout/unlike?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&shoutId="];
    [restCallString appendString:shoutID];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onShoutUnLikeReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}
- (void) upadateUser: (NSString*) userName{
    
    NSString *path = @"/api/user/update?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            [self.delegate onUpdateUserReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}
- (void) userAuthenticate: (NSString*) userName :(NSString*) passWord{
    NSLog(@"authy");
    NSString *path = @"/api/user/authenticate?devKey=sh0ut3r";
    NSLog(@"authenticate");
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&password="];
    [restCallString appendString:passWord];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onUserAuthenticateReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}
- (void) userBlock: (NSString*) userName :(NSString*) blockedUserName{
    
    NSString *path = @"/api/user/block?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&blockedUserName="];
    [restCallString appendString:blockedUserName];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onUserBlockReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}
- (void) userUnBlock: (NSString*) userName :(NSString*) blockedUserName{
    
    NSString *path = @"/api/user/unblock?devKey=sh0ut3r";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouter-dev.elasticbeanstalk.com"];
    [restCallString appendString:path];
    [restCallString appendString:@"&blockedUserName="];
    [restCallString appendString:blockedUserName];
    [restCallString appendString:@"&userName="];
    [restCallString appendString:userName];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            
            [self.delegate onUserUnBlockReturn:self :data :nil];
            
        }
        
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.returnData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    [self.returnData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    connection = nil;
    self.returnData = nil;
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
}

@end
