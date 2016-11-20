//
//  QuantifierTableViewCell.h
//  Quantifier
//
//  Created by Scott Zero on 2/26/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTheme.h"

@interface QuantifierTableViewCell : UITableViewCell

{
    __weak IBOutlet UILabel *quantifierNameLabel;
    __weak IBOutlet UILabel *timeLastUpdatedLabel;
    __weak IBOutlet UILabel *mostRecentValueLabel;

    
}

@property (nonatomic, strong) NSString *mostRecentDataPointValueString;
@property (nonatomic, strong) NSString *quantifierName;
@property (nonatomic) NSInteger dataPointCount;
@property (nonatomic) NSDate *mostRecentDataPointsDate;

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date;
- (void)updateContents;

@end
