//
//  SZQuantifier.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//


#import "SZQuantifier.h"
#import "SZTheme.h"
#import "SZDataPoint.h"


@implementation SZQuantifier

@synthesize quantifierName, dataSet, csvContents,plot, plotXLocations, plotYLocations,blurredScreenShot,mean, min, max, range, median, sum, dateSinceForPlot, statisticsTitle,selectedRow, hasSegmentedControlInDetailView, type, goal, countOfDataPoints,incrementAmountString;


-(id) initWithQuantifierName:(NSString *)name type:(NSString *)thisType dataSetOrNil:(id)data
{
    // Inititate the quantifier
    self = [super init];
    
    if (self) {
        // Define the names and types as the input values/
        [self setQuantifierName:name];

        [self setCsvContents:Nil];
        
        // If there is data recieved, initiate the instance with data. Otherwise, create a new empty NSMutableArray.
        if (data) {
            [self setDataSet:data];
        } else {
            [self setDataSet:[[NSMutableArray alloc] init]];
        }
    }
    if (![thisType isEqualToString:@"importTest"]) {
        self.type=thisType;
        [self updateCsvContents];
    }
    

    return self;
}

-(void) addDataPoint:(SZDataPoint *)dataPoint
{
    [self.dataSet addObject:dataPoint];
    [self updateStats];
    [[SZQuantifierStore sharedStore] saveChangesInBackground];
}

-(void) removeDataPoint:(SZDataPoint *)datapoint;
{
    [self.dataSet removeObjectIdenticalTo:datapoint];
    if ([self.dataSet count]==0) {
        [self setMean:nil];
        [self setMedian:nil];
        [self setMin:nil];
        [self setMax:nil];
        [self setRange:nil];
        [self setSum:nil];
        [self setCountOfDataPoints:nil];
    } else {
        [self updateStats];
    }
    [[SZQuantifierStore sharedStore] saveChangesInBackground];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:quantifierName forKey:@"quantifierName"];
    [aCoder encodeObject:dataSet forKey:@"dataSet"];
    [aCoder encodeObject:csvContents forKey:@"csvContents"];
    [aCoder encodeObject:type forKey:@"type"];
    [aCoder encodeObject:goal forKey:@"goal"];
    //[aCoder encodeObject:plot forKey:@"plot"];
    [aCoder encodeObject:plotXLocations forKey:@"plotXLocations"];
    [aCoder encodeObject:plotYLocations forKey:@"plotYLocations"];
    [aCoder encodeObject:incrementAmountString forKey:@"incrementAmountString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        [self setQuantifierName:[aDecoder decodeObjectForKey:@"quantifierName"]];
        [self setDataSet:[aDecoder decodeObjectForKey:@"dataSet"]];
        [self setCsvContents:[aDecoder decodeObjectForKey:@"csvContents"]];
        [self setType:[aDecoder decodeObjectForKey:@"type"]];
        [self setGoal:[aDecoder decodeObjectForKey:@"goal"]];
        //[self setPlot:[aDecoder decodeObjectForKey:@"plot"]];
        [self setPlotXLocations:[aDecoder decodeObjectForKey:@"plotXLocations"]];
        [self setPlotYLocations:[aDecoder decodeObjectForKey:@"plotYLocations"]];
        [self setIncrementAmountString:[aDecoder decodeObjectForKey:@"incrementAmountString"]];
        
    }
    return self;
}

