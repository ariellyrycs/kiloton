//
//  HistoryCellTableViewCell.h
//  kiloton
//
//  Created by Ariel Robles on 2/25/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *emoticon;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *day;


@end
