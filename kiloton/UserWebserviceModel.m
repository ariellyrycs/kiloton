//
//  UserWebserviceModel.m
//  kiloton
//
//  Created by Ariel Robles on 3/17/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "UserWebserviceModel.h"
#import "AFNetworking.h"

static NSString *hostName = @"http://localhost:4000";
@implementation UserWebserviceModel

-(void)addUser:(UserModel *) data {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: data.name, @"name",
                            data.accessToken, @"accessToken",
                            data.idProfile, @"idProfile",
                            nil];
    [manager POST:[NSString stringWithFormat:@"%@/user",hostName]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getUser:(NSString *)idProfile withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSLog(@"%@",[NSString stringWithFormat:@"%@/user/%@", hostName, idProfile]);
    [manager GET:[NSString stringWithFormat:@"%@/user/%@", hostName, idProfile] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}
@end
