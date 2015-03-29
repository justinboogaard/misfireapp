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


//RelayMessageToOther
- (void) relayMessage: (Message *)message {
    if (message.personFrom == self.person1){
        [client sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", self.person2] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
    } else {
        [client sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", self.person1] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.messageText]];
    }
}

//AddMessageToConvoArray
- (void) addMessage:(Message *)message {
    [self.convoLog addObject:message];
}

//something that tells the convo to update itself
- (void) parseDict:(NSDictionary *)updatedDict{
    //for loop
    for (id element in updatedDict[@"messages"][@"from"]) {
        NSString *from = element[@"from"];
        NSString *timestamp = element[@"timestamp"];
        NSString *messageText = element[@"message"];
                                                
        if (from == self.person1) {
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            [self addMessage:newMessage];
            [self relayMessage:newMessage];
        } else if (from == self.person2) {
            Message *newMessage = [[Message alloc] initWithMessage:messageText from:from atTime:timestamp];
            [self addMessage:newMessage];
            [self relayMessage:newMessage];
        }

    }
}
@end
