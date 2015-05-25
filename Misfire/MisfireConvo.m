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
        self.person1Name = [self.person1 objectForKey:@"firstName"];
        self.person2 = person2;
        self.person2Name = [self.person2 objectForKey:@"firstName"];
        self.convoLog = [[NSMutableArray alloc] init];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:0];
        
        
        /**
         *  Create avatar images once.
         *
         *  Be sure to create your avatars one time and reuse them for good performance.
         *
         *  If you are not using avatars, ignore this.
         */
        
        
        
        self.person1Avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage: (UIImage*)[self.person1 objectForKey:@"picture"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        self.person2Avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:(UIImage*)[self.person2 objectForKey:@"picture"]
                                                                                       diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
        
        /**
         *  Create message bubble images objects.
         *
         *  Be sure to create your bubble images one time and reuse them for good performance.
         *
         */
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        
        self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
        self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    }
    
    return self;
}

//RelayMessage is called by the if statements of parseDict, parseDict will process the JSonDictionary that is handed to it, then depending on the id of who sent it, relay that message to the other person and save it in our conversation array
//TODO i may need to add a check in the current conversation, because the JSONDict that fetchUpdates calls might not always be up to date
- (void) relayMessage: (JSQMessage *)message withMatchID: (NSString *)matchID{
    
    NSLog(@"the oldest timestamp is %@",self.oldestDate);
    NSLog(@"the messages timestamp is %@", message.date);
    if (([message.senderId isEqualToString: [self.person1 objectForKey:@"id"]]) && ([message.date laterDate:self.oldestDate] == message.date) && (message.date != self.oldestDate)){
        [self.myClient sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", matchID] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.text]];
        NSLog(@"the message is newer, it's timestamp is bigger");
        NSLog(@"message sent!");
        [self addMessage:message];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestDate = self.oldestMessage.date;
    } else if ([message.senderId isEqualToString: [self.person2 objectForKey:@"id"]] && ([message.date laterDate:self.oldestDate] == message.date) && (message.date != self.oldestDate)){
        [self.myClient sendRequestToUrl:[NSString stringWithFormat:@"user/matches/%@", matchID] withPayload:[NSString stringWithFormat:@"{\"message\": \"%@\"}",message.text]];
        NSLog(@"the message had a smaller timestamp");
        [self addMessage:message];
        self.oldestMessage = self.convoLog.lastObject;
        self.oldestDate = self.oldestMessage.date;
    } else {
        NSLog(@"Something bad happened in the relay message function");
    }
    NSLog(@"this is my covoLog %@:", self.convoLog);
}

//This adds new messages to the conversation array, which will be called by the UI to auto populate the converastion
- (void) addMessage:(JSQMessage *)message {
    //initialization needed to be broader, put it into initialization function 
    [self.convoLog addObject:message];

    NSLog(@"ConvoLog count = %lu", (unsigned long)self.convoLog.count);
}

//THE BELOW IS TEST CODE ONLY

- (void) sendFakeMessage {
NSLog(@"making a second fake message");
JSQMessage *fakeMessage = [[JSQMessage alloc] initWithSenderId:self.person1Name senderDisplayName:self.person1Name date:[NSDate date] text:@"I'm a fake"];
//add fake message to newConvo
[self.convoLog addObject:fakeMessage];
NSLog(@"The last message added to the convoLog of %@ is %@", self.matchID, [self.convoLog.lastObject text]);
    NSLog(@"The current length of the convoLog is %lu", (unsigned long)self.convoLog.count);
}

//THE ABOVE IS TEST CODE ONLY

//something that tells the convo to update itself
- (void) parseDict:(NSDictionary *)updatedDict{
    //for loop
    
    //THIS IS A BIG DEAL: I'm parsing the data to look for matchID NOT from because when i send the message later I'll be sending it to the MATCH ID. the MatchID IS the from.
    
    for (id element in updatedDict) {
        
        NSTimeInterval cal = [element[@"timestamp"] doubleValue];
        NSString *from = element[@"from"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:cal];
        NSString *messageText = element[@"message"];
        
        
        
        NSLog(@"From = %@, timestamp = %@ and messageText = %@", from, date, messageText);
        if ([from isEqualToString:[self.person1 objectForKey:@"id"]]) {
            JSQMessage *newMessage = [[JSQMessage alloc] initWithSenderId:from senderDisplayName:self.person1Name date:date text:messageText];
            NSLog(@"*******");
            NSLog(@"Message is : %@", newMessage.text);
            [self relayMessage:newMessage withMatchID:[self.person2 objectForKey:@"matchID"]];
        } else if ([from isEqualToString:[self.person2 objectForKey:@"id"]]) {
            JSQMessage *newMessage = [[JSQMessage alloc] initWithSenderId:from senderDisplayName:self.person2Name date:date text:messageText];
            [self relayMessage:newMessage withMatchID:[self.person1 objectForKey:@"matchID"]];
        } else {
            NSLog(@"if loop did run");
        }
       
    }
}
@end
