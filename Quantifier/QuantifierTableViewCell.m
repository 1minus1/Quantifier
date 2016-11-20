//
//  QuantifierTableViewCell.m
//  Quantifier
//
//  Created by Scott Zero on 2/26/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "QuantifierTableViewCell.h"



@implementation QuantifierTableViewCell

@synthesize quantifierName,mostRecentDataPointValueString,mostRecentDataPointsDate,dataPointCount;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateContents
{
    [quantifierNameLabel setText:quantifierName];
    if (mostRecentDataPointsDate)
    {
        [timeLastUpdatedLabel setText:[@"Updated " stringByAppendingString:[self shortStringOfTimeSinceNowFromNSDate:mostRecentDataPointsDate]]];
        [mostRecentValueLabel setText:mostRecentDataPointValueString];
    }else{
        [timeLastUpdatedLabel setText:@"No data."];
        [mostRecentValueLabel setText:@""];
    }
    
    
    
    UIColor *backgroundColor = [SZTheme backgroundColor];
    self.backgroundColor = backgroundColor;
    NSString *fontString = [SZTheme fontString];
    quantifierNameLabel.font = [UIFont fontWithName:fontString size:18];
    UIColor *detailTextColor = [SZTheme detailTextColor];
    
    timeLastUpdatedLabel.textColor = detailTextColor;
    UIColor *mainTextColor = [SZTheme mainTextColor];
    UIColor *selectedCellColor = [SZTheme selectedCellColor];
    
    quantifierNameLabel.textColor = mainTextColor;
    
    
    timeLastUpdatedLabel.font = [UIFont fontWithName:fontString size:13];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor= selectedCellColor;

    mostRecentValueLabel.textColor=[SZTheme tintColor];
    mostRecentValueLabel.font=[UIFont fontWithName:[SZTheme thinFontString] size:24 ];
}


- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateShowingEditControlMask) {
        // edit mode : peform operations on the cell outlets here
        mostRecentValueLabel.textColor=[SZTheme backgroundColor];
    } else if (state ==UITableViewCellStateDefaultMask) {
        mostRecentValueLabel.textColor=[SZTheme tintColor];
    }
}

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date
{
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here. This method is different in that it requires cases for plural stuff. Copied directly into QuantifierTableViewCell.m from SJZFirstCell.m
    
    NSDate *nowdate =[[NSDate alloc]init];
    NSTimeInterval interval = [nowdate timeIntervalSinceDate:date];
    int intervalint = interval ;
    
    
    if (intervalint<20) {
        return [NSString stringWithFormat:@"just now"];
    }
    if (intervalint<60) {
        return [NSString stringWithFormat:@"1 minute ago"];
    }
    if (intervalint<3600) {
        int minutes = (intervalint+60/2)/60;
        NSString *firstHalf;
        if (minutes==1) {
            firstHalf= @"%d minute ago";
        }else{
            firstHalf= @"%d minutes ago";
        }
        return [NSString stringWithFormat:firstHalf, minutes];
    }
    if (intervalint<86400) {
        int hours = (intervalint+60*60/2)/3600;
        NSString *firstHalf;
        if (hours==1) {
            firstHalf= @"%d hour ago";
        }else{
            firstHalf= @"%d hours ago";
        }
        return [NSString stringWithFormat:firstHalf, hours];
        
    }
    if (intervalint<2419200) {
        // this uses days until 24 days, then switches to weeks below -- this means that the non-plural case for weeks below isn't needed.
        int days = (intervalint+60*60*24/2)/86400;
        NSString *firstHalf;
        if (days==1) {
            firstHalf= @"%d day ago";
        }else{
            firstHalf= @"%d days ago";
        }
        return [NSString stringWithFormat:firstHalf, days];
        
    }
    
    return [NSString stringWithFormat:@"%d weeks ago", (intervalint+60*60*24*7/2)/604800];
    
}


@end
