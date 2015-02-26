//
//  UIView+RoundersCorners.m
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "UIView+RoundersCorners.h"
#import <FacebookSDK/FacebookSDK.h>
@implementation UIView (RoundersCorners)
- (void) makeRounderCorners {
    self.layer.cornerRadius  = CGRectGetHeight(self.frame) / 2;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = YES;
}
@end
