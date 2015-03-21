//
//  TinderRootClient.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "TinderRootClient.h"

#import <UIKit/UIKit.h>

@implementation TinderRootClient

#pragma mark Constructors

- (id) initWithAuthToken: (NSString *) authToken
{
    if (self = [super init]) {
        self.authToken = authToken;
    }
    
    return self;
}

- (id) initWithFacebookData: (NSString *) facebookToken facebookID:(NSString *) facebookID
{
    if (self = [super init]) {
        
        self.facebookToken = facebookToken;
        self.facebookID = facebookID;
    }
    
    return self;
}

#pragma mark - Additional Methods

- (bool) authenticate
{
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://api.gotinder.com/auth"];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"{\"facebook_token\":\"%@\",\"facebook_id\":\"%@\"}", self.facebookToken, self.facebookID];
    
    NSLog(self.facebookToken);
    NSLog(self.facebookID);
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Method: %@", request.HTTPMethod);
    NSLog(@"URL: %@", request.URL.absoluteString);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    self.currentConnection = Authentication;
    
    return true;
}

- (bool) fetchUpdates
{
    self.currentConnection = UpdateFetch;
    
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    
    //initialize url that is going to be fetched.
    NSURL *url = [NSURL URLWithString:@"https://api.gotinder.com/updates"];
    
    // Create request variable containing our immutable request
    //This could also be a paramter of your method 
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a mutable copy of the immutable request and add more headers
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest addValue:[NSString stringWithFormat:@"%@", self.api_token]  forHTTPHeaderField:@"X-Auth-Token"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"Tinder/3.0.4 (iPhone; iOS 7.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    NSString *postData = @"{\"last_activity_date\": \"2015-01-06T22:51:57Z\"}";
    [mutableRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Method: %@", mutableRequest.HTTPMethod);
    NSLog(@"URL: %@", mutableRequest.URL.absoluteString);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:mutableRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    
    // Now set our request variable with an (immutable) copy of the altered request
    request = [mutableRequest copy];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;

    [connection start];
    
    return true;
}

- (void) sendRequestToUrl:(NSString*)address withPayload:(NSString*)payload
{
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    
    //initialize url that is going to be fetched.
    //JUSTIN: this url needs to be modified so that it can take parameters
    NSString *completeAddress = [NSString stringWithFormat:@"https://api.gotinder.com/%@", address];
    NSURL *url = [NSURL URLWithString:completeAddress];
    
    // Create request variable containing our immutable request
    //This could also be a parameter of your method
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a mutable copy of the immutable request and add more headers
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest addValue:[NSString stringWithFormat:@"%@", self.api_token]  forHTTPHeaderField:@"X-Auth-Token"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"Tinder/3.0.4 (iPhone; iOS 7.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    if(payload){
        [mutableRequest setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];}
    
    NSLog(@"Method: %@", mutableRequest.HTTPMethod);
    NSLog(@"URL: %@", mutableRequest.URL.absoluteString);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:mutableRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    
    // Now set our request variable with an (immutable) copy of the altered request
    request = [mutableRequest copy];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    [connection start];
    
}

- (BOOL) sendMessageToUser:(NSString*)matchID withMessage:(NSString*)message {
    
   // sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", matchID] withPayload:[NSString stringWithFormat:@"{\"messages\":\"%@\"}", message];
    
    return true;
}


#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
    NSLog(@"Connection did receive response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    NSLog(@"Connection did receive data: %@", data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"connection did finish loading");
    
    NSError __autoreleasing *e = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableContainers error:&e];
    
    NSDictionary *jsonDictionary  = (NSDictionary *) result; //convert to an array
    
    NSLog(@"Dictionary: %@", [jsonDictionary description]);
    
    if (self.currentConnection == Authentication) {
        
        self.authOutputJsonData = jsonDictionary;
        
        self.fullName = jsonDictionary[@"user"][@"full_name"];
        self._id = jsonDictionary[@"user"][@"_id"];
        self.bio = jsonDictionary[@"user"][@"bio"];
        self.birth_date = jsonDictionary[@"user"][@"birth_date"];
        self.gender_filter = jsonDictionary[@"user"][@"gender_filter"];
        self.gender = jsonDictionary[@"user"][@"gender"];
        self.create_date = jsonDictionary[@"user"][@"create_date"];
        self.api_token = jsonDictionary[@"token"];
        
        NSMutableArray *tempImageArray = [NSMutableArray new];
        for (id element in jsonDictionary[@"user"][@"photos"]) {
            NSString *path = element[@"url"];
            
            NSURL *url = [NSURL URLWithString:path];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            [tempImageArray addObject:img];
        }
        
        self.images = tempImageArray;
        
        
    } else  if (self.currentConnection == UpdateFetch){
        // if we have just done an UpdateFetch
        
        NSLog(@"Connection succeeded.");
        
        for (id element in jsonDictionary) {
            NSLog(@"{\"%@\": \"%@\"}", element, jsonDictionary[element]);
        }
        
    }

    self.responseData = nil;
}


@end
