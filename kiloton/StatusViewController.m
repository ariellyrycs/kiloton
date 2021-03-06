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
#import "UIView+ScatterPlot.h"
#import "LoginViewController.h"
#import "GraphWeightModel.h"

@interface StatusViewController ()
@property (strong) NSManagedObjectContext * context;
@property (strong) UserModel *managedObject;
@property (strong) SprintModel *currentSprint;
@property (strong) InteractionsModel *lastInteraction;
@property (strong) GraphWeightModel *graphWeightObject;
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
    [self setModelsObjects];
    [self showInfo];
}

-(void)viewDidAppear:(BOOL)animated {
    [self setGraphModelInfo];
    [self.scatterView initPlot:self.graphWeightObject];
}

-(void)setModelsObjects {
    self.managedObject = self.getCurrentUser;
    self.currentSprint = self.getCurrentSprint;
    self.lastInteraction = self.getLastInteraction;
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (SprintModel *) getCurrentSprint {
    NSArray * sprints = [[self.managedObject.sprints allObjects] mutableCopy];
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
    return [self findActiveSession: UserModelObject];
}

-(UserModel *)findActiveSession:(NSMutableArray *)userModelObjects {
    UserModel * activeUserModel;
    for(NSInteger i = 0; i < userModelObjects.count; i++) {
        activeUserModel = [userModelObjects objectAtIndex:i];
        if([activeUserModel.active  isEqual: @1]) {
            break;
        }
    }
    return activeUserModel;
}

- (InteractionsModel *) getLastInteraction {
    NSArray * interaction = [[self.currentSprint.eachInteraction allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"registrationDate"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [interaction sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.firstObject;
    
}

-(int)calculateWeightLost:(NSString *)lastInteractionWeight initialIteraction:(NSString *)initialInteraction {
    return [initialInteraction intValue] - [lastInteractionWeight intValue];
}

- (void) showInfo {
    if(self.currentSprint.eachInteraction.count) {
        self.weightLost.text =  [NSString stringWithFormat:@"Weight loss: %i Kg", [self calculateWeightLost:self.lastInteraction.weight initialIteraction: self.currentSprint.currentWeight]];
        self.currentWeight.text = [NSString stringWithFormat:@"Current weight: %@ Kg", self.lastInteraction.weight ];
    } else {
        self.weightLost.text = @"Weight loss 0 Kg";
        self.currentWeight.text = [NSString stringWithFormat:@"Current weight: %@ Kg", self.currentSprint.currentWeight ];
    }
    self.userImage.profileID = self.managedObject.idProfile;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOut:(id)sender {
    NSLog(@"You're logged out");
    [self deactivateSccount];
    [FBSession.activeSession closeAndClearTokenInformation];
    [self changeStoryboard:@"Login" identifier: @"StartingNav"];
}

- (void) deactivateSccount {
    self.managedObject.active = [NSNumber numberWithBool:NO];
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


-(void)setGraphModelInfo {
    self.graphWeightObject = [GraphWeightModel new];
    [self setDaysRanges];
    [self setWeightRanges];
    [self setResult];
}


-(void)setDaysRanges {
    self.graphWeightObject.numberOfDays = [self daysBetween:self.currentSprint.currentDate :self.currentSprint.lastDate];
}

- (NSNumber *)daysBetween:(NSDate *)dt1 :(NSDate *)dt2 {
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return [NSNumber numberWithLongLong:([components day] + 1)];
}

- (void)setWeightRanges {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    self.graphWeightObject.objectiveRange = [f numberFromString:self.currentSprint.weightObjective];
    self.graphWeightObject.initialRange = [f numberFromString: self.currentSprint.currentWeight];
}

-(NSMutableDictionary *) getResult {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    NSArray * interaction = [[self.currentSprint.eachInteraction allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"registrationDate"
                                                               ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *interactionsInOrder = [interaction sortedArrayUsingDescriptors:descriptors];
    int dayNumber;
    InteractionsModel * tmpInteractions;
    for(int i = 0; i < interactionsInOrder.count; i++) {
        tmpInteractions = interactionsInOrder[i];
        dayNumber = [[self daysBetween:self.currentSprint.currentDate :tmpInteractions.date] intValue];
        [result setValue:tmpInteractions.weight forKey:[NSString stringWithFormat:@"%i", dayNumber]];
    }
    return result;
}

-(void) setResult {
    self.graphWeightObject.resultSpots = self.getResult;
}


@end
