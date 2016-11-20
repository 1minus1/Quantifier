//
//  SZDataPoint.h
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDataPoint : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSNumber *dataPointValue;
@property (nonatomic, strong) NSString *dataPointValueString;


-(id) initWithDataPointValue:(NSNumber *)value;

-(id) initWithDataPointValue:(NSNumber *)value
                        date:(NSDate *)date
                 valueString:(NSString *)valueString;
@end
