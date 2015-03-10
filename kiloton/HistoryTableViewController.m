//
//  HistoryTableViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryCellTableViewCell.h"
#import "CreateStatusViewController.h"
#import "ViewStatusVIewController.h"
#import "InteractionsModel.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "SprintModel.h"

@interface HistoryTableViewController ()
@property NSArray* status;
@property NSManagedObjectContext *context;
@property UserModel *currentUser;
@property SprintModel *currentSprint;
@end

static NSString* cellIdentifier = @"weightCell";
static NSString* iteractionModelName = @"InteractionsModel";
@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    self.context = self.managedObjectContext;
    self.currentUser = self.getCurrentUser;
    self.currentSprint = self.getCurrentSprint;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getInfo];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.status.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.0f;
}


-(NSString *) getMonthName:(NSDate *) date {
    NSDateFormatter *calMonth = [NSDateFormatter new];
    [calMonth setDateFormat:@"MMMM"];
    return [calMonth stringFromDate:date];
}

- (NSString *) getDay:(NSDate *) date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:date];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%li", (long)day];
}

-(int) weightLostSinceTheLastCheck:(NSString *)from to:(NSString *)to {
    return ([from intValue] - [to intValue]) * -1;
}

- (NSString *) getEmoticonBy:(int) weightLost {
    NSString* emoticonName;
    
    if(weightLost < -2) {
        emoticonName = @"happy";
    } else if(weightLost < 0) {
        emoticonName = @"sorprised";
    } else if(weightLost > 0) {
        emoticonName = @"sorrow";
    } else if(weightLost == 0) {
        emoticonName = @"normal";
    }
    return emoticonName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int weightLost;
    HistoryCellTableViewCell* cell = (HistoryCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[HistoryCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    InteractionsModel *state = [self.status objectAtIndex:indexPath.row];
    if(indexPath.row) {
        InteractionsModel *lastState = [self.status objectAtIndex:indexPath.row - 1];
        weightLost = [self weightLostSinceTheLastCheck:lastState.weight to:state.weight];
    } else {
        weightLost = [self weightLostSinceTheLastCheck:self.currentSprint.currentWeight to:state.weight];
    }
    
    cell.month.text = [self getMonthName:state.date];
    cell.day.text = [self getDay:state.date];
    cell.status.text = [NSString stringWithFormat:@" %i Kg", weightLost];
    cell.emoticon.image = [UIImage imageNamed:[self getEmoticonBy:weightLost]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"checkInteraction" sender:indexPath];
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)getInfo {
    NSArray * status = [[self.currentSprint.eachInteraction allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"registrationDate"
                                                               ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    self.status = [status sortedArrayUsingDescriptors:descriptors];
    [self.tableView reloadData];
}


-(id)getCurrentUser {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:[UserModel description]];
    NSError *error;
    NSMutableArray *UserModelObject =  [[self.context executeFetchRequest:request error:&error] mutableCopy];
    if (error) {
        NSLog(@"Error %@", error);
        return nil;
    }
    return [self findActiveSession: UserModelObject];
}

-(UserModel *)findActiveSession:(NSMutableArray *)userModelObjects {
    UserModel * activeUserModel;
    for(NSInteger i = 0; i < userModelObjects.count; i++) {
        activeUserModel = [userModelObjects objectAtIndex:i];
        if([activeUserModel.active  isEqual: @1]) {
            break;
        }
    }
    return activeUserModel;
}

- (SprintModel *) getCurrentSprint {
    NSArray * sprints = [[self.currentUser.sprints allObjects] mutableCopy];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"currentDate"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reverseOrder = [sprints sortedArrayUsingDescriptors:descriptors];
    return reverseOrder.firstObject;
}

#pragma mark - Segue methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"newInteractionTransition"]) {
        CreateStatusViewController * csvc = segue.destinationViewController;
        csvc.currentSprint = self.currentSprint;
        csvc.context = self.context;
    } else if([segue.identifier isEqualToString:@"checkInteraction"]) {
        NSIndexPath * indexPath = sender;
        ViewStatusVIewController *vsvc = segue.destinationViewController;
        vsvc.rowData = [self.status objectAtIndex:indexPath.row];
    }
}
@end
