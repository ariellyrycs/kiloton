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
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+RoundersCorners.h"
#import "LoginViewController.h"

@interface StatusViewController ()

@end

static NSString *userModelName = @"UserModel";

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showInfo];
    [self.userImage makeRounderCorners];
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(id)getCurrentUser {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:userModelName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error %@", error);
        return nil;
    }
    
    return [results objectAtIndex:0];
}

- (void) showInfo {
    UserModel *managedObject = self.getCurrentUser;
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
    [[self managedObjectContext] deleteObject:managedObject];
    [self saveContext];
}

- (void)saveContext{
    NSError *error;
    if(![[self managedObjectContext] save:&error]) {
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
