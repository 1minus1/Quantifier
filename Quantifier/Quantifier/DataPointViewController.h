//
//  DataPointViewController.h
//  Quantifier
//
//  Created by Scott Zero on 7/27/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZQuantifier.h"
@class DetailViewController;

@interface DataPointViewController : UIViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *valueLabel;
    __weak IBOutlet UILabel *dateField;
    __weak IBOutlet UIImageView *backgroundimageview;


    __weak IBOutlet UIButton *plusMinusButton;
    __weak IBOutlet UIDatePicker *datePicker;
    
}
@property (nonatomic, strong) SZDataPoint *datapoint;
@property (nonatomic, strong) SZQuantifier *quantifier;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) DetailViewController *dvc;

- (IBAction)togglePosNeg:(id)sender;
- (void)cancelDataPointAdd:(id)sender;
- (IBAction)doneButtonPress:(id)sender;
- (void)doStuffOnDoneButtonPress;
@end
