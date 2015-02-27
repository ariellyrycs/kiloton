//
//  RegistrationViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/26/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface RegistrationViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *currentWeight;
@property (weak, nonatomic) IBOutlet UITextField *weightToLose;
@property (weak, nonatomic) IBOutlet UIDatePicker *finalDate;
- (IBAction)sendWeight:(id)sender;
@end
