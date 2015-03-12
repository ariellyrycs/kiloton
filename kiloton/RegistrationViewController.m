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
@property (strong) UIImage * imageStatus;
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
    [self.weightToLose addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)textFieldDidChange :(UITextField *)theTextField {
    NSInteger currentWeight = [self.currentWeight.text integerValue];
    NSInteger objective = [self.weightToLose.text integerValue];
    if(currentWeight < objective) {
        objective = currentWeight;
    }
    self.finalDate.minimumDate = [self calculateRequireMothshByWeights:currentWeight objectiveWeight:objective];
    [self.finalDate setDate:self.finalDate.minimumDate];
}

-(NSDate *)calculateRequireMothshByWeights:(NSInteger)currentWeight objectiveWeight:(NSInteger)objective {
    float allowedPorcentagePerMonth = 5;
    float requiredMonths =  -(((objective * 100) / currentWeight) - 100) / allowedPorcentagePerMonth;
    return [self convertMonthsToDates:requiredMonths];
}

-(NSDate *)convertMonthsToDates: (float) months {
    NSDate *mydate = [NSDate date];
    NSTimeInterval secondsInEightHours =  60 * 60 * 24 * 30 * months;
    NSDate *dateEightHoursAhead = [mydate dateByAddingTimeInterval:secondsInEightHours];
    return dateEightHoursAhead;
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
    NSData *pngImage =  [self convertImage:self.imageStatus];
    NSString * imagePath = self.getImagePath;
    [self saveImage:pngImage path:imagePath];
    [self.userModel addSprintsObject:newSprint];
    newSprint.imageURL = imagePath;
    NSLog(@"%@", newSprint.imageURL);
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

- (IBAction)selectAnImage:(id)sender {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.currentImage.image = chosenImage;
    self.imageStatus = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)generateFileName {
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lf", timeStamp];
}

-(NSString *)getImagePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat: @"%@.png", self.generateFileName];
    return [documentsPath stringByAppendingPathComponent: fileName];
}

-(NSData *)convertImage:(UIImage *)image {
    return UIImagePNGRepresentation(image);
}

-(void)saveImage:(NSData *)pngData path:(NSString *) filePath{
    [pngData writeToFile:filePath atomically:YES];
}

@end




