//
//  UserModel.h
//  kiloton
//
//  Created by Ariel Robles on 2/24/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserModel : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * idProfile;

@end
