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
@property (strong) NSMutableArray * userArray;
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

-(id)getCurrentUser {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:[userModelName description]];
    NSError *error;
    self.userArray =  [[self.context executeFetchRequest:request error:nil] mutableCopy];
    if (error) {
        NSLog(@"Error %@", error);
        return nil;
    }
    return [self.userArray objectAtIndex:0];
}

- (void) showInfo {
    UserModel *managedObject = self.getCurrentUser;
    self.name.text = managedObject.name;
    self.userImage.profileID = managedObject.idProfile;
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

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)sendWeight:(id)sender {
    if([self.currentWeight.text intValue] && [self.weightToLose.text intValue]) {
        [self saveSprintData];
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
    [[self.userArray objectAtIndex:0] addSprintsObject:newSprint];
    NSError *error;
    if(![self.context save:&error]) {
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




