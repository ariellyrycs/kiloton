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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
