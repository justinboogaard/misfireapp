//
//  MisfireConvoViewController.h
//  Misfire
//
//  Created by Justin Boogaard on 4/10/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MisfireConvo.h"
#import "Message.h"
#import <JSQMessagesViewController.h>
#import "JSQMessages.h"

@class MisfireConvo;
@class ViewController;


@interface MisfireConvoViewController : JSQMessagesViewController


@property (strong, nonatomic) MisfireConvo *convoData;
@property (strong, nonatomic) ViewController *myMasterViewController;
@property (strong, nonatomic) NSString *firstSender;

- (IBAction)fetchUpdates:(id)sender;

@end