+(SZQuantifier *)randomQuantifier
{
    NSString *newQuantifierName = [[NSString alloc]initWithFormat:@"z"];
    NSMutableArray *listOfQuant = [[NSMutableArray alloc]init];
    for (SZQuantifier *quant in [[SZQuantifierStore sharedStore] allQuantifiers]){
        [listOfQuant addObject:[quant quantifierName]];
    };
//    int thisnum = [listOfQuant indexOfObjectIdenticalTo:newQuantifierName];
//    while ([listOfQuant indexOfObjectIdenticalTo:newQuantifierName] != NSNotFound) {
//        newQuantifierName = [newQuantifierName stringByAppendingString:[[NSString alloc]initWithFormat:@"ha"]];
//        int thisnum = [listOfQuant indexOfObjectIdenticalTo:newQuantifierName];
//        1;
//    }
    
    if ([listOfQuant containsObject:newQuantifierName]) {
        newQuantifierName = [NSString stringWithFormat:@"%lu", (unsigned long)[[[SZQuantifierStore sharedStore] allQuantifiers]count]];

    }
    
    
    SZQuantifier *q = [[SZQuantifier alloc] initWithQuantifierName:newQuantifierName type:@"type1" dataSetOrNil:nil];
    
    int numberOfFakeDataPoints = 10;
    
    for (int i=0; i<numberOfFakeDataPoints; i++) {
        
        NSNumber *thisNum = @(10*cosf(i)+10.0f);
            [q addDataPoint:[[SZDataPoint alloc]initWithDataPointValue:thisNum
                                                                  date:[[NSDate alloc] initWithTimeIntervalSinceNow:-numberOfFakeDataPoints*10+1500*i]
                             valueString:[thisNum stringValue]
                             ]];
   
        
        

    }
    [q updateCsvContents];
    [[SZQuantifierStore sharedStore] writeThisQuantifiersCSVToLocalAndDropboxDirectory:q];
    return q;
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc]initWithFormat:@"%@, %lu entries",quantifierName, (unsigned long)[dataSet count]];
    return  descriptionString;
}
- (void)updateCsvContents
{
    // Generate the csv file contents
    // time, data
    NSString *mainString = [[NSMutableString alloc]initWithString:@"Timestamp,"];
    mainString = [mainString stringByAppendingString:[self quantifierName]];
    // mainString = [mainString stringByAppendingString:@"\n"];
    
    for (SZDataPoint *datapoint in [self dataSet]) {
        NSString *thisCsvLine = [[NSString alloc] init];
        thisCsvLine = @"\n";
        NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stringFromTimeStamp = [formatter stringFromDate:[datapoint timeStamp]];
        
        thisCsvLine = [thisCsvLine stringByAppendingString:stringFromTimeStamp];
        thisCsvLine = [thisCsvLine stringByAppendingString:@","];
        // The following line replaces commas in the value string with periods, for those silly Europeans, who can deal with periods.
        thisCsvLine = [thisCsvLine stringByAppendingString:[[[datapoint dataPointValueString] stringByReplacingOccurrencesOfString:@"," withString:@"."]stringByReplacingOccurrencesOfString:@" " withString:@""]];
       // thisCsvLine = [thisCsvLine stringByAppendingString:@"\n"];
        
        mainString = [mainString stringByAppendingString:thisCsvLine];
    }
    
    NSLog(@"csvstring for quantifier %@ updated",[self quantifierName]);
    
    
    [self setCsvContents:mainString];

}

-(NSInteger)heightForPlotHeaderViewWithoutSegmentedButton
{
    
    NSInteger screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    NSLog(@"Screen Height: %ld",(long)screenHeight);
    
    NSInteger out = [[NSNumber numberWithDouble:[[NSNumber numberWithInteger:200] doubleValue]*([[NSNumber numberWithInteger:screenHeight] doubleValue]/[[NSNumber numberWithInteger: 568] doubleValue])] integerValue];
    
    if (out>300) {
        out=300;
    }
    
    if (out<200){
        out=200;
    }
    
        
    
    return out;
}

