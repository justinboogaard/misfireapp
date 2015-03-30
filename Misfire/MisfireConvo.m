//
//  NSObject+MisfireConvo.m
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "MisfireConvo.h"
#import "TinderRootClient.h"


@interface MisfireConvo ()
{
    TinderRootClient *client;
}

@end

@implementation MisfireConvo

- (id) initWithUniqueId:(NSString *)matchID withPerson: (NSString *)person1 andPerson: (NSString *)person2{
    if ((self = [super init])) {
        self.matchID = matchID;
        self.person1 = person1;
        self.person2 = person2;
    }
    
    return self;
}




//RelayMessage is called by the if statements of parseDict, parseDict will process the JSonDictionary that is handed to it, then depending on the id of who sent it, relay that message to the other person and save it in our conversation array
//TODO i may need to add a check in the current conversation, because the JSONDict that fetchUpdates calls might not always be up to date
- (void) relayMessage: (Message *)message {
    NSLog(@"We got to relay!");
    if (message.personFrom == self.person1){
        [client sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", self.person2] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
    } else {
        [client sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", self.person1] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
    }
}

//This adds new messages to the conversation array, which will be called by the UI to auto populate the converastion
- (void) addMessage:(Message *)message {
    //might have to be broader
    self.convoLog = [[NSMutableArray alloc] init];
    [self.convoLog addObject:message];
    NSLog(@"ConvoLog count = %lu", (unsigned long)self.convoLog.count);
}

//something that tells the convo to update itself
- (void) parseDict:(NSDictionary *)updatedDict{
    //for loop
     NSLog(@"parseDict has been called!");
        NSLog(@"Dictionary being sent is %@", [updatedDict description]);
    //make sure to delete this inialization later
    [self initWithUniqueId:@"12345678999" withPerson:@"53e2eaef56bc143f2230aee2" andPerson:@"Neil"];
  
    for (id element in updatedDict) {
        NSString *from = element[@"from"];
        NSString *timestamp = element[@"timestamp"];
        NSString *messageText = element[@"message"];
        
        NSLog(@"From = %@, timestamp =%@ and messageText = %@", from, timestamp, messageText);
                                                
        if ([from isEqualToString:self.person1]) {
            NSLog(@"we're inside the if loop");
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            NSLog(@"new message has messageText %@", newMessage.messageText);
            [self addMessage:newMessage];
            [self relayMessage:newMessage];
        } else if ([from isEqualToString:self.person2]) {
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            [self addMessage:newMessage];
            [self relayMessage:newMessage];
        } else {
            NSLog(@"if loop did run");
        }
       
    }
}
@end
