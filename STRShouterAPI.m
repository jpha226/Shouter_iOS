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

- (void) register: (NSString*) phoneID :(NSString*) first :(NSString*) last :(NSString*) regID
{
    NSString *path = @"/api/user/create";
    
    // Start new thread and execute code
    
}

- (void)postShout:(STRShout *)message
{
    NSString *path = @"/api/shout/create";
    
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouterapi-env.elasticbeanstalk.com/shouter"];
    [restCallString appendString:path];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSMutableString *bodyData = [[NSMutableString alloc] initWithString:@"phoneId="];
    
    [bodyData appendString:message.phoneId];
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
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [self.delegate onPostShoutReturn:self :self.returnData :nil];
            
        }
        NSLog(@"%@",connectonError.debugDescription);
    }];
    
    
}

- (NSMutableArray*) getShout: (NSString*) latitude :(NSString*) longitude
{
    NSString *path = @"/api/shout/search";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouterapi-env.elasticbeanstalk.com/shouter"];
    [restCallString appendString:path];
    [restCallString appendString:@"?latitude="];
    [restCallString appendString:latitude];
    [restCallString appendString:@"&longitude="];
    [restCallString appendString:longitude];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    NSLog(@"connect");
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [self.delegate onGetShoutReturn:self :data :nil];
            
        }
        NSLog(@"%@",connectonError.debugDescription);
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    //[self.delegate onGetShoutReturn:self :self.returnData :nil];
    
    return self.shoutList;
}

- (void) postComment: (STRShout*) message
{
    NSString *path = @"/api/shout/comment/create";
    
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouterapi-env.elasticbeanstalk.com/shouter"];
    [restCallString appendString:path];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSMutableURLRequest *restRequest = [NSMutableURLRequest requestWithURL:restURL];
    
    NSMutableString *bodyData = [[NSMutableString alloc] initWithString:@"phoneId="];
    
    [bodyData appendString:message.phoneId];
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
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [self.delegate onPostCommentReturn:self :data :nil];
        }
        NSLog(@"%@",connectonError.debugDescription);
    }];
    
}

- (NSMutableArray*) getComment: (NSString*) parentID
{
    NSString *path = @"/api/shout/comment/search";
    
    // Start new thread and execute search
    // Start new thread and execute code
    NSMutableString *restCallString = [[NSMutableString alloc] initWithString:@"http://shouterapi-env.elasticbeanstalk.com/shouter"];
    [restCallString appendString:path];
    [restCallString appendString:@"?parentId="];
    [restCallString appendString:parentID];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest =[NSURLRequest requestWithURL:restURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    self.returnData = [NSMutableData dataWithCapacity:0];
    NSLog(@"connect");
    //self.connection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    [NSURLConnection sendAsynchronousRequest:restRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectonError){
        
        if(data.length > 0 && connectonError == nil)
        {
            NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",response);
            [self.delegate onGetCommentReturn:self :data :nil];
            
        }
        NSLog(@"%@",connectonError.debugDescription);
    }];
    
    if(!self.connection){
        self.returnData = nil;
    }
    
    //[self.delegate onGetShoutReturn:self :self.returnData :nil];
    
    return self.shoutList;
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
    // do something with the data
    // receivedData is declared as a property elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[self.returnData length]);
    
    self.connection = nil;
    //self.returnData = nil;
}

@end
