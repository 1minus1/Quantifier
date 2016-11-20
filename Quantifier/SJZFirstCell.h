//
//  SJZFirstCell.h
//  Quantifier
//
//  Created by Scott Zero on 2/24/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDataPoint.h"

@interface SJZFirstCell : UITableViewCell

{
    __weak IBOutlet UILabel *dataPointValueLabel;
    
    __weak IBOutlet UILabel *timeAgoLabel;
    __weak IBOutlet UILabel *goalComparisonLabel;
}

@property (nonatomic, strong) SZDataPoint *datapoint;
@property (nonatomic, strong) NSNumber *goal;

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date;
- (void)updateContents;
@end
