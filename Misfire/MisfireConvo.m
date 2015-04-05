//
//  NSObject+MisfireConvo.m
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "MisfireConvo.h"



@implementation MisfireConvo

- (id) initWithUniqueId:(NSString *)matchID withPerson: (NSMutableDictionary *)person1 andPerson: (NSMutableDictionary *)person2{
    if ((self = [super init])) {
        self.matchID = matchID;
        self.person1 = person1;
        self.person2 = person2;
        self.convoLog = [[NSMutableArray alloc] init];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestTimestamp = @"0";
    }
    
    return self;
}

//RelayMessage is called by the if statements of parseDict, parseDict will process the JSonDictionary that is handed to it, then depending on the id of who sent it, relay that message to the other person and save it in our conversation array
//TODO i may need to add a check in the current conversation, because the JSONDict that fetchUpdates calls might not always be up to date
- (void) relayMessage: (Message *)message {
    
    NSLog(@"the oldest timestamp is %@",self.oldestTimestamp);
    NSLog(@"the messages timestamp is %@", message.timestamp);
    if (([message.personFrom isEqualToString: [self.person1 objectForKey:@"matchID"]]) && ([message.timestamp integerValue] > [self.oldestTimestamp integerValue])){
        [self.myClient sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", [self.person2 objectForKey:@"matchID"]] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
        NSLog(@"the message had a bigger timestamp");
        NSLog(@"message sent!");
        [self addMessage:message];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestTimestamp = self.oldestMessage.timestamp;
    } else if ([message.personFrom isEqualToString: [self.person2 objectForKey:@"matchID"]] && ([message.timestamp integerValue] > [self.oldestTimestamp integerValue])){
        [self.myClient sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", [self.person1 objectForKey:@"matchID"]] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
        NSLog(@"the message had a smaller timestamp");
        [self addMessage:message];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestTimestamp = self.oldestMessage.timestamp;
    } else {
        NSLog(@"Something bad happened in the relay message function");
    }
    NSLog(@"this is my covoLog %@:", self.convoLog);
}

//This adds new messages to the conversation array, which will be called by the UI to auto populate the converastion
- (void) addMessage:(Message *)message {
    //initialization needed to be broader, put it into initialization function 
    [self.convoLog addObject:message];
    NSLog(@"ConvoLog count = %lu", (unsigned long)self.convoLog.count);
}

//something that tells the convo to update itself
- (void) parseDict:(NSDictionary *)updatedDict{
    //for loop
    
    //THIS IS A BIG DEAL: I'm parsing the data to look for matchID NOT from because when i send the message later I'll be sending it to the MATCH ID. the MatchID IS the from.
    
    for (id element in updatedDict) {
        NSString *from = element[@"match_id"];
        NSString *timestamp = element[@"timestamp"];
        NSString *messageText = element[@"message"];
        
        NSLog(@"From = %@, timestamp =%@ and messageText = %@", from, timestamp, messageText);
        if ([from isEqualToString:[self.person1 objectForKey:@"matchID"]]) {
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            NSLog(@"*******");
            NSLog(@"Message is : %@", newMessage.messageText);
            [self relayMessage:newMessage];
        } else if ([from isEqualToString:[self.person2 objectForKey:@"matchID"]]) {
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            [self relayMessage:newMessage];
        } else {
            NSLog(@"if loop did run");
        }
       
    }
}
@end
