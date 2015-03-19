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

- (void)addUser:(UserModel *) data withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: data.name, @"name",
                            data.accessToken, @"accessToken",
                            data.idProfile, @"idProfile",
                            nil];
    [manager POST:[NSString stringWithFormat:@"%@/user",hostName]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)getUser:(NSString *)idProfile withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/user/%@", hostName, idProfile] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}


- (void)checkUserExistance:(NSString *)idProfile withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@/user/%@/exists", hostName, idProfile] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

- (void)updateUser:(NSString *)idProfile updateData:(UserModel *) userData {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: userData.name, @"name",
                            userData.accessToken, @"accessToken",
                            nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:[NSString stringWithFormat:@"%@/user/%@", hostName, idProfile]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"Updated successfully");
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}
@end
