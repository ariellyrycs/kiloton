//
//  UserProfileViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/23/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

static NSString * userModelName = @"UserModel";

@interface UserProfileViewController ()
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImage.layer.cornerRadius  = 50;
    self.userImage.layer.borderColor = [UIColor grayColor].CGColor;
    self.userImage.layer.masksToBounds = YES;
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

- (void)changeToMainStoryboard {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
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
    [self changeToMainStoryboard];
}

- (IBAction)sendWeight:(id)sender {
    [self.currentWeight.text intValue];
    
    if(![self.currentWeight.text isEqualToString:@""]) {
        NSLog(@"2");
    } else {
        [self showMessageAlert:@"" title:@"It couldn't save"];
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
