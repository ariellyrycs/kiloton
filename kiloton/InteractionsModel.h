//
//  InteractionsModel.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InteractionsModel : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * registrationDate;
@property (nonatomic, retain) NSString * weight;
@property (nonatomic, retain) NSDate * date;

@end
