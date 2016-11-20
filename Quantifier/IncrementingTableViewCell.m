//
//  IncrementingTableViewCell.m
//  Quantifier
//
//  Created by Scott Zero on 3/21/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "IncrementingTableViewCell.h"
#import "DataPointViewFirstCell.h"

@implementation IncrementingTableViewCell
@synthesize incrementAmountField,dataPointViewFirstCell,tbdpvc,plusButton,minusButton;

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

- (IBAction)decrementAmount:(id)sender {
    [self incrementAmount:sender];
}

- (IBAction)incrementAmount:(id)sender {
    tbdpvc.quantifier.incrementAmountString=incrementAmountField.text;
    NSString *incrementAmountString;
    
    if ([(UIButton *)sender tag]==1) {
       incrementAmountString  = incrementAmountField.text;
    }else if ([(UIButton *)sender tag]==2){
        incrementAmountString = [@"-" stringByAppendingString:incrementAmountField.text];
    }
    
    NSString *dataPointValueString = dataPointViewFirstCell.valueLabel.text;
    
    
    //////////////////////
    ////// This figures out the number of decimal points in the datapoint value.
    //////////////////////
    NSArray *componentsBeforeAndAfterDecimalInDataPointValueString = [dataPointValueString componentsSeparatedByString:@"."];
    NSInteger numberOfDecimalPointsInDataPoint;
    
    if (componentsBeforeAndAfterDecimalInDataPointValueString.count>1 ) {
        numberOfDecimalPointsInDataPoint=[(NSString *)componentsBeforeAndAfterDecimalInDataPointValueString[1] length];
    } else {
        numberOfDecimalPointsInDataPoint =0;
    }
    
    //////////////////////
    ////// This figures out the number of decimal points in the goal strings value.
    //////////////////////
    
    NSArray *componentsBeforeAndAfterDecimalInGoalValueString = [incrementAmountString componentsSeparatedByString:@"."];
    NSInteger numberOfDecimalPointsInIncrement;
    
    if (componentsBeforeAndAfterDecimalInGoalValueString.count>1 ) {
        numberOfDecimalPointsInIncrement=[(NSString *)componentsBeforeAndAfterDecimalInGoalValueString[1] length];
    } else {
        numberOfDecimalPointsInIncrement =0;
    }
    
    NSInteger biggerNumberOfDecimalPoints;
    if (numberOfDecimalPointsInIncrement>numberOfDecimalPointsInDataPoint) {
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInIncrement;
    }else if (numberOfDecimalPointsInIncrement<numberOfDecimalPointsInDataPoint){
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInDataPoint;
    }else{
        biggerNumberOfDecimalPoints=numberOfDecimalPointsInDataPoint;
    }
    
    double dataPointDouble = [dataPointValueString doubleValue];
    double incrementDouble = [incrementAmountString doubleValue];
    double incrementedDatapoint = dataPointDouble+incrementDouble;
    
    NSString *formatString = [[@"%." stringByAppendingString:[NSString stringWithFormat:@"%d",(int)biggerNumberOfDecimalPoints]]stringByAppendingString:@"lf"];
    
    NSString *newValueString = [NSString stringWithFormat:formatString,incrementedDatapoint];
    self.dataPointViewFirstCell.valueLabel.text=newValueString;
    
    
}
@end
