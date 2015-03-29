//
//  NSObject+Message.h
//  Misfire
//
//  Created by Justin Boogaard on 3/28/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *personFrom;
@property (nonatomic, strong) NSString *messageText;

- (id) initWithMessage:(NSString*)messageText from:personFrom atTime:timestamp;

@end