- (void)updatePlot
{
    
    NSMutableArray *dataSetToPlot = [[NSMutableArray alloc]init];
    if (self.dateSinceForPlot==nil) {
        dataSetToPlot=self.dataSet;
    }else{
        NSMutableArray *subsetBasedOnTheDate = [self dataSetSinceDate:self.dateSinceForPlot];
        dataSetToPlot=subsetBasedOnTheDate;
    }
    
    NSInteger f;
    if (hasSegmentedControlInDetailView) {
        f=35;
    }else{
        f=0;
    }
    
    
    NSInteger plotImageHeight;
    if ([dataSetToPlot count]<2) {
        plotImageHeight = 0;
    }else{
        
        plotImageHeight = self.heightForPlotHeaderViewWithoutSegmentedButton+f;
        
        
    };
    
    int plotImageWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, plotImageHeight ) , NO, 0.0f);
    //CGContextRef contexter = UIGraphicsGetCurrentContext();
    //CGContextSetShouldAntialias(contexter, YES);
    
    UIBezierPath *backgroundPath = [UIBezierPath bezierPath];
    
    // Draw the background of the image, which does not include the fill in the plots uibezierpath (below the line of data.
    
    [backgroundPath moveToPoint:CGPointMake(0, 0)];
    [backgroundPath addLineToPoint:CGPointMake(0, plotImageHeight)];
    [backgroundPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, plotImageHeight)];
    [backgroundPath addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, 0)];
    [backgroundPath addLineToPoint:CGPointMake(0, 0)];
    
    UIColor *backgroundColor = [SZTheme backgroundColor];
    
    [backgroundColor setFill];
    [backgroundColor setStroke];
    [backgroundPath stroke];
    [backgroundPath fill];
    
