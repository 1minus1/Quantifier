//
//  QuantifiersViewController.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "QuantifiersViewController.h"
#import "SZQuantifierStore.h"
#import "SZQuantifier.h"
#import "SettingsTableViewController.h"
#import "SZTheme.h"
#import "QuantifierTableViewCell.h"



//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/////////////   CONSTRUCTING THE VIEW      ///////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


@implementation QuantifiersViewController
@synthesize dvc, svc, createQuantifierAlertView,quantifierToBePushed;

-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    

    UIColor *backgroundColor = [SZTheme backgroundColor];
    self.view.backgroundColor = backgroundColor;
    return self;
}


-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfCells = [[[SZQuantifierStore sharedStore] allQuantifiers] count]+1;
    NSLog(@"QuantifiersViewController's numberOfRowsInSection replied: %ld cell(s).", (long)numberOfCells);
    return numberOfCells;
   
}



-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    
    ////////////////////////////////////////////////////
    /// register to update tracker on resume active ////
    ////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateStepTracker)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    
    ////////////////////////////////////////////////////
    /// register for tableview refresh coming from app delegate ////
    ////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:@"updateTableView" object:nil];

    
    
    /////////////////////////////////////////////
    /// construct the view and whatnot       ////
    /////////////////////////////////////////////
    
    
    
    UIBarButtonItem *rightAddButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tappedAddNewQuantifierButton:)];
    [self.navigationItem setRightBarButtonItem:rightAddButton];
    
    UIColor *tintColor = [SZTheme tintColor];
    UIColor *navBackgroundColor = [SZTheme navBackgroundColor];
    UIColor *backgroundColor = [SZTheme backgroundColor];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"gear.png"];// set your image Name here
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc]initWithImage:menuButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(tappedSettingsButton:)];
   // UIBarButtonItem *menuBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(tappedSettingsButton:)];

    self.navigationItem.leftBarButtonItem = menuBarButton;

    
    
    self.view.backgroundColor=backgroundColor;
    self.navigationController.navigationBar.barTintColor = navBackgroundColor;
    self.navigationController.navigationBar.tintColor = tintColor;
    
    self.navigationController.navigationBar.translucent = NO;
    

    DBAccount *account = [[DBAccountManager sharedManager]linkedAccount];
    if (account) {
        if (![DBFilesystem sharedFilesystem]) {
            DBFilesystem *filesystem = [[DBFilesystem alloc]initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
            
        }
      //[[DBFilesystem sharedFilesystem] addObserver:self block:^{[self makeQuantifiersFromFilesInDropbox];}];
    }
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Denim"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    } else if ([currentTheme isEqualToString:@"iOS7"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    } else if ([currentTheme isEqualToString:@"Vampire"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    } else if ([currentTheme isEqualToString:@"Glam"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    } else if ([currentTheme isEqualToString:@"Subtle"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    } else if ([currentTheme isEqualToString:@"v1.0 Default"])
    {
        self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    } else{
        self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
    }
    
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [[self tableView]reloadData];
}


