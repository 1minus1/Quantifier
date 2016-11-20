//
//  DataPointViewFirstCell.h
//  Quantifier
//
//  Created by Scott Zero on 3/17/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DataPointViewFirstCell : UITableViewCell
{
    __weak IBOutlet UITextField *valueLabel;
    __weak IBOutlet UIButton *pluMinusButton;
    
}

@property (nonatomic, weak) UITextField *valueLabel;
@property (nonatomic, weak) UIButton *pluMinusButton;

- (IBAction)togglePosNeg:(id)sender;


@end
