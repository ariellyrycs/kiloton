//
//  ViewStatusVIewController.h
//  kiloton
//
//  Created by Ariel Robles on 3/9/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractionsModel.h"

@interface ViewStatusVIewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (strong) InteractionsModel * rowData;
@property (weak, nonatomic) IBOutlet UIImageView *photoTaken;

@end