- (void)updateTableView:(NSNotification *)notification {
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
 
    
    
    NSInteger launchCount;
    launchCount = [userDefaults integerForKey:@"launchCount"]+1;
    [userDefaults setInteger:launchCount forKey:@"launchCount"];
    [userDefaults synchronize];
    
    if (launchCount == 1)
    {
        //UIAlertView *welcome = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"To create a new Quantifier, tap the + button at the top right."  delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles: nil];
        //[welcome show];
        //        };
        
    };
    

    
    BOOL shouldMakeQuantifiersFromDropboxFiles = NO;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"requestedNewDropboxFileImport"]==1) {
        shouldMakeQuantifiersFromDropboxFiles =YES;
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"requestedNewDropboxFileImport"];
    }

    if (shouldMakeQuantifiersFromDropboxFiles) {
        [self makeQuantifiersFromFilesInDropbox];
    }
    
    if (self.dvc.quantifier.blurredScreenShot) {
        [self.dvc.quantifier setBlurredScreenShot:Nil];
    }
    
    
    //[[self tableView]reloadData];
    //[[SZQuantifierStore sharedStore]writeCsvFilesToDocumentDirectoryAndRequestDropboxMetadata];
    [self setDvc:[[DetailViewController alloc] init]];
    [self setSvc:[[SettingsTableViewController alloc]init]];
    //[self setCreateQuantifierAlertView:[[UIAlertView alloc] initWithTitle:@"Create New Quantifier" message:@"What would you like to track?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil]];
    
    //self.createQuantifierAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[self.createQuantifierAlertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    //[self.createQuantifierAlertView textFieldAtIndex:0].autocorrectionType = UITextAutocorrectionTypeYes;
    
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Create New Quantifier"
                                          message:@"What would you like to track?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"What you are tracking.";
         textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSString *newQuantifierName = [[NSString alloc]init];
                                   newQuantifierName = [[[alertController textFields] objectAtIndex:0] text];
                                   NSMutableArray *listOfQuant = [[NSMutableArray alloc]init];
                                   for (SZQuantifier *quant in [[SZQuantifierStore sharedStore] allQuantifiers]){
                                       [listOfQuant addObject:[quant quantifierName]];
                                   };
                                   
                                   NSCharacterSet *invalidFsChars = [NSCharacterSet characterSetWithCharactersInString:@"_/\\?%*|\"<>"];
                                   NSString *scrubbed = [newQuantifierName stringByTrimmingCharactersInSet:invalidFsChars];
                                   
                                   if ([listOfQuant containsObject:newQuantifierName]){
                                       UIAlertController *dupeNameAlert = [UIAlertController
                                                                             alertControllerWithTitle:@"Oops."
                                                                             message:@"That name is taken. For shame!"
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                                       UIAlertAction *cancelAction = [UIAlertAction
                                                                      actionWithTitle:@"I'm sorry."
                                                                      style:UIAlertActionStyleCancel
                                                                      handler:^(UIAlertAction *action)
                                                                      {
                                                                          NSLog(@"Cancel action");
                                                                      }];
                                       [dupeNameAlert addAction:cancelAction];
                                       [self presentViewController:dupeNameAlert animated:YES completion:nil];
                                       
                                       

                                       
                                       
                                   } else {
                                       if ( ![newQuantifierName isEqualToString:scrubbed]) {
                                           //UIAlertView *badFileNameAlert = [[UIAlertView alloc ]initWithTitle:@"Bad name." message:@"That name contains invalid file name characters. Please try again." delegate:self cancelButtonTitle:@"Ok, I'm sorry." otherButtonTitles: nil];
                                           //[badFileNameAlert show];
                                           
                                           UIAlertController *badNameAlert = [UIAlertController
                                                                               alertControllerWithTitle:@"Bad name."
                                                                               message:@"That name contains invalid file name characters. Please try again."
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                           UIAlertAction *cancelAction = [UIAlertAction
                                                                          actionWithTitle:@"OK, I'm sorry."
                                                                          style:UIAlertActionStyleCancel
                                                                          handler:^(UIAlertAction *action)
                                                                          {
                                                                              NSLog(@"Cancel action");
                                                                          }];
                                           [badNameAlert addAction:cancelAction];
                                           [self presentViewController:badNameAlert animated:YES completion:nil];
                                           
                                           
                                           
                                       }else{
                                           [alertController dismissViewControllerAnimated:YES completion:nil];
                                           [self addNewQuantifierWithName:newQuantifierName];
                                           
                                       }
                                       
                                   }
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self setCreateQuantifierAlertView:alertController];
    
    
    
    
   
    
    
    
    
    
    
    NSInteger quantifiersViewCount;
    quantifiersViewCount = [userDefaults integerForKey:@"quantifiersViewCount"]+1;
    [userDefaults setInteger:quantifiersViewCount forKey:@"quantifiersViewCount"];
    [userDefaults synchronize];
    

    
//    This can ask the user if they want to hook up dropbox on teh quantifiersViewCounth time they see the quantifiers view. Not actually a typical behavior. It also hasn't been fixed to update the view upon syncing (until the view is dimissed and shown again.
//    if (quantifiersViewCount==3) {
//        if (![[DBAccountManager sharedManager]linkedAccount]) {
//            
//            UIAlertView *askforDropboxLink = [[UIAlertView alloc] initWithTitle:@"Link with Dropbox" message:@"Would you like to back up your data to Dropbox? \n\n (You can always do this from Settings.)" delegate:self cancelButtonTitle:@"Not now." otherButtonTitles:@"Yes!", nil]  ;
//            [askforDropboxLink show];
//            
//                
//            
//            
//            
//        };
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"addedDataPointFromUrlScheme"]) {
        NSLog(@"there");
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"addedDataPointFromUrlScheme"];
        [self.tableView reloadData];
        
        
        
    }

    
}

