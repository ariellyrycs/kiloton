//
//  ViewController.h
//  kiloton
//
//  Created by Ariel Robles on 2/23/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property UIStoryboard *profileStoryboard;
- (IBAction)SignInWithFaceBook:(id)sender;
- (NSString*) getToken;
@end

