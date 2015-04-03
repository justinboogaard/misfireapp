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

- (id)initWithMessage:(NSString *)messageText from:(NSString *)personFrom atTime:(NSString *)timestamp {
    if (self = [super init]) {
        self.messageText = messageText;
        self.personFrom = personFrom;
        self.timestamp = timestamp;
    }
    return self;
}

@end
