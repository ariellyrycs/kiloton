//
//  SprintModel.h
//  kiloton
//
//  Created by Ariel Robles on 3/13/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InteractionsModel, UserModel;

@interface SprintModel : NSManagedObject

@property (nonatomic, retain) NSDate * currentDate;
@property (nonatomic, retain) NSString * currentWeight;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSDate * lastDate;
@property (nonatomic, retain) NSString * weightObjective;
@property (nonatomic, retain) NSSet *eachInteraction;
@property (nonatomic, retain) UserModel *owner;
@end

@interface SprintModel (CoreDataGeneratedAccessors)

- (void)addEachInteractionObject:(InteractionsModel *)value;
- (void)removeEachInteractionObject:(InteractionsModel *)value;
- (void)addEachInteraction:(NSSet *)values;
- (void)removeEachInteraction:(NSSet *)values;

@end
