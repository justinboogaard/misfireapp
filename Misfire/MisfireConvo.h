//
//  NSObject+MisfireConvo.h
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "TinderRootClient.h"
#import "JSQMessage.h"

@class TinderRootClient;
@class JSQMessage;
@class JSQMessagesAvatarImage;
@class JSQMessagesBubbleImage;

@interface MisfireConvo : NSObject

@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *person1Name;
@property (nonatomic, strong) NSString *person2Name;
@property (nonatomic, strong) NSMutableDictionary *person1;
@property (nonatomic, strong) NSMutableDictionary *person2;
@property (nonatomic, strong) NSMutableArray *convoLog;
@property (nonatomic, strong) TinderRootClient *myClient;
@property (nonatomic, strong) JSQMessage *oldestMessage;
@property (nonatomic, strong) NSDate *oldestDate;
@property (nonatomic, strong) JSQMessagesAvatarImage *person1Avatar;
@property (nonatomic, strong) JSQMessagesAvatarImage *person2Avatar;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;




- (id) initWithUniqueId:(NSString *)matchID withPerson:(NSMutableDictionary *)person1 andPerson:(NSMutableDictionary *)person2;
- (void) relayMessage: (JSQMessage *)newMessage withMatchID: (NSString *)matchID;
- (void) addMessage: (JSQMessage *)message;
- (void) parseDict:(NSDictionary *)updatedSDict;

@end

