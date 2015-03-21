//
//  ViewController.m
//  Misfire
//
//  Created by Jake Sutton on 2/16/15.
//  Copyright (c) 2015 Jake Sutton. All rights reserved.
//

#import "ViewController.h"
#import "TinderRootClient.h"
#import "AppDelegate.h"

@interface ViewController ()
{
    TinderRootClient *client;
    NSString *facebookToken, *facebookID;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    
    FBSession *session = [[FBSession alloc] initWithAppID:@"1614464005457920" permissions:nil defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
    
    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        facebookToken = [session accessTokenData].accessToken;
        
        NSLog(@"openWithCompletionHandler");
        
        
        
        if ([session isOpen]) {
            NSLog(@"session is open");
        }
    }];
    
    
    
    facebookID = @"1328755925";
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createConnection:(id)sender {
    client = [[TinderRootClient alloc] initWithFacebookData:facebookToken facebookID:facebookID];
    [client.connectionFeedBackOutlets addObject:self];
    [client authenticate];
    NSLog(@"connection created!");
    
    
}

- (IBAction)fetchUpdates:(id)sender {
    [client fetchUpdates];
    
}

- (IBAction)loadGUI:(id)sender {
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 300, 400, 400)];
    
    if (client.images.count > 0) {
        [imgview setImage:client.images[0]];
    }
    
    [imgview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgview];
    
    if (client.fullName) {
        self.connectionSuccessLabel.text = @"Success!";
        self.accountNameLabel.text = client.fullName;
    }
}


@end
