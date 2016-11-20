//
//  StatsHeaderViewController.m
//  Quantifier
//
//  Created by Scott Zero on 10/27/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "StatsHeaderViewController.h"
#import "SZTheme.h"

@interface StatsHeaderViewController ()

@end

@implementation StatsHeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *tintColor = [SZTheme tintColor];
    UIColor *mainTextColor = [SZTheme mainTextColor];
    
    NSString *fontString = [SZTheme fontString];
    NSString *boldFontString = [SZTheme boldFontString];

    
    ////////////////////
    /// Set colors /////
    ////////////////////
    [meanLabelField setTextColor:tintColor];
    [maxLabelField setTextColor:tintColor];
    [minLabelField setTextColor:tintColor];
    [medianLabelField setTextColor:tintColor];
    [rangeLabelField setTextColor:tintColor];
    [sumLabelField setTextColor:tintColor];
    [countLabelField setTextColor:tintColor];
    
    [meanValueField setTextColor:mainTextColor];
    [maxValueField  setTextColor:mainTextColor];
    [minValueField  setTextColor:mainTextColor];
    [medianValueField  setTextColor:mainTextColor];
    [rangeValueField  setTextColor:mainTextColor];
    [sumValueField  setTextColor:mainTextColor];
    [countValueField setTextColor:mainTextColor];
    
    [statsTitle setTextColor:mainTextColor];
    
    
    /////////////////////////
    /// Set stat values /////
    /////////////////////////
    
    [meanValueField setText:[self.quantifier.mean stringValue]];
    [maxValueField setText:[self.quantifier.max stringValue]];
    [minValueField setText:[self.quantifier.min stringValue]];
    [medianValueField setText:[self.quantifier.median stringValue]];
    [rangeValueField setText:[self.quantifier.range stringValue]];
    [sumValueField setText:[self.quantifier.sum stringValue]];
    [countValueField setText:[self.quantifier.countOfDataPoints stringValue]];
    
    [statsTitle setText:self.quantifier.statisticsTitle];
    
    ////////////////////
    /// Set fonts  /////
    ////////////////////
    
    [meanLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [maxLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [minLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [medianLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [rangeLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [sumLabelField setFont:[UIFont fontWithName:fontString size:17]];
    [countLabelField setFont:[UIFont fontWithName:fontString size:17]];
    
    [meanValueField setFont:[UIFont fontWithName:fontString size:17]];
    [maxValueField setFont:[UIFont fontWithName:fontString size:17]];
    [minValueField setFont:[UIFont fontWithName:fontString size:17]];
    [medianValueField setFont:[UIFont fontWithName:fontString size:17]];
    [rangeValueField setFont:[UIFont fontWithName:fontString size:17]];
    [sumValueField setFont:[UIFont fontWithName:fontString size:17]];
    [countValueField setFont:[UIFont fontWithName:fontString size:17]];
    
    [statsTitle setFont:[UIFont fontWithName:boldFontString size:19]];
    
    ////////////////////////
    /// Set background /////
    ////////////////////////
    
    [backgroundImageView setImage:self.quantifier.blurredScreenShot];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
