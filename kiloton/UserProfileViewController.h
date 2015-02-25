//
//  UserProfileViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/23/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface UserProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *currentWeight;
@property (weak, nonatomic) IBOutlet UITextField *weightToLose;
@property (weak, nonatomic) IBOutlet UIDatePicker *finalDate;
- (IBAction)signOut:(id)sender;
- (IBAction)sendWeight:(id)sender;



@end
