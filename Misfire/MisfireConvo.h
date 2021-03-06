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
@class Message;

@interface MisfireConvo : NSObject

@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSMutableDictionary *person1;
@property (nonatomic, strong) NSMutableDictionary *person2;
@property (nonatomic, strong) NSMutableArray *convoLog;
@property (nonatomic, strong) TinderRootClient *myClient;
@property (nonatomic, strong) Message *oldestMessage;
@property (nonatomic, strong) NSString *oldestTimestamp;

- (id) initWithUniqueId:(NSString *)matchID withPerson:(NSMutableDictionary *)person1 andPerson:(NSMutableDictionary *)person2;
- (void) relayMessage: (Message *)newMessage;
- (void) addMessage: (Message *)message;
- (void) parseDict:(NSDictionary *)updatedSDict;

@end

