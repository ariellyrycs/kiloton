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
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showInfo {
    self.name.text = self.userModel.name;
    self.userImage.profileID = self.userModel.idProfile;
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

- (IBAction)sendWeight:(id)sender {
    if([self.currentWeight.text intValue] && [self.weightToLose.text intValue]) {
        if([self.currentWeight.text intValue] >= [self.weightToLose.text intValue]) {
            [self saveSprintData];
        } else {
            [self showMessageAlert:@"" title:@"Weight to lose has to be less than your current weight"];
        }
    } else {
        [self showMessageAlert:@"" title:@"It couldn't save"];
    }
}

- (void) saveSprintData {
    SprintModel *newSprint = [NSEntityDescription insertNewObjectForEntityForName:sprintModelName inManagedObjectContext:self.context];
    newSprint.currentDate = [NSDate date];
    newSprint.lastDate = [self.finalDate date];
    newSprint.currentWeight = self.currentWeight.text;
    newSprint.weightObjective = self.weightToLose.text;
    [self.userModel addSprintsObject:newSprint];
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self setActiveSession];
        [self changeStoryboard:@"Main" identifier: @"logedInTabBar"];
    }
}

-(void) setActiveSession {
    self.userModel.active = [NSNumber numberWithBool:YES];
    [self saveContext];
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




