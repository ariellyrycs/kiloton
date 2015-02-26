//
//  CreateStatusViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateStatusViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *currentWeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *checkDate;
@property (weak, nonatomic) IBOutlet UITextView *comment;
- (IBAction)send:(id)sender;

@end
