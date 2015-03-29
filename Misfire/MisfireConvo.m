//
//  NSObject+MisfireConvo.m
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "MisfireConvo.h"

@implementation MisfireConvo

- (id) initWithUniqueId:(NSString *)matchID withPerson: (NSString *)person1 andPerson: (NSString *)person2{
    if ((self = [super init])) {
        self.matchID = matchID;
        self.person1 = person1;
        self.person2 = person2;
    }
    
    return self;
}

- (NSString*) receiverOfMessageFrom: (NSString *)sender{
    if (sender == self.person1){
        return self.person2;
    } else {
        return self.person1;
    };
}


@end
