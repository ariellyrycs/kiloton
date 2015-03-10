//
//  RegistrationViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/26/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserModel.h"
@interface RegistrationViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextField *currentWeight;
@property (weak, nonatomic) IBOutlet UITextField *weightToLose;
@property (weak, nonatomic) IBOutlet UIDatePicker *finalDate;
@property (strong) NSManagedObjectContext *context;
@property (strong) UserModel * userModel;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
- (IBAction)sendWeight:(id)sender;
- (IBAction)selectAnImage:(id)sender;
@end
