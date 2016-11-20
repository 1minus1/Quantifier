//
//  StatsHeaderViewController.h
//  Quantifier
//
//  Created by Scott Zero on 10/27/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZQuantifier.h"
@interface StatsHeaderViewController : UIViewController <UITextFieldDelegate>
{

    __weak IBOutlet UILabel *meanLabelField;
    __weak IBOutlet UILabel *maxLabelField;
    __weak IBOutlet UILabel *minLabelField;
    __weak IBOutlet UILabel *medianLabelField;
    __weak IBOutlet UILabel *rangeLabelField;
    __weak IBOutlet UILabel *sumLabelField;
    __weak IBOutlet UILabel *countLabelField;
    
    __weak IBOutlet UILabel *meanValueField;
    __weak IBOutlet UILabel *maxValueField;
    __weak IBOutlet UILabel *minValueField;
    __weak IBOutlet UILabel *medianValueField;
    __weak IBOutlet UILabel *rangeValueField;
    __weak IBOutlet UILabel *sumValueField;
    __weak IBOutlet UILabel *countValueField;
    
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UILabel *statsTitle;
}
@property (nonatomic, weak) SZQuantifier *quantifier;


@end
