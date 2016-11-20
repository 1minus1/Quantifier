//
//  CurveFitterFlipsideViewController.h
//  CurveFitter
//
//  Created by Scott Zero on 12/1/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurveFitterFlipsideViewController;

@protocol CurveFitterFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CurveFitterFlipsideViewController *)controller;
@end

@interface CurveFitterFlipsideViewController : UIViewController

@property (weak, nonatomic) id <CurveFitterFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
