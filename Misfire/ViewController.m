//
//  ViewController.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "ViewController.h"
#import "TinderRootClient.h"

@interface ViewController ()
{
    TinderRootClient *client;
    NSString *facebookToken, *facebookID;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    facebookToken = @"CAAGm0PX4ZCpsBALaed0BPQTxZBFveiBqHrgGoCqmAN7jfVTdNY7k2upZBE7aYlZBv4ZCO0ZAY0une57eWEZCIfvGtDnc3Atp9UWCa1w1lq6C4EnKGXJlZBr8FB1E4tEZBLRWF9YtU6QRxE7G9XpK7VZCZAz8Ixd7pRfZCJNOyNdw15tk9GjClD7LA2MHXWYZAy0M3gY7iZAW1t0QrIn8O0KBvIeZCWZC";
    
    facebookID = @"1807423454";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createConnection:(id)sender {
    client = [[TinderRootClient alloc] initWithFacebookData:facebookToken facebookID:facebookID];
    [client.connectionFeedBackOutlets addObject:self];
    [client authenticate];
    
    
}

- (IBAction)fetchUpdates:(id)sender {
    [client fetchUpdates];
    
}

- (IBAction)loadGUI:(id)sender {
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 300, 400, 400)];
    [imgview setImage:client.images[0]];
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgview];
    
    if (client.fullName) {
        self.connectionSuccessLabel.text = @"Success!";
        self.accountNameLabel.text = client.fullName;
    }
}


@end
