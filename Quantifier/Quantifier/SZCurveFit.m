//
//  SZCurveFit.m
//  CurveFitter
//
//  Created by Scott Zero on 11/10/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "SZCurveFit.h"
#import <math.h>

@implementation SZCurveFit


+(NSArray *)linearFitWithXdata:(NSArray *)xData Ydata:(NSArray *)yData transform:(int) curveType steadyStateValueOrNil:(id)steadyStateValue;
{
    // curveType values are as follows
    // 0 = linear. y=p1*x+p2;
    //
    // y = p1 + exp(-p2*x)
    
    if (curveType==0) {
        
        NSNumber *sumx = @0;
        NSNumber *sumy = @0;
        NSNumber *sumxx = @0;
        NSNumber *sumxy = @0;
        

        for (int i=0; i<[xData count]; i++) {
            float currentxfloat = [(NSNumber *)xData[i] floatValue];
            float currentyfloat = [(NSNumber *)yData[i] floatValue];
            sumx = @([sumx floatValue]+currentxfloat);
            sumy = @([sumy floatValue]+currentyfloat);
            sumxx =@([sumxx floatValue]+currentxfloat*currentxfloat);
            sumxy =@([sumxy floatValue]+currentxfloat*currentyfloat);
            
        }
        
        NSNumber *meanX = @([sumx floatValue]/[xData count]);
        NSNumber *meanY = @([sumy floatValue]/[xData count]);
        
        NSNumber *slope =     @(([xData count]*[sumxy floatValue]-[sumx floatValue]*[sumy floatValue])/
                                                        ([xData count]*[sumxx floatValue]-[sumx floatValue]*[sumx floatValue]));
        NSNumber *intercept = @([meanY floatValue]-[slope floatValue]*[meanX floatValue]);
        
        NSNumber *ssy =@0;
        NSNumber *ssr =@0;
        
        for (int i=0; i<[xData count]; i++){
            ssy = @(([(NSNumber *)yData[i] floatValue]-[meanY floatValue])*
                                            ([(NSNumber *)yData[i] floatValue]-[meanY floatValue])+[ssy floatValue]);
            ssr = @(([(NSNumber *)yData[i] floatValue]-[intercept floatValue]-[slope floatValue]*[(NSNumber *)xData[i] floatValue])*
                                            ([(NSNumber *)yData[i] floatValue]-[intercept floatValue]-[slope floatValue]*[(NSNumber *)xData[i] floatValue])+[ssr floatValue]);
                   
        }
        
        NSNumber *rsquared = @(1-([ssr floatValue]/[ssy floatValue]));
        
        NSArray *fitValues =@[slope,intercept, rsquared];
        return fitValues;
        
        
    }
    
    if (curveType==1) {
        NSMutableArray *lnYMinusYFinal = [[NSMutableArray alloc]init];
        
        for (int i=0; i<[xData count]; i++) {
            double yminusyfinal = [yData[i]doubleValue]-[(NSNumber *)steadyStateValue doubleValue];
            [lnYMinusYFinal insertObject:@(log(yminusyfinal)) atIndex:i];
        }
        
        NSArray *linearFitValues = [SZCurveFit linearFitWithXdata:xData Ydata:lnYMinusYFinal transform:0 steadyStateValueOrNil:nil];
        
        NSNumber *kValue = linearFitValues[0];
        NSArray *fitValues = @[kValue ,steadyStateValue];
        return fitValues;
    }
    
    
    
    return nil;
}


@end
