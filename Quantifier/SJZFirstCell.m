//
//  SJZFirstCell.m
//  Quantifier
//
//  Created by Scott Zero on 2/24/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "SJZFirstCell.h"
#import "SZTheme.h"

@implementation SJZFirstCell
@synthesize datapoint,goal;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];

}
-(void)updateContents
{
    [dataPointValueLabel setText:datapoint.dataPointValueString];
    
    
    NSDate *dataPointsTimeStamp = self.datapoint.timeStamp;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dataPointsTimeStamp];
    NSDate *justDayOfNewDateForNewDataPoint = [cal dateFromComponents:components];
    
    BOOL dateIsToday;
    
    if([today isEqualToDate:justDayOfNewDateForNewDataPoint]) {
        dateIsToday=YES;
    }else{
        dateIsToday=NO;
    }
    
    NSString *stringFromDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    if (dateIsToday) {
        [formatter setDateFormat:@"h:mm a"];
    }else{
        [formatter setDateFormat:@"MMMM d, y 'at' h:mm a"];
    }
    
    stringFromDate = [formatter stringFromDate:dataPointsTimeStamp];
    
    
    
    
    [timeAgoLabel setText:[[self shortStringOfTimeSinceNowFromNSDate:datapoint.timeStamp] stringByAppendingString:[NSString stringWithFormat:@" (%@)",stringFromDate]]];
    
    //////////////////////
    ////// This figures out the number of decimail points in the datapoint value.
    //////////////////////
    NSArray *componentsBeforeAndAfterDecimalInDataPointValueString = [datapoint.dataPointValueString componentsSeparatedByString:@"."];
    NSInteger numberOfDecimalPointsInLastDataPoint;
    
    if (componentsBeforeAndAfterDecimalInDataPointValueString.count>1 ) {
        numberOfDecimalPointsInLastDataPoint=[(NSString *)componentsBeforeAndAfterDecimalInDataPointValueString[1] length];
    } else {
        numberOfDecimalPointsInLastDataPoint =0;
    }
    
    //////////////////////
    ////// This figures out the number of decimail points in the goal strings value.
    //////////////////////
    
    NSArray *componentsBeforeAndAfterDecimalInGoalValueString = [[goal stringValue] componentsSeparatedByString:@"."];
    NSInteger numberOfDecimalPointsInGoal;
    
    if (componentsBeforeAndAfterDecimalInGoalValueString.count>1 ) {
        numberOfDecimalPointsInGoal=[(NSString *)componentsBeforeAndAfterDecimalInGoalValueString[1] length];
    } else {
        numberOfDecimalPointsInGoal =0;
    }
    
    NSInteger biggerNumberOfDecimalPoints;
    if (numberOfDecimalPointsInGoal>numberOfDecimalPointsInLastDataPoint) {
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInGoal;
    }else if (numberOfDecimalPointsInGoal<numberOfDecimalPointsInLastDataPoint){
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInLastDataPoint;
    }else{
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInLastDataPoint;
    }
    
    
    
    if (self.goal) {
        double dataPointDouble = [datapoint.dataPointValue doubleValue];
        double goalDouble =[self.goal doubleValue];
        double goalDiff = dataPointDouble-goalDouble;
        double negGoalDiff = goalDiff*-1;
        
        NSString *formatString = [[@"%." stringByAppendingString:[NSString stringWithFormat:@"%d",(int)biggerNumberOfDecimalPoints]]stringByAppendingString:@"lf"];
        
        
        NSString *goalDiffString = [NSString stringWithFormat:formatString,goalDiff];
        NSString *negGoalDiffString = [NSString stringWithFormat:formatString,negGoalDiff];
        NSString *stringForCellWithComparisonToGoalValue;
        
        if (goalDiff <0) {
            stringForCellWithComparisonToGoalValue = [negGoalDiffString stringByAppendingString:@" less than your goal."];
            
        } else if (goalDiff>0){
            stringForCellWithComparisonToGoalValue = [goalDiffString stringByAppendingString:@" more than your goal."];
        } else{
            stringForCellWithComparisonToGoalValue = @"Right on your goal. Nice work.";
            
        }
        [goalComparisonLabel setText:stringForCellWithComparisonToGoalValue];
    } else {
        [goalComparisonLabel setText:@"No goal has been set."];
    }
    
    [dataPointValueLabel setTextColor:[SZTheme tintColor]];
    [dataPointValueLabel setFont:[UIFont fontWithName:[SZTheme thinFontString] size:31]];
    [goalComparisonLabel setTextColor:[SZTheme mainTextColor]];
    [timeAgoLabel setTextColor:[SZTheme detailTextColor]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date
{
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here. This method is different in that it requires cases for plural stuff. Copied directly into QuantifierTableViewCell.m from SJZFirstCell.m
    
    NSDate *nowdate =[[NSDate alloc]init];
    NSTimeInterval interval = [nowdate timeIntervalSinceDate:date];
    int intervalint = interval ;
    
    
    if (intervalint<5) {
        return [NSString stringWithFormat:@"Updated just now"];
    }
    if (intervalint<60) {
        return [NSString stringWithFormat:@"Less than 1 minute ago"];
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
