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
    NSString *tinderFuckingToken;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.center = self.view.center;
    [self.view addSubview:loginView];

    FBSession *session = [[FBSession alloc] initWithAppID:@"464891386855067" permissions:@[@"basic_info",@"email",@"public_profile",@"user_about_me", @"user_activities",@"user_birthday",@"user_education_history",@"user_friends",@"user_interests",@"user_likes",@"user_location",@"user_photos",@"user_relationship_details"] defaultAudience:FBSessionDefaultAudienceEveryone urlSchemeSuffix:nil tokenCacheStrategy:nil];
    
    
    //get ID
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 facebookID = user.objectID;
             }
         }];
    }
    
    
    
    
    
    [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        if (error != nil) {
            NSLog(@"%@", error);
        }
        
        facebookToken = [session accessTokenData].accessToken;
        
        NSLog(@"openWithCompletionHandler");
        
        if ([session isOpen]) {
            NSLog(@"session is open");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createConnection:(id)sender {
    facebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    client = [[TinderRootClient alloc] initWithFacebookData:facebookToken facebookID:facebookID];
    [client.connectionFeedBackOutlets addObject:self];
    [client authenticate];
    NSLog(@"connection created!");

}

- (IBAction)fetchUpdates:(id)sender {
     [client sendRequestToUrl:@"updates" withPayload:@"{\"last_activity_date\": \"0\"}"];
    
}

- (IBAction)sendCuteMessage:(id)sender{
    [client sendRequestToUrl:@"user/matches/530ab27b5899d6107c0000d653dca78a404a4e4a53e6831a" withPayload:@"{\"message\": \"This is a cute test message for a hack we are trying to build for the women of Tinder.\"}"];
    
    NSLog(@"TinderTokenFromSendCuteMessage: %@", client.api_token);
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


// PRAGMA MARK - FBLoginViewDelegate

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Logged In");
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"Logged Out");
    [[FBSession activeSession] closeAndClearTokenInformation];
}

@end
