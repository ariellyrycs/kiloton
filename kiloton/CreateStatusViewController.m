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

@interface CreateStatusViewController ()
@end

static NSString *iteractionsModelName = @"InteractionsModel";

@implementation CreateStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.comment.layer.borderColor = [[UIColor grayColor] CGColor];
    self.comment.layer.borderWidth = 1.0;
    self.comment.layer.cornerRadius = 8;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.comment resignFirstResponder];
    [self.currentWeight resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    NSError *error;
    if(![self.context save:&error]) {
        NSLog(@"Error %@",error);
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
