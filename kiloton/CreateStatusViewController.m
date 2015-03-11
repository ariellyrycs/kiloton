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
@property(strong) NSString *imageURL;
@end

static NSString *iteractionsModelName = @"InteractionsModel";

@implementation CreateStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comment.layer.borderColor = [[UIColor grayColor] CGColor];
    self.comment.layer.borderWidth = 1.0;
    self.comment.layer.cornerRadius = 8;
    self.checkDate.minimumDate = [self sumDayTo:self.getLastcheckDate numberOfDays:1];
    self.checkDate.maximumDate = self.getLimitcheckDate;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.viewContent.bounds.size;
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
    newInteracton.imageURL = self.imageURL;
    [self.currentSprint addEachInteractionObject:newInteracton];
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)selectAnImage:(id)sender {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.currentImage.image = image;
    NSURL *url = [info valueForKey:UIImagePickerControllerReferenceURL];
    self.imageURL = url.absoluteString;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSDate *) sumDayTo:(NSDate *)date numberOfDays: (int)number {
    return [date dateByAddingTimeInterval:60 * 60 * 24 * number];
}
@end
