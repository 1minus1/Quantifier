//
//  SettingsTableViewController.h
//  Quantifier
//
//  Created by Scott Zero on 10/7/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsTableViewController : UIViewController <UITableViewDataSource, UITabBarDelegate,UITextFieldDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

{
    __weak IBOutlet UITableView *settingsTable;
    
}

@property BOOL didBuyThing;
- (void)didPressDropboxLink;
- (void)didPressEmailSupportLink;
- (void)didPressTwitterLink;
- (void)didPressWebsiteLink;
- (void)didPressRateLink;
- (void)didPressImportNewDropboxFilesLink;
- (void)didPressThemesLink;
- (void)updateStepTrackingSwitch;
- (void)reloadTable;
- (void)unlinkDropbox;
@end
