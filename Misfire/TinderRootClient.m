//
//  TinderRootClient.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "TinderRootClient.h"


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
        self.misfireConvoArray = [[NSMutableArray alloc] init];
        self.recArray = [[NSMutableArray alloc] init];
        self.misfirePair = [[NSMutableArray alloc] init];
    
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
    if (self.responseData) {
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
            NSLog(@"Fetched updates");
            
           //This may need to move to the get recs function or higher up the tree
            
            for (id conversationDictionary in jsonDictionary[@"matches"]){
                NSDictionary *messageDict = conversationDictionary[@"messages"];
                NSLog(@"self.misfireConvoArray.count = %lu", (unsigned long)self.misfireConvoArray.count);
                for (int x = 0; x < self.misfireConvoArray.count; x++) {
                    MisfireConvo *convo = [self.misfireConvoArray objectAtIndex:x];
                    NSLog(@"convo is %@", convo.matchID);
                    [convo parseDict:messageDict];
                    NSLog(@"end of connectionDidLoad");
                }
            }
            
            //self.ping_time =
            
        } else if (self.currentConnection == GetRecs){
            //get recs
            
            NSLog(@"Got recs");
            
            for (id element in jsonDictionary[@"results"]) {
                
                NSMutableArray *tempImageArray = [NSMutableArray new];
                for (id newElement in element[@"photos"]) {
                    NSString *path = newElement[@"url"];
                    NSURL *url = [NSURL URLWithString:path];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    [tempImageArray addObject:img];
                }
                
                NSString *userId = element[@"_id"];
                NSString *userName = element[@"name"];
                
                NSMutableDictionary *userDictionary =[[NSMutableDictionary alloc] init];
                [userDictionary setObject:userId forKey:@"id"];
                [userDictionary setObject:userName forKey:@"firstName"];
                [userDictionary setObject:tempImageArray.firstObject forKey:@"picture"];
                [self.recArray addObject:userDictionary];
                NSLog(@"logging user with id %@", [[self.recArray lastObject] objectForKey:@"id"]);
            }
            
            
            
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 600, 200, 200)];
            [imgview setImage:[[self.recArray objectAtIndex:0] objectForKey:@"picture"]];
            [imgview setContentMode:UIViewContentModeScaleAspectFill];
            [self.myView.view addSubview:imgview];
            [imgview setCenter:self.myView.view.center];
            [self.myView.nameLabel setText:[[self.recArray objectAtIndex:0] objectForKey:@"firstName"]];
            NSLog(@"the name is %@",[[self.recArray objectAtIndex:0] objectForKey:@"firstName"]);
            self.myView.nameLabel.hidden = NO;
            self.myView.instructionText.hidden = YES;
        }
        
        

        else if (self.currentConnection == MakeFriends){
            

            if ([[jsonDictionary objectForKey:@"match"] isKindOfClass:[NSNumber class]]) {
                NSLog(@"no match here");
                
                //remove the object from the rec array that we just checked to see if there was a match
                [self.recArray removeObject:self.recArray.firstObject];
            }
            else if ((jsonDictionary[@"match"][@"_id"])) {
                    NSString *matchID = (jsonDictionary[@"match"][@"_id"]);
                    NSLog(@"There was a match and the id is %@", matchID);
                
                    [self.misfirePair addObject:self.recArray.firstObject];
                
               
            
                NSLog(@"the misfire pair array just added %@", [[self.misfirePair objectAtIndex:0] objectForKey:@"firstName"]);
                
                if (self.misfirePair.count == 1 ){
                    UIImageView *matchview = [[UIImageView alloc] initWithFrame:CGRectMake(30, 75, 100, 100)];
                    [matchview setImage:[[self.misfirePair objectAtIndex:0] objectForKey:@"picture"]];
                    [matchview setContentMode:UIViewContentModeScaleAspectFill];
                    [self.myView.view addSubview:matchview];
                    
                }
                    if (self.misfirePair.count == 2) {
                        NSLog(@"there are two match id's in the pair array so we're gonna initialize a new convo");
                        MisfireConvo *newConvo = [[MisfireConvo alloc] initWithUniqueId:(@"%@ and %@", [[self.misfirePair objectAtIndex:0] objectForKey:@"firstName"], [[self.misfirePair objectAtIndex:1] objectForKey:@"firstName"]) withPerson:([self.misfirePair objectAtIndex:0]) andPerson:([self.misfirePair objectAtIndex:1])];
                        newConvo.myClient = self;
                        [self.misfireConvoArray addObject:newConvo];
                        
                        MisfireConvoViewController *viewController = [[MisfireConvoViewController alloc] init];

                        
                        viewController.convoData = newConvo;
                        viewController.myMasterViewController = self.myView;
                        
                   
                        
                        [self.myView presentViewController:viewController animated:YES completion:nil];
                        
                        [self.misfirePair removeAllObjects];
                        
                        
                    }
                
                //remove the object from the rec array that we just checked to see if there was a match
                [self.recArray removeObject:self.recArray.firstObject];

            } else {
                    NSLog(@"something bad happened when trying to make a match");
                }
            
            
        }

        
        self.responseData = nil;
        if (tinderToken == NULL){
            tinderToken = self.api_token;
        }
        NSLog(@"done loading");
        
    }
}




@end
