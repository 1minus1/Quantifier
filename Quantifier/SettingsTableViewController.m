//
//  SettingsTableViewController.m
//  Quantifier
//
//  Created by Scott Zero on 10/7/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "SettingsTableViewController.h"
#import "ThemesTableViewController.h"
#import "SZTheme.h"
#import "SZQuantifier.h"
#import "SZQuantifierStore.h"


@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This is for the Look and Feel Section, the first (index=0) section.
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsViewUITableViewCell"];

    UIColor *detailTextColor = [SZTheme detailTextColor];
    UIColor *backgroundColor = [SZTheme backgroundColor];
    UIColor *mainTextColor = [SZTheme mainTextColor];
    UIColor *selectedCellColor = [SZTheme selectedCellColor];
    
    NSString *fontString = [SZTheme fontString];
    
    
    cell.detailTextLabel.textColor = detailTextColor;
    cell.textLabel.font = [UIFont fontWithName:fontString size:18];
    cell.textLabel.textColor = mainTextColor;
    cell.detailTextLabel.font = [UIFont fontWithName:fontString size:13];
    cell.backgroundColor = backgroundColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor= selectedCellColor;
    
    
    
    if ([indexPath section]==0) {
        UITableViewCell *themeCell = cell;
        [[themeCell textLabel]setText:@"Themes & Text"];

        [themeCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [themeCell setSelected:NO];
        return themeCell;
    }
    
    
    
    // This is for the DropBox Section, the second (index=1) section.
    if ([indexPath section]==1) {
        
        
        if ([indexPath row]==0) {
            UITableViewCell *dropboxCell = cell;
            if ([[DBAccountManager sharedManager]linkedAccount]) {
                [[dropboxCell textLabel] setText:@"Dropbox is linked. Tap to unlink."];
                
                
            }else{
                [[dropboxCell textLabel]setText:@"Link a Dropbox Account"];
            }
            [dropboxCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            

            return dropboxCell;
        }
        if ([indexPath row]==1) {
            UITableViewCell *importCell = cell;
            [[importCell textLabel]setText:@"Import files from Dropbox"];
            [importCell setAccessoryType:UITableViewCellAccessoryDetailButton];
            [importCell setTintColor:[SZTheme tintColor]];

            return importCell;
        }
        
        
    }
    // This is for the Step tracker section, the third (index=2) section.
    
    if ([indexPath section]==2) {
        UITableViewCell *stepCell = cell;
        stepCell.selectionStyle=UITableViewCellSelectionStyleNone;
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        [switchview addTarget:self action:@selector(updateStepTrackingSwitch) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView=switchview;
        switchview.userInteractionEnabled=YES;
        NSInteger isCurrentlyTrackingSteps = [[NSUserDefaults standardUserDefaults]integerForKey:@"isCurrentlyTrackingSteps"];
        
        BOOL isStepTrackingAvailable = [CMPedometer isStepCountingAvailable];
        if (isStepTrackingAvailable) {
            [[stepCell textLabel]setText:@"Step Tracking"];
            if (isCurrentlyTrackingSteps) {
                [switchview setOn:YES];
            }else{
                [switchview setOn:NO];
            }
        } else {
            [[stepCell textLabel]setText:@"Not available on this device"];
            [[stepCell textLabel]setTextColor:[SZTheme detailTextColor]];
            [stepCell setUserInteractionEnabled:NO];
            cell.accessoryView=nil;
        }
        
        return stepCell;
    }
        
    
    
    
    // This is for the other Section, the fourth (index=3) section.
    
    if ([indexPath section]==3) {
        
        UITableViewCell *helpCell = cell;
        
        if ([indexPath row]==0) {
            [[helpCell textLabel]setText:@"Like this app? Tap to rate it!"];
            [helpCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        };
        if ([indexPath row]==1) {
            [[helpCell textLabel]setText:@"Email Support"];
            [helpCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        };
        if ([indexPath row]==2) {
            [[helpCell textLabel]setText:@"@QuantiferApp on Twitter"];
            [helpCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        };
        if ([indexPath row]==3) {
            [[helpCell textLabel]setText:@"Visit quantifierapp.com"];
            [helpCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        };
        if ([indexPath row]==4) {
            NSString *versionString = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            NSString *cellString = [@"Version " stringByAppendingString:versionString];
            [[helpCell textLabel]setText:cellString];

            [helpCell.textLabel setTextColor:[SZTheme detailTextColor]];
            helpCell.textLabel.textAlignment=NSTextAlignmentCenter;
            [helpCell setUserInteractionEnabled:NO];
        };
        
        
        

        return helpCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==1 && [indexPath row]==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://quantifierapp.com/2013/12/05/importing-data-sets-with-dropbox/"] options:[NSMutableDictionary dictionary] completionHandler:nil];
         
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]==0) {
        if ([indexPath row]==0) {
            [self didPressThemesLink];
            
            
        }
    }
    
    if ([indexPath section]==1) {
        
        if ([indexPath row]==0) {
            [self didPressDropboxLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        
        if ([indexPath row]==1) {
            [self didPressImportNewDropboxFilesLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        
        
    }
    
    if ([indexPath section]==2) {
        
        
        
        
    }
    
    if ([indexPath section]==3) {
        
        if ([indexPath row]==0) {
            [self didPressRateLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        };
        if ([indexPath row]==1) {
            [self didPressEmailSupportLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        };
        if ([indexPath row]==2) {
            [self didPressTwitterLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        };
        if ([indexPath row]==3) {
            [self didPressWebsiteLink];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        };
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        
        // This is the theme and font section.
        return 1;
    }else if (section==1)
    {
        // This is the Dropbox section.
        if ([[DBAccountManager sharedManager]linkedAccount]) {
            return 2;
        } else{
            return 1;
        }
    }else if (section==2){
        // this is the step tracking section
        return 1;
    }    else if (section==3){
        // This is the other section.
        return 5;
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Look and Feel"];
        return header;
    }
    if (section==1) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Dropbox Settings"];
        return header;
    }
    if (section==2) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Daily Step Tracking"];
        return header;
    }
    if (section==3) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Other"];
        return header;
    }
    return nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [settingsTable reloadData];

    
    UITextField *titleView = (UITextField *)self.navigationItem.titleView;
    titleView.font = [UIFont fontWithName:[SZTheme fontString] size:19];
    UITextField *title = (UITextField *)self.navigationItem.titleView;
    [title setTextColor:[SZTheme tintColor]];
    
    [settingsTable setBackgroundColor:[SZTheme backgroundColor]];
    
    [settingsTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO];

    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField *titleName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 22)];
        titleName.text = @"Settings";
        titleName.backgroundColor = [UIColor clearColor];
        titleName.font = [UIFont fontWithName:[SZTheme fontString] size:19];
        
        
        titleName.textColor = [SZTheme tintColor];
        titleName.textAlignment = NSTextAlignmentCenter;
        [titleName setUserInteractionEnabled:NO];
        [titleName setDelegate:self];
        self.navigationItem.titleView = titleName;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [settingsTable reloadData];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTable) name:@"dropboxLinked" object:nil];
    
    
}

-(void)reloadTable{
    [settingsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPressDropboxLink{

    if (![[DBAccountManager sharedManager]linkedAccount]) {
        [[DBAccountManager sharedManager] linkFromController:self];
        
    }else{
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Unlink Dropbox?" message:@"Are you sure that you would like to unlink your Dropbox account? Your data will not be deleted, but changes will no longer be backed up in Dropbox." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           //NSLog(@"Cancel action");
                                       }];
        UIAlertAction *unlinkaction = [UIAlertAction actionWithTitle:@"Unlink"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction * _Nonnull action) {
            [self unlinkDropbox];
        }];
        
        [alertcontroller addAction:cancelAction];
        [alertcontroller addAction:unlinkaction];
        
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
        //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unlink Dropbox?" message:@"Are you sure that you would like to unlink your Dropbox account? Your data will not be deleted, but changes will no longer be backed up in Dropbox." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        //alert.tag=1;
        //[alert show];
    };

};

-(void)unlinkDropbox  {
    // ensure you have a DBSession to unlink
    [[[DBAccountManager sharedManager] linkedAccount] unlink];
    [settingsTable reloadData];
}

-(void)didPressImportNewDropboxFilesLink
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    int requestedDropboxNewFileImport = 1;
    [userDef setInteger:requestedDropboxNewFileImport forKey:@"requestedNewDropboxFileImport"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didPressEmailSupportLink {
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    [mailController setSubject:@"Quantifier Support"];
    
    NSArray *myEmail = @[@"dev+support@quantifierapp.com"];
    [mailController setToRecipients:myEmail];
    
    UIColor *tintColor = [SZTheme tintColor];
    
    mailController.view.tintColor=tintColor;
    if ([MFMailComposeViewController canSendMail]) {
        [self presentViewController:mailController animated:YES completion:nil];
    }else {
        NSLog(@"No messaging account set up.");
    }
}

- (void)didPressTwitterLink{
    NSString *stringer = [NSString stringWithFormat:@"http://www.twitter.com/QuantifierApp"];
    NSString *escaped = [stringer stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped] options:[NSDictionary dictionary] completionHandler:nil];
}

- (void)didPressWebsiteLink{
    NSString *stringer = [NSString stringWithFormat:@"http://www.quantifierapp.com/"];
    NSString *escaped = [stringer stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped] options:[NSDictionary dictionary] completionHandler:nil];
}

- (void)didPressRateLink{
    NSString *stringer = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id700329187?at=10l6dK"];
    NSString *escaped = [stringer stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped] options:[NSDictionary dictionary] completionHandler:nil];
}

-(void)didPressThemesLink
{
    ThemesTableViewController *tbvc = [[ThemesTableViewController alloc]init];
    [[self navigationController] pushViewController:tbvc animated:YES];
}

- (void)updateStepTrackingSwitch
{
    BOOL isCurrentlyTrackingSteps = [[NSUserDefaults standardUserDefaults] integerForKey:@"isCurrentlyTrackingSteps"];
    
    if (!isCurrentlyTrackingSteps) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isCurrentlyTrackingSteps"];
        
        SZQuantifier *stepTrackingQuantifier;
        
        for (SZQuantifier *quantifier in [[SZQuantifierStore sharedStore] allQuantifiers]) {
            if ([quantifier.type isEqualToString:@"AutoStepTrackingOff"] | [quantifier.quantifierName isEqualToString:@"Auto Step Tracker22"]) {
                
                stepTrackingQuantifier =quantifier;
                quantifier.type=@"AutoStepTrackingOn";
            }
        }
        if (stepTrackingQuantifier==nil) {
            stepTrackingQuantifier = [[SZQuantifierStore sharedStore] createQuantifierWithName:@"Steps" withType:@"AutoStepTrackingOn"];
        }
        
        [stepTrackingQuantifier updateAutoStepTracker];
        //[settingsTable reloadData];
    } else{
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isCurrentlyTrackingSteps"];
        
        // If there are currently tracking step counters, turn them off.
        for (SZQuantifier *quantifier in [[SZQuantifierStore sharedStore]allQuantifiers]) {
            if ([quantifier.type isEqualToString:@"AutoStepTrackingOn"]) {
                quantifier.type=@"AutoStepTrackingOff";
            }
        }
        
        //[settingsTable reloadData];
    }

}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
