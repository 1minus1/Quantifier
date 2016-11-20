//
//  SZQuantifier.h
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//
@import CoreMotion;
#import <Foundation/Foundation.h>
#import "SZDataPoint.h"
#import "SZQuantifierStore.h"

@interface SZQuantifier : NSObject <NSCoding>

@property (nonatomic, strong) NSString *quantifierName;
@property (nonatomic, strong) NSMutableArray *dataSet;
@property (nonatomic, strong) NSString *csvContents;
@property (nonatomic, strong) UIImageView *plot;
@property (nonatomic, strong) NSMutableArray *plotXLocations;
@property (nonatomic, strong) NSMutableArray *plotYLocations;
@property (nonatomic, strong) UIImage *blurredScreenShot;
@property (nonatomic, strong) NSNumber *mean;
@property (nonatomic, strong) NSNumber *max;
@property (nonatomic, strong) NSNumber *min;
@property (nonatomic, strong) NSNumber *range;
@property (nonatomic, strong) NSNumber *median;
@property (nonatomic, strong) NSNumber *sum;
@property (nonatomic, strong) NSNumber *countOfDataPoints;
@property (nonatomic, strong) NSNumber *goal;
@property (nonatomic, strong) NSDate *dateSinceForPlot;
@property (nonatomic, strong) NSString *statisticsTitle;
@property (nonatomic) NSInteger selectedRow;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic) BOOL hasSegmentedControlInDetailView;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *timeLastUpdatedStepCounter;
@property (nonatomic, strong) NSString *incrementAmountString;
@property (nonatomic, strong) CMPedometer *myStepCounter;



-(id) initWithQuantifierName:(NSString *)name
                        type:(NSString *)thisType
                dataSetOrNil:(id)dataSet;

-(void) addDataPoint:(SZDataPoint *)dataPoint;
-(void) removeDataPoint:(SZDataPoint *)datapoint;
-(void) updateCsvContents;
-(void) updatePlot;
-(NSMutableArray *) dataSetSinceDate:(NSDate *)dateSince;
-(NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date;
-(void) updateStats;
-(void) sortDataSet;
-(void) updateAutoStepTracker;
-(NSOperationQueue *)operationQueue;
-(NSInteger)heightForPlotHeaderViewWithoutSegmentedButton;

+(SZQuantifier *)randomQuantifier;


@end
