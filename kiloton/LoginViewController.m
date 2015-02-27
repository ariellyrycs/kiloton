//
//  ViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/23/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistrationViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+RoundersCorners.h"


@interface LoginViewController () <FBLoginViewDelegate>

- (void)getInfo;
@end

static NSString * userModelName = @"UserModel";
static NSString * sprintModelName = @"SprintModel";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileStoryboard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SignInWithFaceBook:(id)sender {
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         if(!error){
             [self getInfo];
         } else {
             NSLog(@"It couldn't sign in");
         }
     }];
}

- (NSManagedObjectContext *) managedObjectContext {
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void)getInfo {
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        if (!error) {
            NSManagedObjectContext *context = [self managedObjectContext];
            UserModel *newList = [NSEntityDescription insertNewObjectForEntityForName:userModelName inManagedObjectContext:context];
            newList.name = user[@"name"];
            newList.accessToken = self.getToken;
            newList.idProfile = user.objectID;
            NSError *error;
            if(![[self managedObjectContext] save:&error]) {
                NSLog(@"Error %@",error);
            }
            [self performSegueWithIdentifier:@"showProfileConfig" sender:nil];
        }
    }];
}

- (NSString*) getToken {
    return FBSession.activeSession.accessTokenData.accessToken;
}
@end