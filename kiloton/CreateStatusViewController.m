//
//  CreateStatusViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "CreateStatusViewController.h"
#import "InteractionsModel.h"
#import "AppDelegate.h"
#import "SprintModel.h"

@interface CreateStatusViewController ()
@end

static NSString *iteractionsModelName = @"InteractionsModel";

@implementation CreateStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.comment.layer.borderColor = [[UIColor grayColor] CGColor];
    self.comment.layer.borderWidth = 1.0;
    self.comment.layer.cornerRadius = 8;
    self.checkDate.minimumDate = self.getLastcheckDate;
    self.checkDate.maximumDate = self.getLimitcheckDate;
}

- (NSDate *)getLimitcheckDate {
    return self.currentSprint.lastDate;
}

- (NSDate *)getLastcheckDate {
    NSDate * lastCheck;
    if(self.currentSprint.eachInteraction.count) {
        InteractionsModel *lastInteraction = [self getLastInteraction:self.currentSprint];
        lastCheck = lastInteraction.date;
    } else {
        lastCheck = self.currentSprint.currentDate;
    }
    return lastCheck;
}

- (InteractionsModel *) getLastInteraction:(SprintModel *)currentSprint {
    NSArray * interaction = [[currentSprint.eachInteraction allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"registrationDate"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [interaction sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.firstObject;
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.comment resignFirstResponder];
    [self.currentWeight resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)send:(id)sender {
    if(![self.comment isEqual:@""] || [self.currentWeight.text intValue]) {
        [self save];
    }
}


- (void) save {
    InteractionsModel *newInteracton = [NSEntityDescription insertNewObjectForEntityForName:iteractionsModelName inManagedObjectContext:self.context];
    newInteracton.registrationDate = [NSDate date];
    newInteracton.date = [self.checkDate date];
    newInteracton.weight = self.currentWeight.text;
    newInteracton.comment = self.comment.text;
    [self.currentSprint addEachInteractionObject:newInteracton];
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