//    UIColor *sameColorAsSystemBlue =[UIColor colorWithRed:0.0f/255.0f
//                                                    green:122.0f/255.0f
//                                                     blue:255.0f/255.0f
//                                                    alpha:1];
//
    

    
    if ([dataSetToPlot count]<2) {
        NSLog(@"Not enough data to plot.");
        
        
        // This is the code that generated an arrow to point to the plus sign.
        
        //        UIBezierPath *arrowPath = [UIBezierPath dqd_bezierPathWithArrowFromPoint:CGPointMake(plotImageWidth*0.8, plotImageHeight*.3) toPoint:CGPointMake(plotImageWidth*.88, plotImageHeight*0.06) tailWidth:3 headWidth:10 headLength:5] ;
        //
        //        [[UIColor clearColor] setStroke];
        //        [sameColorAsSystemBlue setFill];
        //        [arrowPath stroke];
        //        [arrowPath fill];
        //
        //
        UIImage *plottedImage =UIGraphicsGetImageFromCurrentImageContext();
        
        
        UIImageView *plotImageView =[[UIImageView alloc] initWithImage:plottedImage];
        //CGContextRelease(contexter);
        UIGraphicsEndImageContext();
        
        [self setPlot:plotImageView];
        
    }else{
        NSMutableArray *dataPointValues = [[NSMutableArray alloc]init];
        NSMutableArray *dateValues = [[NSMutableArray alloc]init];
        NSMutableArray *dateIntervals = [[NSMutableArray alloc]init];
        
        
        
        for (SZDataPoint *datapoint in dataSetToPlot ) {
            
            [dataPointValues addObject:[datapoint dataPointValue]];
            [dateValues addObject:[datapoint timeStamp]];
            [dateIntervals addObject:@([[datapoint timeStamp] timeIntervalSinceDate: [dataSetToPlot[0]timeStamp]])];
            
        }
        
        
        NSUInteger b=30;
        NSUInteger c=20;
        NSUInteger heightBetweenTopOfPlotAndHighestDatapoint = 20;
        NSUInteger widthBetweenLeftSideOfPlotAndLeftMostDatapoint = 10;
        NSUInteger widthBetweenRightSideOfPlotAndRightmostDataPoint =10;
        NSUInteger plottedLineWidth = plotImageWidth-widthBetweenLeftSideOfPlotAndLeftMostDatapoint-widthBetweenRightSideOfPlotAndRightmostDataPoint;
        
        
        
        
        NSUInteger a=plotImageHeight-f;
        //int bPlusC=heightBetweenBottomOfPlotAndLowestDataPoint;
        NSUInteger e=heightBetweenTopOfPlotAndHighestDatapoint;
        NSUInteger h=widthBetweenLeftSideOfPlotAndLeftMostDatapoint;
        NSUInteger j=widthBetweenRightSideOfPlotAndRightmostDataPoint;
        //int k=plottedLineWidth;
        NSUInteger d=a-c-b-e;
        
        /////////////////////////////
        /////////////////////////////
        /////////////////////////////
        
        /// Here the min and max values are pulled from the **entire** data set so the y axis of the plot doesn't scale oddly when the uisegmented control is used.
        
        NSMutableArray *allDataPointsFromTheDataSet=[NSMutableArray new];
        
        for (SZDataPoint *datapoint in self.dataSet) {
            [allDataPointsFromTheDataSet addObject:[datapoint dataPointValue]];
        }
        
        NSNumber *y2 = [NSNumber numberWithDouble:[[allDataPointsFromTheDataSet     valueForKeyPath:@"@max.self"]doubleValue]];
        NSNumber *y1 = [NSNumber numberWithDouble:[[allDataPointsFromTheDataSet valueForKeyPath:@"@min.self"] doubleValue]];
        
        /////////////////////////////
        ////// Now y1 and y2 are adjusted if the goal value changes one of them;
        /////////////////////////////
        
        if ([goal floatValue]>[y2 floatValue] && goal) {
            y2=@([goal doubleValue]);
        }
        
        if ([goal doubleValue]<[y1 doubleValue] && goal) {
            y1=goal;
        }
        
        /////////////////////////////
        /////////////////////////////
        /////////////////////////////
        
        
        NSInteger y1Rounded = [@([y1 doubleValue]-0.999999) intValue];
        
        double tempy2Doub =[y2 doubleValue]+0.999999;
        NSInteger y2Rounded = [@(tempy2Doub) intValue];
        
        
        y2 = @(y2Rounded);
        y1 = [NSNumber numberWithDouble:y1Rounded];
        
        /// If everything is positive and the scale of the numbers isn't too bad, make the bottom of the x-axis 0;
        
        
        
        if ([y1 doubleValue]>0) {
            if (y2>0 && [y1 doubleValue]/[y2 doubleValue]<0.51) {
                y1=@0;
            }
            
        }
        
        if ([y1 isEqual:y2]) {
            y2 = @([y2 doubleValue]+1);
            y1 = @([y1 doubleValue]-1);
            
        }
        
        NSNumber *maxTimeInterval = [dateIntervals valueForKeyPath:@"@max.self"];
        
        NSMutableArray *xValues = [[NSMutableArray alloc]init];
        NSMutableArray *yValues = [[NSMutableArray alloc]init];
        
        /// Define the x value (in terms of pixels) for each data point;
        
        for (NSNumber *intervall in dateIntervals) {
            
            double ratio = [intervall doubleValue]/[maxTimeInterval doubleValue];
            double prod = ratio * plottedLineWidth;
            double prodPlusLeftMargin = prod + widthBetweenLeftSideOfPlotAndLeftMostDatapoint;
            
            NSNumber *thisX = @(prodPlusLeftMargin);
            [xValues addObject:thisX];
          
            
        }
        
        /// Define the y value (in terms of pixels) for each data point;
        
        for (NSNumber *pointvalue in dataPointValues) {
            
            double ratio = ([pointvalue doubleValue]-[y1 doubleValue])/([y2 doubleValue]-[y1 doubleValue]);
            
            double yFromBottom=f+b+c+d*ratio;
            NSNumber *thisY= @(yFromBottom);
            
            
            //double prod = ratio * (plotImageHeight-heightBetweenBottomOfPlotAndLowestDataPoint
            //                       -heightBetweenTopOfPlotAndHighestDatapoint);
            //double yval = (prod+heightBetweenBottomOfPlotAndLowestDataPoint);
            //NSNumber *thisY = [NSNumber numberWithDouble:yval];
           
            
            [yValues addObject:thisY];
            
        }
        
        /// Define the y value for the goal line if there should be one
        
        if (goal) {
            double ratio = ([goal doubleValue]-[y1 doubleValue])/([y2 doubleValue]-[y1 doubleValue]);
            
            double yFromBottom=f+b+c+d*ratio;
            NSNumber *yValForGoalLine= @(yFromBottom);
            UIBezierPath *goalPath = [UIBezierPath bezierPath];
            [goalPath moveToPoint:CGPointMake([@(h)floatValue], plotImageHeight-[yValForGoalLine floatValue])];
            [goalPath addLineToPoint:CGPointMake(plotImageWidth, plotImageHeight-[yValForGoalLine floatValue])];
            goalPath.lineWidth=1.;
            [[SZTheme goalLineColor] setStroke];
            [goalPath stroke];
        }
        
        
        
        
        
        [self setPlotXLocations:xValues];
        [self setPlotYLocations:yValues];
        
        /// Create the bezier path for the plotted data;
        
        UIBezierPath *aPath = [UIBezierPath bezierPath];
        // Set the starting point of the shape.
        
        float xxfirst = [xValues[0]floatValue];
        float yyfirst = plotImageHeight-[yValues[0]floatValue];
        [aPath moveToPoint:CGPointMake(xxfirst,yyfirst )];
        
        // Draw the lines.
        
        for (int i=0; i<[xValues count]; i++) {
            float xx=[xValues[i] floatValue];
            float yy=plotImageHeight-[yValues[i] floatValue];
            [aPath addLineToPoint:CGPointMake(xx,yy)];
        }
        
        //[aPath addLineToPoint:CGPointMake(plotImageWidth, plotImageHeight)];
        //[aPath addLineToPoint:CGPointMake(0, plotImageHeight)];
        //[aPath addLineToPoint:CGPointMake(0, yyfirst)];
        //[aPath closePath];
        
        
        aPath.lineWidth = 1.5f;
        
        UIColor *tintColor = [SZTheme tintColor];
        
        [tintColor setStroke];
        [[UIColor whiteColor] setFill];
        
        
        [aPath stroke];
        //[aPath fill];
        
        
        NSNumber *middleValue = @(([y2 doubleValue]+[y1 doubleValue])/2);
        
        
        
        // Make a middle tick on the y axis if all plotted values are the same
        
        NSMutableArray *yAxisLabeledTickValues = [[NSMutableArray alloc]init];

        
        if (y1Rounded==y2Rounded) {
            [yAxisLabeledTickValues addObject:middleValue];
        } else{
            
            if ([y1 isEqualToValue: @0]) {
                [yAxisLabeledTickValues addObject:@0];
            }else {
            [yAxisLabeledTickValues addObject:@(y1Rounded)];
            }
            
            [yAxisLabeledTickValues addObject:@(y2Rounded)];
        }
        
        NSString *fontString = [SZTheme fontString];
        UIColor *mainTextColor = [SZTheme mainTextColor];
        
        NSDictionary *textAttributes = @{NSFontAttributeName: [UIFont fontWithName:fontString size:14],
                                        NSForegroundColorAttributeName: mainTextColor};
        
        
        UIBezierPath *yAxisPath = [UIBezierPath bezierPath];
        
        int xLocationOfYaxis = 10;

        int axisTickLength = 7;
        
        [yAxisPath moveToPoint:CGPointMake(xLocationOfYaxis, 0)];
        [yAxisPath addLineToPoint:CGPointMake(xLocationOfYaxis, plotImageHeight-b-f)];
        
        for (NSNumber *pointvalue in yAxisLabeledTickValues){
            double ratio = ([pointvalue doubleValue]-[y1 doubleValue])/([y2 doubleValue]-[y1 doubleValue]);
            
            double yFromBottom=f+b+c+d*ratio;
            NSNumber *thisY= @(yFromBottom);
//            double ratio = ([pointvalue doubleValue]-[minValue doubleValue])/([maxValue doubleValue]-[minValue doubleValue]);
//            double prod = ratio * (plotImageHeight-heightBetweenBottomOfPlotAndLowestDataPoint
//                                   -heightBetweenTopOfPlotAndHighestDatapoint);
//            double yval = (prod+heightBetweenBottomOfPlotAndLowestDataPoint);
//            NSNumber *thisY = [NSNumber numberWithDouble:yval];
            
            [[pointvalue stringValue] drawAtPoint:CGPointMake(xLocationOfYaxis+10, plotImageHeight-[thisY doubleValue]-9) withAttributes:textAttributes];
            [yAxisPath addLineToPoint:CGPointMake(xLocationOfYaxis, plotImageHeight-[thisY doubleValue])];
            [yAxisPath addLineToPoint:CGPointMake(xLocationOfYaxis+axisTickLength, plotImageHeight-[thisY doubleValue])];
            [yAxisPath addLineToPoint:CGPointMake(xLocationOfYaxis, plotImageHeight-[thisY doubleValue])];
        }
        
        yAxisPath.lineWidth = 1.0f;
        [yAxisPath stroke];
        
        
        
        NSDate *firstDate = [dateValues firstObject];
        NSDate *lastDate  = [dateValues lastObject];
        NSString *firstDateString = [self shortStringOfTimeSinceNowFromNSDate:firstDate];
        NSString *lastDateString = [self shortStringOfTimeSinceNowFromNSDate:lastDate];
        
        UIBezierPath *xAxisPath = [[UIBezierPath alloc] init];
        
        [xAxisPath moveToPoint:CGPointMake(0, plotImageHeight-b-f)];
        [xAxisPath addLineToPoint:CGPointMake(widthBetweenLeftSideOfPlotAndLeftMostDatapoint, plotImageHeight-b-f)];
        [xAxisPath addLineToPoint:CGPointMake(widthBetweenLeftSideOfPlotAndLeftMostDatapoint, plotImageHeight-b-f+axisTickLength)];
        [xAxisPath addLineToPoint:CGPointMake(widthBetweenLeftSideOfPlotAndLeftMostDatapoint, plotImageHeight-b-f)];
        [xAxisPath addLineToPoint:CGPointMake(plotImageWidth-j, plotImageHeight-b-f)];
        [xAxisPath addLineToPoint:CGPointMake(plotImageWidth-j, plotImageHeight-b-f+axisTickLength)];
        [xAxisPath addLineToPoint:CGPointMake(plotImageWidth-j, plotImageHeight-b-f)];
        [xAxisPath addLineToPoint:CGPointMake(plotImageWidth, plotImageHeight-b-f)];
        xAxisPath.lineWidth = 1.0f;
        [xAxisPath stroke];
        
        [firstDateString drawAtPoint:CGPointMake(5, plotImageHeight-22-f) withAttributes:textAttributes];
        NSAttributedString *lastDateStringAttributed = [[NSAttributedString alloc] initWithString:lastDateString attributes:textAttributes];
        int widthOfLastDateString = [lastDateStringAttributed size].width;
        [ lastDateString drawAtPoint:CGPointMake(plotImageWidth-widthOfLastDateString-5, plotImageHeight-22-f) withAttributes:textAttributes];
        
        
        
        
        
        
//        // This draw a single pixel line between the graph and the table.
//        UIBezierPath *separatorPath = [UIBezierPath bezierPath];
//        
//        [separatorPath moveToPoint:CGPointMake(0, plotImageHeight)];
//        [separatorPath addLineToPoint:CGPointMake(plotImageWidth, plotImageHeight)];
//        [[UIColor lightGrayColor] setStroke];
//        [separatorPath stroke];
        
        
        
        UIImage *plottedImage =UIGraphicsGetImageFromCurrentImageContext();
        
        
        UIImageView *plotImageView =[[UIImageView alloc] initWithImage:plottedImage];
        
        
        
        NSLog(@"Plot was drawn, buddy!");
        //[self setPlot:nil];
        [self setPlot:plotImageView];
        
        //CGContextRelease(contexter);
        UIGraphicsEndImageContext();
        
    }
    
    
}

