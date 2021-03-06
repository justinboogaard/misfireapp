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
    NSString *last_fetch;
}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    
    self.nameLabel.hidden = YES;

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
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)createConnection:(id)sender {
//    facebookToken = [[FBSession activeSession] accessTokenData].accessToken;
//    client = [[TinderRootClient alloc] initWithFacebookData:facebookToken facebookID:facebookID];
//    [client.connectionFeedBackOutlets addObject:self];
//    [client authenticate];
//    NSLog(@"connection created!");
//
//}

- (IBAction)fetchUpdates:(id)sender {
    
    if (last_fetch == NULL){
        NSLog(@"Last ping time: %@", client.ping_time);
        last_fetch = client.ping_time;
    } else {
        NSLog(@"Last ping time: %@", last_fetch);
    }

     [client sendRequestToUrl:@"updates" withPayload:[NSString stringWithFormat:@"{\"last_activity_date\": \"%@\"}", last_fetch]];
     client.currentConnection = UpdateFetch;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:[NSDate date]];
    last_fetch = formattedDateString;
    NSLog(@"New ping time: %@", last_fetch);
    
}


- (IBAction)sendCuteMessage:(id)sender{
    [client sendRequestToUrl:@"user/matches/530ab27b5899d6107c0000d653dca78a404a4e4a53e6831a" withPayload:@"{\"message\": \"This cuddly wuddly message proves that it's working.\"}"];
    
    NSLog(@"TinderTokenFromSendCuteMessage: %@", client.api_token);
}

//- (IBAction)getRecs:(id) sender{
//    [client sendRequestToUrl:@"recs" withPayload:@"{\"limit\": 10 }"];
//    client.currentConnection = GetRecs;
//}

- (IBAction)makeFriends:(id) sender{

    if (client.recArray.count < 2){
        [client sendRequestToUrl:@"recs" withPayload:@"{\"limit\": 10 }"];
        client.currentConnection = GetRecs;
        
    } else{
        NSLog(@"recArray: %@", [[client.recArray objectAtIndex:0] objectForKey:@"id"]);
            NSLog(@"making friends with %@", [[client.recArray objectAtIndex:0] objectForKey:@"id"]);
            [client sendRequestToUrl:[NSString stringWithFormat:@"like/%@", [[client.recArray objectAtIndex:0] objectForKey:@"id"]]];
        
            client.currentConnection = MakeFriends;
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 600, 200, 200)];
        [imgview setImage:[[client.recArray objectAtIndex:1] objectForKey:@"picture"]];
        [imgview setContentMode:UIViewContentModeScaleAspectFill];
        [imgview setCenter:self.view.center];
        [self.view addSubview:imgview];
        [self.nameLabel setText:[[client.recArray objectAtIndex:1] objectForKey:@"firstName"]];
        [client.recArray removeObject:client.recArray.firstObject];
        
        
    }
}

- (IBAction)skip:(id)sender{
    [client.recArray removeObject:client.recArray.firstObject];
    client.currentConnection = MakeFriends;
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 600, 200, 200)];
    [imgview setImage:[[client.recArray objectAtIndex:0] objectForKey:@"picture"]];
    [imgview setContentMode:UIViewContentModeScaleAspectFill];
    [imgview setCenter:self.view.center];
    [self.view addSubview:imgview];
    [self.nameLabel setText:[[client.recArray objectAtIndex:0] objectForKey:@"firstName"]];
}

////- (IBAction)loadGUI:(id)sender {
////    
////    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(00, 300, 400, 400)];
////    
////    if (client.images.count > 0) {
////        [imgview setImage:client.images[0]];
////    }
////    
////    [imgview setContentMode:UIViewContentModeScaleAspectFit];
////    [self.view addSubview:imgview];
////    
////    if (client.fullName) {
////        self.connectionSuccessLabel.text = @"Success!";
////        self.accountNameLabel.text = client.fullName;
////    }
////    
////    
////
//}

// PRAGMA MARK - FBLoginViewDelegate

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Logged In");
    
    //super sketchy way of getting rid of FB Login view
    loginView.hidden = YES;

    
    NSLog(@"removed the loginView");
    facebookToken = [[FBSession activeSession] accessTokenData].accessToken;
    client = [[TinderRootClient alloc] initWithFacebookData:facebookToken facebookID:facebookID];
    client.myView = self;
    [client.connectionFeedBackOutlets addObject:self];
    [client authenticate];
    NSLog(@"connection created!");

    
}

- (void) loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"Logged Out");
    [[FBSession activeSession] closeAndClearTokenInformation];
}

@end
