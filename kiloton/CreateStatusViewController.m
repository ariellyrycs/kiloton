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
@property(strong) UIImage *imageStatus;
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
    newInteracton.imageURL = self.saveImage;
    [self.currentSprint addEachInteractionObject:newInteracton];
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)selectAnImage:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Select Image"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [self addActionToAlert:alert title:@"Potho Library" sourceType: UIImagePickerControllerSourceTypePhotoLibrary];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self addActionToAlert:alert title:@"Camera" sourceType: (UIImagePickerControllerSourceType *) UIImagePickerControllerSourceTypeCamera];
    }
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) addActionToAlert:(UIAlertController *)alert title:(NSString *)title sourceType:(UIImagePickerControllerSourceType *) sourceType{
    UIAlertAction* sourceAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             UIImagePickerController *picker = [UIImagePickerController new];
                                                             picker.delegate = self;
                                                             picker.allowsEditing = YES;
                                                             picker.sourceType = (UIImagePickerControllerSourceType)sourceType;
                                                             [self presentViewController:picker animated:YES completion:nil];
                                                         }];
    [alert addAction:sourceAction];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)saveImage {
    NSString * path = self.getImagePath;
    NSData *pngImage =  [self convertImage:self.imageStatus];
    [pngImage writeToFile:path atomically:YES];
    return path;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.currentImage.image = chosenImage;
    self.imageStatus = chosenImage;
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

-(NSDate *) sumDayTo:(NSDate *)date numberOfDays: (int)number {
    return [date dateByAddingTimeInterval:60 * 60 * 24 * number];
}
@end
