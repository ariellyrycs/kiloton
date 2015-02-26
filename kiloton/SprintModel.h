//
//  SprintModel.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SprintModel : NSManagedObject

@property (nonatomic, retain) NSDate * currentDate;
@property (nonatomic, retain) NSDate * lastDate;
@property (nonatomic, retain) NSString * currentWeight;
@property (nonatomic, retain) NSString * weightObjective;

@end
