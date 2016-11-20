//
//  CurveFitterMainViewController.m
//  CurveFitter
//
//  Created by Scott Zero on 12/1/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "CurveFitterMainViewController.h"

@interface CurveFitterMainViewController ()

@end

@implementation CurveFitterMainViewController

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

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(CurveFitterFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

@end
