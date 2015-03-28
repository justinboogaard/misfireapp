//
//  TinderRootClient.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "TinderRootClient.h"

#import <UIKit/UIKit.h>

@interface TinderRootClient ()
{
    NSString *tinderToken;
}
@end


@implementation TinderRootClient

#pragma mark Variables



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
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    //set http method
    [mutableRequest setHTTPMethod:@"POST"];
    
    //set request content type we MUST set this value.
    [mutableRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"Tinder/3.0.4 (iPhone; iOS 7.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    
    //initialize a post data
    NSString *postData = [NSString stringWithFormat:@"{\"facebook_token\":\"%@\",\"facebook_id\":\"%@\"}", self.facebookToken, self.facebookID];
    
    //set post data of request
    [mutableRequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    request = [mutableRequest copy];
    
    NSLog(@"Headers: %@", request.allHTTPHeaderFields);
    NSLog(@"Method: %@", request.HTTPMethod);
    NSLog(@"URL: %@", request.URL.absoluteString);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    self.currentConnection = Authentication;
    
    return true;
}

//generic send to url without a payload (we use this for the like api)
- (void) sendRequestToUrl:(NSString*)address
{
    //initialize new mutable data
    NSMutableData *responseData = [[NSMutableData alloc] init];
    self.responseData = responseData;
    
    //initialize url that is going to be fetched.
    //JUSTIN: this url needs to be modified so that it can take parameters
    NSString *completeAddress = [NSString stringWithFormat:@"https://api.gotinder.com/%@", address];
    NSURL *url = [NSURL URLWithString:completeAddress];
    
    // Create request variable containing our immutable request
    //This could also be a parameter of your method
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a mutable copy of the immutable request and add more headers
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [mutableRequest addValue:[NSString stringWithFormat:@"%@", tinderToken]  forHTTPHeaderField:@"X-Auth-Token"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"Tinder/3.0.4 (iPhone; iOS 7.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    
    NSLog(@"Method: %@", mutableRequest.HTTPMethod);
    NSLog(@"URL: %@", mutableRequest.URL.absoluteString);
    
    // Now set our request variable with an (immutable) copy of the altered request
    request = [mutableRequest copy];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;

    
}

//generic send to url
- (void) sendRequestToUrl:(NSString*)address withPayload:(NSString*)payload
{
    //initialize new mutable data
    NSMutableData *responseData = [[NSMutableData alloc] init];
    self.responseData = responseData;
    
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
    [mutableRequest addValue:[NSString stringWithFormat:@"%@", tinderToken]  forHTTPHeaderField:@"X-Auth-Token"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest addValue:@"Tinder/3.0.4 (iPhone; iOS 7.1; Scale/2.00)" forHTTPHeaderField:@"User-Agent"];
    if(![payload  isEqual: @"false"]){
        [mutableRequest setHTTPBody:[payload dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSLog(@"Method: %@", mutableRequest.HTTPMethod);
    NSLog(@"URL: %@", mutableRequest.URL.absoluteString);
    NSLog(@"Body: %@", [[NSString alloc] initWithData:mutableRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    
    // Now set our request variable with an (immutable) copy of the altered request
    request = [mutableRequest copy];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
}

//- (BOOL) sendMessageToUser:(NSString*)matchID withMessage:(NSString*)message {
//    
//    [self sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", matchID] withPayload:[NSString stringWithFormat:@"{\"messages\":\"%@\"}", message]];
//    
//    return true;
//}


#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    [self.responseData setLength:0];
    NSLog(@"Connection did receive response: %@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Connection received data");
    [self.responseData appendData:data];
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
        self.ping_time=jsonDictionary[@"user"][@"ping_time"];
        
        
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
        
        //self.ping_time =
        
    } else if (self.currentConnection == GetRecs){
        //get recs
        
        NSLog(@"Got recs");
        
        if (self.authOutputJsonData != NULL){
        self.authOutputJsonData = jsonDictionary;
            self.recArray = [[NSMutableArray alloc] init];
        
        for (id element in jsonDictionary[@"results"]) {
            
            NSString *path = element[@"_id"];
            NSLog(@"%@", path);
            [self.recArray addObject:path];
            
//            [self sendRequestToUrl:[NSString stringWithFormat:@"like/%@", path]];
//            self.currentConnection = MakeFriends;
        }
            
        
        
        }
    } else if (self.currentConnection == MakeFriends){
        // MakeFriends connection
        
        self.authOutputJsonData = jsonDictionary;
        if (jsonDictionary[@"match"] == 1){
            NSLog(@"match!");
        } else {
            NSLog(@"no match :(");
        }
        
        if (self.authOutputJsonData == NULL){
            NSLog(@"Output is NULL");
        }
        
        
        
    }
    self.responseData = nil;
    if (tinderToken == NULL){
        tinderToken = self.api_token;
    }
    NSLog(@"done loading");
    
    NSLog(@"-----------------------------------------------------------------------------------------------------------");

}




@end
