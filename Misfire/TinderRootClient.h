//
//  TinderRootClient.h
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface TinderRootClient : NSObject

typedef enum
{
    Authentication = 1,
    UpdateFetch
} Connections;

#pragma mark Basic MetaData

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *facebookToken;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *tinderFuckingToken;

@property (strong, nonatomic) NSMutableArray *connectionFeedBackOutlets;

#pragma mark Authentication Data

@property (strong, nonatomic) NSString *authToken;
@property (strong, nonatomic) NSDictionary *authOutputJsonData;

@property Connections currentConnection;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;

#pragma mark Basic Information

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *_id;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *birth_date;
@property (strong, nonatomic) NSString *gender_filter;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *create_date;
@property (strong, nonatomic) NSString *api_token;

@property (strong, nonatomic) NSArray *images;

#pragma mark Constructors

- (id) initWithAuthToken: (NSString *) authToken;
- (id) initWithFacebookData: (NSString *) facebookToken facebookID:(NSString *) facebookID;
- (id) sendCuteMessage;
- (void) sendRequestToUrl:(NSString *)address withPayload:(NSString *)payload forAuth:(NSString *)api_token;

#pragma mark Additional Methods

- (bool) authenticate;


@end
