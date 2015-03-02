//
//  HistoryTableViewController.m
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HistoryCellTableViewCell.h"
#import "InteractionsModel.h"
#import "AppDelegate.h"

@interface HistoryTableViewController ()
@property NSArray* status;
@end

static NSString* cellIdentifier = @"weightCell";
static NSString* iteractionModelName = @"InteractionsModel";
@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryCellTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
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

-(NSString *) getDay:(NSDate *) date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:units fromDate:date];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%li", (long)day];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCellTableViewCell* cell = (HistoryCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[HistoryCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    InteractionsModel *state = [self.status objectAtIndex:indexPath.row];
    cell.month.text = [self getMonthName:state.date];
    cell.day.text = [self getDay:state.date];
    return cell;
}

- (NSArray *) getStatus {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:iteractionModelName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Error %@", error);
        return nil;
    }
    return results;
}

- (NSManagedObjectContext *) managedObjectContext{
    return [(AppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

-(void)getInfo {
    self.status = [self getStatus];
    [self.tableView reloadData];
}
@end
