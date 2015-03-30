//
//  NSObject+Message.m
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "Message.h"

@interface Message ()
{
    Message *message;
}
@end

@implementation Message

- (id)initWithMessage:(NSString *)messageText to:(id)personFrom atTime:(id)timestamp {
    if (self = [super init]) {
        
        self.messageText = messageText;
        self.personFrom = personFrom;
        self.timestamp = timestamp;
    }
    return self;
}

@end
