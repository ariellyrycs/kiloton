//
//  CreateStatusViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SprintModel.h"

@interface CreateStatusViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITextField *currentWeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *checkDate;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UIImageView *currentImage;
@property NSManagedObjectContext * context;
@property SprintModel * currentSprint;

- (IBAction)send:(id)sender;
- (IBAction)selectAnImage:(id)sender;


@end
