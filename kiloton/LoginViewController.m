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
#import "HistoryTableViewController.h"
#import "UserWebserviceModel.h"


@interface LoginViewController () <FBLoginViewDelegate>
@property (strong) NSManagedObjectContext *context;
@property (strong) UserModel *userModel;
@property (strong) UserWebserviceModel *UserWebservice;
- (void)getInfo;
@end

static NSString * userModelName = @"UserModel";
static NSString * sprintModelName = @"SprintModel";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.context = self.managedObjectContext;
    self.UserWebservice = [UserWebserviceModel new];
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
            }
            if(self.userModel.idService) {
                [self syncWithApplication];
            } else {
                [self syncWithWebService];
            }
            NSArray * sprints = [[self.userModel.sprints allObjects] mutableCopy];
            if(sprints.count) {
                self.userModel.active = [NSNumber numberWithBool:YES];
                [self changeStoryboard:@"Main" identifier:@"logedInTabBar"];
            } else {
                [self performSegueWithIdentifier:@"showProfileConfig" sender:nil];
            }
            NSError *error;
            if(![self.context save:&error]) {
                NSLog(@"Error %@",error);
            }
        }
    }];
}

- (void)syncWithWebService {
    [self.UserWebservice checkUserExistance: self.userModel.idProfile
                           withSuccessBlock:^(NSMutableDictionary* responseObject) {
                               if([responseObject[@"exists"]  isEqual: @0]) {
                                   [self saveUsersInWebservice];
                               } else {
                                   [self updateUsersInWebservice];
                               }
                           }
                            andFailureBlock:^(NSError * error){
                                NSLog(@"It couldn't connect with kiloton-webservice, please check your connection: %@, %@", error, error.localizedDescription);
                            }];
}

-(void) syncWithApplication {
    [self.UserWebservice getUser:self.userModel.idService
                withSuccessBlock:^(NSMutableDictionary* responseObject){
                    [self saveUserChanges:responseObject];
                }
                 andFailureBlock:^(NSError * error){
                     NSLog(@"It couldn't connect with kiloton-webservice, please check your connection");
                 }];
}

- (void) saveUsersInWebservice {
    __weak typeof(self) weakSelf = self;
    [self.UserWebservice addUser:self.userModel
                withSuccessBlock:^(NSMutableDictionary *responseObject) {
                    [weakSelf saveWebServiceUserId:responseObject[@"user"][@"_id"]];
                }
                 andFailureBlock:^(NSError * error) {
                     NSLog(@"Error:%@, %@ ",error, error.localizedDescription);
                 }];
}

- (void) updateUsersInWebservice {
    __weak typeof(self) weakSelf = self;
    [self.UserWebservice updateUser:self.userModel.idProfile
                         updateData:self.userModel
                withSuccessBlock:^(NSMutableDictionary *responseObject) {
                    [weakSelf saveWebServiceUserId:responseObject[@"user"][@"_id"]];
                    NSLog(@"Updated successfully");
                }
                 andFailureBlock:^(NSError * error) {
                     NSLog(@"Error:%@, %@ ",error, error.localizedDescription);
                 }];
}

- (void) saveWebServiceUserId:(NSString *)idUser {
    self.userModel.idService = idUser;
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    }
}

- (void)saveUserChanges:(NSMutableDictionary*) responseObject {
    self.userModel.accessToken = responseObject[@"user"][@"accessToken"];
    self.userModel.name = responseObject[@"user"][@"name"];
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    }
}

- (void)changeStoryboard:(NSString *) storyboardName identifier:(NSString *) identifier{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    LoginViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier: identifier];
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:appDelegate.window cache:NO];
        appDelegate.window.rootViewController = profileViewController;
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