//
//  DetailViewController.h
//  Quantifier
//
//  Created by Scott Zero on 7/1/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "StatsHeaderViewController.h"
@class TableBasedDataPointViewController;


@class SZQuantifier;

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>
{
    __weak IBOutlet UITableView *dataSetTable;
}

@property (nonatomic, strong) SZQuantifier *quantifier;

@property (nonatomic, strong) NSMutableArray *plotXLocations;
@property (nonatomic, strong) NSMutableArray *plotYLocations;
@property (nonatomic, strong) TableBasedDataPointViewController *tableBasedDataPointViewControllerToBePushed;
@property (nonatomic, strong) NSNumber *selectedRowIntegerValue;
@property (nonatomic, strong) UIDocumentInteractionController *myDocumentInteractionController;
@property (nonatomic, strong) NSArray *UIBarButtonItemsArray;
@property (nonatomic, strong) UITableViewCell *cellBeingCopied;
@property (nonatomic) NSInteger headerStyle;
@property (nonatomic) NSInteger fitCurve;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, strong) NSNumber *numberOfDPVCsPushedSincePushingThisDVC;
@property (nonatomic, strong) NSDate *dateSinceForPlot;
@property (nonatomic, strong) UISegmentedControl *dateRangeSegmentedControl;
@property (nonatomic) NSInteger selectedSegmentInUISegmentedControl;
@property (nonatomic, weak) UIRefreshControl *refresher;


- (void)updateTableView:(NSNotification *)notification;


- (IBAction)trackNowButtonToggle:(id)sender;
- (void)selectFirstRow;

- (void)updateBlurredScreenshot;
- (void)showActionSheetFromBarButtonItem:(UIBarButtonItem *)sender;
- (void)showDocumentInteractionController:(UIBarButtonItem *)sender;
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;

- (void)toggleHeaderViewStyle;
- (void)toggleFitCurve;

- (void)updateStepTracker;
- (void)refreshStepTracker;

- (void)reloadDataTable;
- (UIView *)addSeparatorLineAtBottom:(UIView *)view;
- (void) dateRangeSelected:(id)sender;
- (void) setUpSegmentedControlIfItsNeeded;
- (void) tappedGoalButton;
- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date;


@end
