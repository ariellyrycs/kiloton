//
//  GraphWeightModel.h
//  kiloton
//
//  Created by Ariel Robles on 3/4/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphWeightModel : NSObject
@property NSArray * datesInSprint;
@property NSArray * estimationSpots;
@property NSMutableDictionary * resultSpots;
@property (nonatomic, strong) NSNumber * numberOfDays;
@property (nonatomic, strong) NSNumber * objectiveRange;
@property (nonatomic, strong) NSNumber * initialRange;

@end
