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
@property (strong) NSManagedObjectContext *context;
@property (strong) UserModel *userModel;
- (void)getInfo;
@end

static NSString * userModelName = @"UserModel";
static NSString * sprintModelName = @"SprintModel";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileStoryboard = [UIStoryboard storyboardWithName:@"UserProfile" bundle:nil];
    self.context = self.managedObjectContext;
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
            if(![self checkUserExistenceBy:user.objectID]) {
                self.userModel = [NSEntityDescription insertNewObjectForEntityForName:userModelName inManagedObjectContext:self.context];
                self.userModel.name = user[@"name"];
                self.userModel.accessToken = self.getToken;
                self.userModel.idProfile = user.objectID;
                self.userModel.active = [NSNumber numberWithBool:NO];
                NSError *error;
                if(![self.context save:&error]) {
                    NSLog(@"Error %@",error);
                }
            }
            [self performSegueWithIdentifier:@"showProfileConfig" sender:nil];
        }
    }];
}

-(BOOL)checkUserExistenceBy:(NSString *)objectID {
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:userModelName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    UserModel * tmpUserModel;
    if(error) {
        NSLog(@"Error: %@ %@", error, [error debugDescription]);
        return nil;
    }
    for(NSInteger i = 0; i < fetchedObjects.count; i++) {
        tmpUserModel = [fetchedObjects objectAtIndex:i];
        if([tmpUserModel.idProfile isEqualToString: objectID]) {
            self.userModel = tmpUserModel;
            return YES;
        }
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"showProfileConfig"]) {
        RegistrationViewController *registrationVC = segue.destinationViewController;
        registrationVC.context = self.context;
        registrationVC.userModel = self.userModel;
    }
}

- (NSString*) getToken {
    return FBSession.activeSession.accessTokenData.accessToken;
}
@end