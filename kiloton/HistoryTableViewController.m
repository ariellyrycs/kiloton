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
    self.UserModelObject = self.getUserObject;
    [self setCurrentSprint];
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
    return [to intValue] - [from intValue];
}

- (NSString *) getEmoticonBy:(int) weightLost {
    NSString* emoticonName;
    
    if(weightLost > 2) {
        emoticonName = @"sorprised";
    } else if(weightLost > 0) {
        emoticonName = @"happy";
    } else if(weightLost < 0) {
        emoticonName = @"sorrow";
    } else if(weightLost == 0) {
        emoticonName = @"normal";
    }
    return emoticonName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCellTableViewCell* cell = (HistoryCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[HistoryCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    InteractionsModel *state = [self.status objectAtIndex:indexPath.row];
    int weightLost = [self weightLostSinceTheLastCheck:self.currentSprint.currentWeight to:state.weight];
    NSLog(@"weight Lost: %i", weightLost);
    NSLog(@"initial weight: %@", self.currentSprint.currentWeight);
    NSLog(@"currentWeight: %@", state.weight);
    cell.month.text = [self getMonthName:state.date];
    cell.day.text = [self getDay:state.date];
    cell.status.text = [NSString stringWithFormat:@"Weight loss %i", weightLost];
    cell.emoticon.image = [UIImage imageNamed:[self getEmoticonBy:weightLost]];
    return cell;
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (void)getInfo {
    self.status = [self.currentSprint.eachInteraction allObjects];
    [self.tableView reloadData];
}


- (NSMutableArray *) getUserObject {
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:[UserModel description]];
    return [[self.context executeFetchRequest:request error:nil] mutableCopy];
}

- (void) setCurrentSprint {
    self.currentUser = self.UserModelObject.firstObject;
    NSArray * sprints = [[self.currentUser.sprints allObjects] mutableCopy];
    self.currentSprint = sprints.lastObject;
}

#pragma mark - Segue methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"newInteractionTransition"]) {
        CreateStatusViewController * csvc = segue.destinationViewController;
        csvc.currentSprint = self.currentSprint;
        csvc.context = self.context;
    }
}
@end
