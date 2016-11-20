//
//  SZDataPoint.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "SZDataPoint.h"

@implementation SZDataPoint

@synthesize timeStamp, dataPointValue,dataPointValueString;

-(id) initWithDataPointValue:(NSNumber *)value

{
    self = [super init];
    if (self) {
        [self setTimeStamp:[[NSDate alloc]init]];
        [self setDataPointValue:value];

        
    }
    return self;
}

-(id) initWithDataPointValue:(NSNumber *)value
                date:(NSDate *)date
                 valueString:(NSString *)valueString;
{
    self = [super init];
    if (self) {
        [self setTimeStamp:date];
        [self setDataPointValue:value];
        [self setDataPointValueString:valueString];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:dataPointValue forKey:@"dataPointValue"];
    [aCoder encodeObject:dataPointValueString forKey:@"dataPointValueString"];

}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setTimeStamp:[aDecoder decodeObjectForKey:@"timeStamp"]];
        [self setDataPointValue:[aDecoder decodeObjectForKey:@"dataPointValue"]];
        [self setDataPointValueString:[aDecoder decodeObjectForKey:@"dataPointValueString"]];
    }
    return self;

}

@end
