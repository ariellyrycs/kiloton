//
//  UserModel.h
//  kiloton
//
//  Created by Ariel Robles on 3/18/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SprintModel;

@interface UserModel : NSManagedObject

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * idProfile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * idService;
@property (nonatomic, retain) NSSet *sprints;
@end

@interface UserModel (CoreDataGeneratedAccessors)

- (void)addSprintsObject:(SprintModel *)value;
- (void)removeSprintsObject:(SprintModel *)value;
- (void)addSprints:(NSSet *)values;
- (void)removeSprints:(NSSet *)values;

@end
