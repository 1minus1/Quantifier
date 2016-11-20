//
//  CurveFitterFlipsideViewController.m
//  CurveFitter
//
//  Created by Scott Zero on 12/1/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "CurveFitterFlipsideViewController.h"

@interface CurveFitterFlipsideViewController ()

@end

@implementation CurveFitterFlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
