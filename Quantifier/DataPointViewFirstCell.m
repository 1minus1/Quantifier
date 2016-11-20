//
//  DataPointViewFirstCell.m
//  Quantifier
//
//  Created by Scott Zero on 3/17/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "DataPointViewFirstCell.h"


@implementation DataPointViewFirstCell

@synthesize valueLabel, pluMinusButton;

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


- (IBAction)togglePosNeg:(id)sender {
    NSString *currentContent = [valueLabel text];
    NSString *justMinusSign = @"-";
    
    if ([currentContent length]==0) {
        NSString *str = @"-";
        [valueLabel setText:str];
    }else if ([currentContent isEqualToString:justMinusSign]){
        NSString *str = @"";
        [valueLabel setText:str];
    }else{
        NSNumber *num = @(-[[valueLabel text] doubleValue]);
        NSString *str = [num stringValue];
        [valueLabel setText:str];
    }
}
@end
