//
//  SharedManager.h
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject {
    NSMutableArray *roots, *guests, *conversations, *relays;
}

@property (nonatomic, retain) NSMutableArray *roots;
@property (nonatomic, retain) NSMutableArray *guests;
@property (nonatomic, retain) NSMutableArray *conversations;
@property (nonatomic, retain) NSMutableArray *relays;

+ (id)sharedManager;

@end
