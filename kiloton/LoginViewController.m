//
//  ViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/23/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController () <FBLoginViewDelegate>
- (NSManagedObjectContext *) managedObjectContext;
- (void)getInfo;
- (void)changeToUserProfileStoryboard;
@end

static NSString *userModelName = @"UserModel";

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
            [self performSelector:@selector(changeToUserProfileStoryboard) withObject:nil afterDelay:.0];
        }
    }];
}

- (void)changeToUserProfileStoryboard {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    UserProfileViewController *profileViewController = [self.profileStoryboard instantiateViewControllerWithIdentifier:@"profileViewController"];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:appDelegate.window cache:NO];
        appDelegate.window.rootViewController = profileViewController;
    }];
}

- (NSString*) getToken {
    return FBSession.activeSession.accessTokenData.accessToken;
}


@end
