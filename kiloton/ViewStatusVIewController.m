//
//  ViewStatusVIewController.m
//  kiloton
//
//  Created by Ariel Robles on 3/9/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "ViewStatusVIewController.h"

@implementation ViewStatusVIewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInfo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setInfo {
    self.weight.text = [NSString stringWithFormat:@"Weight: %@", self.rowData.weight];
    self.date.text = [NSString stringWithFormat:@"Date: %@", [self dateFormat:self.rowData.date]];
    self.comments.text = self.rowData.comment;
}

-(NSString *) dateFormat:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter stringFromDate:date];
}
@end
