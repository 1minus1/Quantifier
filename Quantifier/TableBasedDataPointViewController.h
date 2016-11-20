//
//  TableBasedDataPointViewController.h
//  Quantifier
//
//  Created by Scott Zero on 3/17/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDataPoint.h"
#import "SZQuantifier.h"
#import "DetailViewController.h"
#import "DataPointViewFirstCell.h"
#import "DataPointDateTableViewCell.h"
#import "DatePickerTableViewCell.h"
@class IncrementingTableViewCell;

@interface TableBasedDataPointViewController : UITableViewController

@property (nonatomic, strong) SZDataPoint *datapoint;
@property (nonatomic, strong) SZQuantifier *quantifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) DetailViewController *dvc;
@property (nonatomic, strong) DataPointViewFirstCell *firstCellInTable;
@property (nonatomic, strong) DatePickerTableViewCell *datePickerCell;
@property (nonatomic) BOOL isEditingDate;
@property (nonatomic, strong) NSDate *dateCreated;

- (IBAction)togglePosNeg:(id)sender;
- (void)cancelDataPointAdd:(id)sender;
- (IBAction)doneButtonPress:(id)sender;
- (void)doStuffOnDoneButtonPress;

- (DataPointViewFirstCell *)getDataPointValueCell;
- (DataPointDateTableViewCell *)getDateCell;
- (DatePickerTableViewCell *)getDatePickerCell;
- (IncrementingTableViewCell *)getIncrementerCell;



-(void)dateChanged;

@end