-(NSMutableArray *)dataSetSinceDate:(NSDate *)dateSince
{
    NSMutableArray *dataSetSinceDate =[[NSMutableArray alloc] init];
    
    for (SZDataPoint *dataPoint in self.dataSet) {
        if ([dataPoint.timeStamp compare:dateSince]==NSOrderedDescending) {
            [dataSetSinceDate addObject:dataPoint];
        }
    }
    
    if (dateSince==nil) {
        dataSetSinceDate=self.dataSet;
    }
    
    return dataSetSinceDate;
    
}

-(void)updateStats
{
    NSMutableArray *dataPointValues = [[NSMutableArray alloc]init];
    NSNumber *summ= 0;
    
    for (SZDataPoint *datapoint in [self dataSetSinceDate:[self dateSinceForPlot]] ) {
        [dataPointValues addObject:[datapoint dataPointValue]];
        summ=@([summ floatValue]+[[datapoint dataPointValue] floatValue]);
    }
    
    NSArray *sortedDataPointValues = [dataPointValues sortedArrayUsingSelector:@selector(compare:)];
    NSInteger middle = [sortedDataPointValues count]/2;
    

    self.max = [dataPointValues valueForKeyPath:@"@max.self"];
    self.min = [dataPointValues valueForKeyPath:@"@min.self"];
    self.sum = summ;
    self.range = [NSNumber numberWithFloat:([self.max doubleValue]-[self.min doubleValue])];
    self.median = sortedDataPointValues[middle];
    self.mean = @([summ floatValue]/[dataPointValues count]);
    self.countOfDataPoints=@(dataPointValues.count);
}


- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date
{
    NSDate *nowdate =[[NSDate alloc]init];
    NSTimeInterval interval = [nowdate timeIntervalSinceDate:date];
    int intervalint = interval ;
    
    
    if (intervalint<5) {
        return [NSString stringWithFormat:@"Now"];
    }
    if (intervalint<60) {
        return [NSString stringWithFormat:@"<1m ago"];
    }
    if (intervalint<3600) {
        return [NSString stringWithFormat:@"%dm ago", (intervalint+60/2)/60];
    }
    if (intervalint<86400) {
        return [NSString stringWithFormat:@"%dh ago", (intervalint+60*60/2)/3600];
    }
    if (intervalint<2419200) {
        return [NSString stringWithFormat:@"%dd ago", (intervalint+60*60*24/2)/86400];
    }
    return [NSString stringWithFormat:@"%dw ago", (intervalint+60*60*24*7/2)/604800];
    
}


-(void)sortDataSet
{
    NSMutableArray *dateArray =[[NSMutableArray alloc]init];
    for (SZDataPoint *datapoint in self.dataSet) {
        [dateArray addObject:datapoint.timeStamp];
    }
    
    NSMutableArray *permutationArray = [NSMutableArray arrayWithCapacity:dateArray.count];
    for (int i = 0 ; i != dateArray.count ; i++) {
        [permutationArray addObject:@(i)];
    }
    
    [permutationArray sortWithOptions:0 usingComparator:^NSComparisonResult(id obj1, id obj2) {
        // Modify this to use [first objectAtIndex:[obj1 intValue]].name property
        NSString *lhs = dateArray[[obj1 intValue]];
        // Same goes for the next line: use the name
        NSString *rhs = dateArray[[obj2 intValue]];
        return [lhs compare:rhs];
    }];
    

    NSMutableArray *sortedDataSet = [NSMutableArray arrayWithCapacity:dateArray.count];
    
    [permutationArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger pos = [obj intValue];
        [sortedDataSet   addObject:dataSet[pos]];
    }];
    
    [self setDataSet:sortedDataSet];
    
}


-(NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil)
    {
        _operationQueue = [NSOperationQueue new];
    }
    return _operationQueue;
}
@end
