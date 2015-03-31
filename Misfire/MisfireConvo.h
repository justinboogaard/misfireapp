//
//  NSObject+MisfireConvo.h
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "ViewController.h"
#import "TinderRootClient.h"

@class TinderRootClient;

@interface MisfireConvo : NSObject

@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *person1;
@property (nonatomic, strong) NSString *person2;
@property (nonatomic, strong) NSArray *messageString;
@property (nonatomic, strong) NSMutableArray *convoLog;
@property (nonatomic, strong) TinderRootClient *myClient;

- (id) initWithUniqueId:(NSString *)matchID withPerson:(NSString *)person1 andPerson:(NSString *)person2;
- (void) relayMessage: (Message *)newMessage;
- (void) addMessage: (Message *)message;
- (void) parseDict:(NSDictionary *)updatedSDict;

@end

