//
//  ViewController.h
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *updatesButton;
@property (weak, nonatomic) IBOutlet UIButton *connectionButton;
@property (weak, nonatomic) IBOutlet UIButton *loadDataButton;
@property (weak, nonatomic) IBOutlet UIButton *sendCuteMessageButton;

@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionSuccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectionNameLabel;


- (IBAction)createConnection:(id)sender;
- (IBAction)fetchUpdates:(id)sender;
- (IBAction)loadGUI:(id)sender;
- (IBAction)sendCuteMessage:(id)sender;


@end

