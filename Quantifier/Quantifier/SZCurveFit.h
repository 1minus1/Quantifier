//
//  SZCurveFit.h
//  CurveFitter
//
//  Created by Scott Zero on 11/10/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCurveFit : NSObject

+(NSArray *)linearFitWithXdata:(NSArray *)xData Ydata:(NSArray *)yData transform:(int)curveType steadyStateValueOrNil:(id)steadyStateValue;


@end
