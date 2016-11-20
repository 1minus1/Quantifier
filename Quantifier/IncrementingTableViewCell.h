//
//  IncrementingTableViewCell.h
//  Quantifier
//
//  Created by Scott Zero on 3/21/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPointViewFirstCell.h"
#import "TableBasedDataPointViewController.h"

@interface IncrementingTableViewCell : UITableViewCell
{
    __weak IBOutlet UITextField *incrementAmountField;
    __weak IBOutlet UIButton *minusButton;
    
    __weak IBOutlet UIButton *plusButton;
}



@property (nonatomic,weak) DataPointViewFirstCell *dataPointViewFirstCell;
@property (nonatomic,weak) UITextField *incrementAmountField;
@property (nonatomic,weak) TableBasedDataPointViewController *tbdpvc;
@property (nonatomic,weak) UIButton *plusButton;
@property (nonatomic,weak) UIButton *minusButton;

- (IBAction)decrementAmount:(id)sender;
- (IBAction)incrementAmount:(id)sender;

@end
