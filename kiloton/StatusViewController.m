//
//  StatusViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "StatusViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "SprintModel.h"
#import "InteractionsModel.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+RoundersCorners.h"
#import "LoginViewController.h"

@interface StatusViewController ()
@property (strong) NSManagedObjectContext * context;
@end

static NSString *userModelName = @"UserModel";

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userImage makeRounderCorners];
    self.context = self.managedObjectContext;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showInfo];
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (SprintModel *) getCurrentSprint:(UserModel *)currentUser {
    NSArray * sprints = [[currentUser.sprints allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"currentDate"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [sprints sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.firstObject;
}

-(id)getCurrentUser {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:[UserModel description]];
    NSError *error;
    NSMutableArray *UserModelObject =  [[self.context executeFetchRequest:request error:&error] mutableCopy];
    if (error) {
        NSLog(@"Error %@", error);
        return nil;
    }
    return UserModelObject.firstObject;
}

- (InteractionsModel *) getLastInteraction:(SprintModel *)currentSprint {
    NSArray * interaction = [[currentSprint.eachInteraction allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"registrationDate"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [interaction sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.firstObject;
    
}

-(int)calculateWeightLost:(NSString *)lastInteractionWeight initialIteraction:(NSString *)initialInteraction {
    return ([initialInteraction intValue] - [lastInteractionWeight intValue]) * -1;
}

- (void) showInfo {
    UserModel *managedObject = self.getCurrentUser;
    SprintModel *currentSprint = [self getCurrentSprint:managedObject];
    InteractionsModel *lastInteraction = [self getLastInteraction:currentSprint];
    if(currentSprint.eachInteraction.count) {
        self.weightLost.text =  [NSString stringWithFormat:@"Weight loss %i Kg", [self calculateWeightLost:lastInteraction.weight initialIteraction: currentSprint.currentWeight]];
    } else {
        self.weightLost.text = @"Weight loss 0 Kg";
    }
    self.currentWeight.text = [NSString stringWithFormat:@"Current weight %@ Kg", currentSprint.currentWeight ];
    self.userImage.profileID = managedObject.idProfile;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender {
    NSLog(@"You're logged out");
    [self deleteCurrentUserInfo];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self changeStoryboard:@"Login" identifier: @"loginViewController"];
}

- (void) deleteCurrentUserInfo {
    NSManagedObject *managedObject = self.getCurrentUser;
    [self.context deleteObject:managedObject];
    [self saveContext];
}

- (void)saveContext{
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

@end
