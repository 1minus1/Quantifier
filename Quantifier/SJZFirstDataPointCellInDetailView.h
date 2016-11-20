//
//  SJZFirstDataPointCellInDetailView.h
//  Quantifier
//
//  Created by Scott Zero on 2/24/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZDataPoint.h"

@interface SJZFirstDataPointCellInDetailView : UITableViewCell

{

    __weak IBOutlet UILabel *dataPointValueField;
    __weak IBOutlet UILabel *goalComparisonLabel;
    __weak IBOutlet UILabel *timeAgoLabel;
}
@property (nonatomic, weak) SZDataPoint *datapoint;
@property (nonatomic, weak) NSNumber *goal;

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date;


@end
