//
//  QuantifiersViewController.h
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZQuantifier.h"
#import "SZQuantifierStore.h"
#import "DetailViewController.h"
#import "SettingsTableViewController.h"

@interface QuantifiersViewController : UITableViewController <UIAlertViewDelegate>
{

    IBOutlet UIView *headerView;

}
@property (nonatomic, strong) DetailViewController *dvc;
@property (nonatomic, strong) SettingsTableViewController *svc;
@property (nonatomic, strong) UIAlertController *createQuantifierAlertView;
@property (nonatomic, strong) SZQuantifier *quantifierToBePushed;
-(UIView *)headerView;
- (void)updateTableView:(NSNotification *)notification;
-(IBAction)addNewQuantifierWithName:(NSString *)newQuantifierName;
- (IBAction)toggleEditingMode:(id)sender;
- (IBAction)tappedSettingsButton:(id)sender;

-(IBAction)tappedAddNewQuantifierButton:(id)sender;
-(void)reloadQuantifiersTable;
-(void)linkDBFileSystemAndCreateFilesForCurrentQuantifiersInDropbox;
-(void)updateStepTracker;
-(void)makeQuantifiersFromFilesInDropbox;


@end
