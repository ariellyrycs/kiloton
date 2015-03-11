//
//  ViewStatusVIewController.m
//  kiloton
//
//  Created by Ariel Robles on 3/9/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "ViewStatusVIewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

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
    NSURL *asssetURL = [NSURL URLWithString:self.rowData.imageURL];
    if(asssetURL) {
        ALAssetsLibrary *library = [ALAssetsLibrary new];
        [library assetForURL:asssetURL resultBlock:^(ALAsset *asset) {
            UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            self.photoTaken.image = copyOfOriginalImage;
        } failureBlock:^(NSError *error) {
            NSLog(@"Error: it could load the image");
        }];
    }
}

-(NSString *) dateFormat:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    return [formatter stringFromDate:date];
}
@end