-(void)makeQuantifiersFromFilesInDropbox
{
    //if ([UIApplication sharedApplication].networkActivityIndicatorVisible==NO) {
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    //}
    
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    
    
    
    
    dispatch_async(downloadQueue, ^{
        
        //  DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
        
        
        DBFilesystem *filesystem =[DBFilesystem sharedFilesystem];
        //DBSyncStatus filesystemStatus = [filesystem status];
        BOOL hasSynced = [filesystem completedFirstSync];
        //BOOL notDownloading = (filesystemStatus & DBSyncStatusDownloading) == 0x0;
        //BOOL notSynching = (filesystemStatus & DBSyncStatusSyncing) == 0x0;
        
        //BOOL readyToGo = (hasSynced & notDownloading & notSynching);
        
        if (hasSynced) {
            NSLog(@"Dropbox is ready to go. Starting conversion of dropbox files to Quantifiers.");
            NSArray *listOfDBFiles = [filesystem listFolder:[DBPath root] error:nil];
            
            for (DBFileInfo *fileInfo in listOfDBFiles) {
                
                
                //NSLog(@"Making Quantifier from a Dropbox File.");
                DBPath *filePath = [fileInfo path];
                NSString *thisFilesName =[filePath name];
                NSString *thisFilesNameWithoutExtension = [thisFilesName stringByDeletingPathExtension];
                NSString *thisFilesNameWithoutExtensionWithSpacesForUnderscores = [thisFilesNameWithoutExtension stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                
                NSCharacterSet *invalidFsChars = [NSCharacterSet characterSetWithCharactersInString:@"_/\\?%*|\"<>"];
                NSString *thisFilesNameWithoutExtensionWithSpacesForUnderscoresWithoutBadChars = [thisFilesNameWithoutExtensionWithSpacesForUnderscores stringByTrimmingCharactersInSet:invalidFsChars];
                
                
                DBFile *file = [filesystem openFile:filePath error:nil];
                BOOL filecachedyet = [file status].cached;
                if (filecachedyet==YES) {
                    NSString *fileContentsAsString = [file readString:nil];
                    //[filesystem deletePath:filePath error:nil];
                    [[SZQuantifierStore sharedStore]createQuantifierFromCSVFileContents:fileContentsAsString name:thisFilesNameWithoutExtensionWithSpacesForUnderscoresWithoutBadChars];
                }else{
                    
                    NSLog(@"file not cached, trying again shortly\n");
                }
                
                [file close];
                
            }
            
            NSInteger currentNumberOfQuantifiers = [[SZQuantifierStore sharedStore]numberOfQuantifiers];
            NSInteger currentNumberOfFilesInDB = [listOfDBFiles count];

            if (currentNumberOfQuantifiers>=currentNumberOfFilesInDB) {
                
                NSLog(@"Current count: %ld Dropbox file(s).", (long)currentNumberOfFilesInDB);
                NSLog(@"Done creating Quantifiers from Dropbox files.");
                //[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                
            } else{
                [self performSelector:@selector(makeQuantifiersFromFilesInDropbox) withObject:nil] ;
            }
        } else{
            NSLog(@"Dropbox not quite synched, might want to suggest trying again.");
            
        }
  
    });


    

    }



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    QuantifierTableViewCell *quantifierCell;
    
    
    /// This conditional makes the row that will represent a quantifier that already exists.
    if ([indexPath row]<[[SZQuantifierStore sharedStore].allQuantifiers count]) {
        quantifierCell = [QuantifierTableViewCell new];
        quantifierCell = [[NSBundle mainBundle]loadNibNamed:@"QuantifierTableViewCell" owner:self options:nil][0];
        
        SZQuantifier *quantifierForCell = [[SZQuantifierStore sharedStore] allQuantifiers][[indexPath row]];

        
        if (quantifierForCell.dataSet.count>0)
        {
            SZDataPoint *mostRecent = [quantifierForCell dataSet][quantifierForCell.dataSet.count-1];
            [quantifierCell setMostRecentDataPointValueString:mostRecent.dataPointValueString];
            [quantifierCell setMostRecentDataPointsDate:mostRecent.timeStamp];
            [quantifierCell setDataPointCount:quantifierForCell.dataSet.count];
            [quantifierCell setQuantifierName:quantifierForCell.quantifierName];
            [quantifierCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }else {
            [quantifierCell setMostRecentDataPointValueString:@""];
            [quantifierCell setMostRecentDataPointsDate:nil];
            [quantifierCell setDataPointCount:0];
            [quantifierCell setQuantifierName:quantifierForCell.quantifierName];
            [quantifierCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        [quantifierCell setLayoutMargins:UIEdgeInsetsZero];
        [quantifierCell updateContents];
        
        
        
        return quantifierCell;
        

        
    } else {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Create a new Quantifier";
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        UIColor *backgroundColor = [SZTheme selectedCellColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = backgroundColor;
        cell.textLabel.font=[UIFont fontWithName:[SZTheme boldFontString] size:18];
        UIColor *detailTextColor = [SZTheme detailTextColor];
        
        cell.detailTextLabel.textColor = detailTextColor;
        UIColor *mainTextColor = [SZTheme mainTextColor];
        UIColor *selectedCellColor = [SZTheme selectedCellColor];
        
        
        
        cell.textLabel.textColor = mainTextColor;
        NSString *fontString = [SZTheme fontString];
        
        cell.detailTextLabel.font = [UIFont fontWithName:fontString size:13];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor= selectedCellColor;
        
        return cell;
        
    }
    
    return nil;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]<[[SZQuantifierStore sharedStore].allQuantifiers count]){
        return YES;
        
    }else{
        
        return NO;
    }
        
}

-(UIView *)headerView
{
    if (!headerView) {
        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    }

    UIColor *mainTextColor = [SZTheme mainTextColor];
    
    for (UIView *subview in headerView.subviews) {
        if  ([subview isKindOfClass:[UILabel class]]){
            //NSLog(@"%@", subview);
            [(UILabel *)subview setTextColor:mainTextColor];
        }
    }

    UIColor *backgroundColor = [SZTheme backgroundColor];
    UIColor *tintColor = [SZTheme tintColor];
    
    [headerView setBackgroundColor:backgroundColor];
    [headerView setTintColor:tintColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSInteger heightToReturn =self.headerView.frame.size.height;
    NSLog(@"%ld is the height of the header", (long)heightToReturn);
    return heightToReturn;
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/////////////    EDITING THE CELLS IN THE VIEW     ///////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////





-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SZQuantifierStore *ps = [SZQuantifierStore sharedStore];
        NSArray *quantifiers = [ps allQuantifiers];
        SZQuantifier *p = quantifiers[[indexPath row]];
        [ps removeQuantifier:p];
        
        // Remove the row from the tableview with an animation
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

-(IBAction)toggleEditingMode:(id)sender
{
    // If we are editing already, turn off editing mode
    if ([self isEditing]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal]   ;
        [self setEditing:YES animated:YES];
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row==[[SZQuantifierStore sharedStore]allQuantifiers].count) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row-1 inSection:proposedDestinationIndexPath.section];
        return path;
    } else{
        return proposedDestinationIndexPath;
    }
}

- (IBAction)tappedSettingsButton:(id)sender {
  
    [[self navigationController] pushViewController:[self svc] animated:YES];
}

-(IBAction)tappedAddNewQuantifierButton:(id)sender
{
    [self presentViewController:self.createQuantifierAlertView animated:YES completion:nil ];
    
    
}



-(IBAction)addNewQuantifierWithName:(NSString *)newQuantifierName
{
   
    // Make a new indexpath for the 0th section, last row

    SZQuantifier *newQuantifier = [[SZQuantifierStore sharedStore] createQuantifierWithName:newQuantifierName withType:nil];
    [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:newQuantifier];
    [[self dvc] setQuantifier:newQuantifier];
    
    NSLog(@"Heading off to the detail view for the new Quantifier, called %@", [newQuantifier quantifierName]   );
    
    [[self navigationController] pushViewController:dvc animated:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    
//    int lastRow = [[[SZQuantifierStore sharedStore] allQuantifiers] indexOfObject:newQuantifier];
//    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//
//    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [[self tableView] scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    [[self tableView] selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
}





- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[SZQuantifierStore sharedStore]moveQuantifierAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}


//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/////////////    HEADING OFF TO THE DETAIL VIEW     //////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   DetailViewController *dvc = [[DetailViewController alloc] init];
    
    if ([indexPath row]<[[SZQuantifierStore sharedStore]allQuantifiers].count) {
        NSArray *quantifiers = [[SZQuantifierStore sharedStore]allQuantifiers];
        SZQuantifier *quantifierToBePushedSoon = quantifiers[[indexPath row]];
        [self setQuantifierToBePushed:quantifierToBePushedSoon];
        [[self dvc] setQuantifier:quantifierToBePushedSoon];
        
        NSLog(@"Heading off to the detail view for %@, table row %ld", [quantifierToBePushed quantifierName], (long)[indexPath row]    );
        
        [[self navigationController] pushViewController:dvc animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    } else{
        [self tappedAddNewQuantifierButton:nil];
    }
    
    
    
}

-(void)viewDidLoad
{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadQuantifiersTable) name:@"reloadViewOnDropboxAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDBFileSystemAndCreateFilesForCurrentQuantifiersInDropbox) name:@"dropboxLinked" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadQuantifiersTable) name:@"doneUpdatingStepTracker" object:nil];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    
    
    /////////////////////////////////////////////
    /// if there's a step tracker, update it ////
    /////////////////////////////////////////////
    
    [self updateStepTracker];

}

-(void)reloadQuantifiersTable
{
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


-(void)linkDBFileSystemAndCreateFilesForCurrentQuantifiersInDropbox
{
    DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:[[DBAccountManager sharedManager] linkedAccount]];
    [DBFilesystem setSharedFilesystem:filesystem];

    [[SZQuantifierStore sharedStore] writeAllQuantifiersCsvFilesToLocalAndDropBoxDirectory];
}

-(void)updateStepTracker
{
    for (SZQuantifier *quantifer in [[SZQuantifierStore sharedStore]allQuantifiers]) {
        if ([quantifer.type isEqualToString:@"AutoStepTrackingOn"]) {
            [quantifer updateAutoStepTracker];
            NSLog(@"updated step tracker from quantifiers view");
        }
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTableView:nil];
    [self setTableView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
