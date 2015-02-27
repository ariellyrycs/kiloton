//
//  RegistrationViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/26/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "RegistrationViewController.h"
#import "UserModel.h"
#import "SprintModel.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIView+RoundersCorners.h"

@interface RegistrationViewController ()

@end

static NSString * userModelName = @"UserModel";
static NSString * sprintModelName = @"SprintModel";

@implementation RegistrationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userImage makeRounderCorners];
    self.finalDate.minimumDate = [NSDate date];
    [self showInfo];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.currentWeight resignFirstResponder];
    [self.weightToLose resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.name.text = managedObject.name;
    self.userImage.profileID = managedObject.idProfile;
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)signOut:(id)sender {
    NSLog(@"You're logged out");
    [self deleteCurrentUserInfo];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self changeStoryboard:@"Login" identifier: @"loginViewController"];
}

- (IBAction)sendWeight:(id)sender {
    if([self.currentWeight.text intValue] && [self.weightToLose.text intValue]) {
        [self saveSprintData];
    } else {
        [self showMessageAlert:@"" title:@"It couldn't save"];
    }
}

- (void) saveSprintData {
    NSManagedObjectContext *context = [self managedObjectContext];
    SprintModel *newSprint = [NSEntityDescription insertNewObjectForEntityForName:sprintModelName inManagedObjectContext:context];
    newSprint.currentDate = [NSDate date];
    newSprint.lastDate = [self.finalDate date];
    newSprint.currentWeight = self.currentWeight.text;
    newSprint.weightObjective = self.weightToLose.text;
    NSError *error;
    if(![self.managedObjectContext save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self changeStoryboard:@"Main" identifier: @"logedInTabBar"];
    }
}

- (void) showMessageAlert:message title: title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end




