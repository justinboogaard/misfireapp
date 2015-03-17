//
//  SharedManager.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

@synthesize roots;
@synthesize guests;
@synthesize conversations;
@synthesize relays;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static SharedManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        roots = [NSMutableArray new];
        guests = [NSMutableArray new];
        conversations = [NSMutableArray new];
        relays = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
    
}

@end
