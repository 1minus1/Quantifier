//
//  SJZFirstDataPointCellInDetailView.m
//  Quantifier
//
//  Created by Scott Zero on 2/24/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "SJZFirstDataPointCellInDetailView.h"

@implementation SJZFirstDataPointCellInDetailView
@synthesize datapoint,goal;


- (void)awakeFromNib
{
    [dataPointValueField setText:datapoint.dataPointValueString];
    [timeAgoLabel setText:[self shortStringOfTimeSinceNowFromNSDate:datapoint.timeStamp]];
    
    NSArray *componentsBeforeAndAfterDecimalInDataPointValueString = [datapoint.dataPointValueString componentsSeparatedByString:@"."];
    NSInteger numberOfDecimalPointsInLastDataPoint;
    
    if (componentsBeforeAndAfterDecimalInDataPointValueString.count>1 ) {
        numberOfDecimalPointsInLastDataPoint=[(NSString *)[componentsBeforeAndAfterDecimalInDataPointValueString objectAtIndex:1] length];
    } else {
        numberOfDecimalPointsInLastDataPoint =0;
    }
    
    
    if (self.goal) {
        double dataPointDouble = [datapoint.dataPointValue doubleValue];
        double goalDouble =[self.goal doubleValue];
        double goalDiff = dataPointDouble-goalDouble;
        double negGoalDiff = goalDiff*-1;
        
        NSString *formatString = [[@"%." stringByAppendingString:[NSString stringWithFormat:@"%d",(int)numberOfDecimalPointsInLastDataPoint]]stringByAppendingString:@"lf"];
        
        
        NSString *goalDiffString = [NSString stringWithFormat:formatString,goalDiff];
        NSString *negGoalDiffString = [NSString stringWithFormat:formatString,negGoalDiff];
        NSString *stringForCellWithComparisonToGoalValue;
        
        if (goalDiff <0) {
            stringForCellWithComparisonToGoalValue = [[[datapoint.dataPointValueString stringByAppendingString:@"" ] stringByAppendingString:negGoalDiffString] stringByAppendingString:@" less than the goal"];
            
        } else if (goalDiff>0){
            stringForCellWithComparisonToGoalValue = [[[datapoint.dataPointValueString stringByAppendingString:@"" ] stringByAppendingString:goalDiffString] stringByAppendingString:@" more than the goal"];
        } else{
            stringForCellWithComparisonToGoalValue = [datapoint.dataPointValueString stringByAppendingString:@"Right on the goal"];
            
        }
        [goalComparisonLabel setText:stringForCellWithComparisonToGoalValue];
    } else {
        [goalComparisonLabel setText:@"No goal has been set."];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date
{
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here.
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here.
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here.
    
    
    NSDate *nowdate =[[NSDate alloc]init];
    NSTimeInterval interval = [nowdate timeIntervalSinceDate:date];
    int intervalint = interval ;
    
    
    if (intervalint<5) {
        return [NSString stringWithFormat:@"Now"];
    }
    if (intervalint<60) {
        return [NSString stringWithFormat:@"Less than 1 minute ago"];
    }
    if (intervalint<3600) {
        return [NSString stringWithFormat:@"%d minutes ago", (intervalint+60/2)/60];
    }
    if (intervalint<86400) {
        return [NSString stringWithFormat:@"%d hours ago", (intervalint+60*60/2)/3600];
    }
    if (intervalint<2419200) {
        return [NSString stringWithFormat:@"%d days ago", (intervalint+60*60*24/2)/86400];
    }
    return [NSString stringWithFormat:@"%d weeks ago", (intervalint+60*60*24*7/2)/604800];
    
}

@end
