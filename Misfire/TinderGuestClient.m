//
//  TinderGuestClient.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "TinderGuestClient.h"

@implementation TinderGuestClient

- (id) initWithAuthToken: (NSString *) authToken
{
    if (self = [super init]) {
        self.authToken = authToken;
    }
    
    return self;
}

@end
