//
//  UserWebserviceModel.h
//  kiloton
//
//  Created by Ariel Robles on 3/17/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface UserWebserviceModel : NSObject
- (void)addUser:(UserModel *) data withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure;
- (void)getUser:(NSString *)email withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure;
- (void)checkUserExistance:(NSString *)idProfile withSuccessBlock:(void(^)(id))success andFailureBlock:(void(^)(NSError *))failure;
- (void)updateUser:(NSString *)idProfile updateData:(UserModel *) userData;
@end
