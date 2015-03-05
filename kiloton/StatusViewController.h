//
//  StatusViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface StatusViewController : UIViewController
@property (weak, nonatomic) IBOutlet FBProfilePictureView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *currentWeight;
@property (weak, nonatomic) IBOutlet UILabel *weightLost;
@property (weak, nonatomic) IBOutlet UIView *scatterView;
- (IBAction)signOut:(id)sender;
- (void)changeStoryboard:(NSString *) storyboardName identifier:(NSString *) identifier;
@end
