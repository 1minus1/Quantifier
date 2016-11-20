
//
//  DetailViewController.m
//  Quantifier
//
//  Created by Scott Zero on 7/1/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "UIImage+ImageEffects.h"
#import "DetailViewController.h"
#import "SZQuantifier.h"
#import "SZDataPoint.h"
#import "StatsHeaderViewController.h"
#import "SZTheme.h"
#import "SJZFirstCell.h"
#import "TableBasedDataPointViewController.h"



@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize quantifier, selectedRowIntegerValue, plotXLocations, plotYLocations, myDocumentInteractionController, UIBarButtonItemsArray, cellBeingCopied, headerStyle, headerView,numberOfDPVCsPushedSincePushingThisDVC,fitCurve,dateRangeSegmentedControl,selectedSegmentInUISegmentedControl,refresher,tableBasedDataPointViewControllerToBePushed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setNumberOfDPVCsPushedSincePushingThisDVC:@1];
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    if ([self.quantifier.type isEqualToString:@"AutoStepTrackingOn"]) {
        [self updateStepTracker];
        self.refresher=refreshControl;
        [refreshControl addTarget:self action:@selector(refreshStepTracker)
                 forControlEvents:UIControlEventValueChanged];
        [refreshControl setTintColor:[SZTheme tintColor]];
        [dataSetTable addSubview:refreshControl];
    };
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)name:UIDeviceOrientationDidChangeNotification object:nil];
    //    // Do any additional setup after loading the view from its nib.
    self.numberOfDPVCsPushedSincePushingThisDVC = 0;
    //
    //// Set the time frame to All time;
    
    self.quantifier.dateSinceForPlot=nil;
    self.quantifier.statisticsTitle=@"Statistics (All Time)";
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"selectedcell"];
    
    
    ////////////////////////////////////////////////////
    /// register for tableview refresh coming from app delegate ////
    ////////////////////////////////////////////////////
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:@"updateTableView" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    //// If this quantifier doens't have stats, update them.
    
    if (!self.quantifier.countOfDataPoints | !self.quantifier.mean | !self.quantifier.countOfDataPoints | !self.quantifier.max | !self.quantifier.min | !self.quantifier.range | !self.quantifier.range | !self.quantifier.sum) {
        if ([self.quantifier.dataSet count]>0) {
            [self.quantifier updateStats];
        }
        
    }
    
    UIColor *backgroundColor = [SZTheme backgroundColor];
    
    [dataSetTable setBackgroundColor:backgroundColor];
    

    
    
    
    /////////////////////////////////
    /// Define headerviewstyle    ///
    /////////////////////////////////
    
    // we'll always show the plot first
    
    self.headerStyle = 0;
    
    
    ////////////////////////////////////////////////////
    /// register to update tracker on resume active if it's a tracker ////
    ////////////////////////////////////////////////////
    
    if ([self.quantifier.type isEqualToString:@"AutoStepTrackingOn"]){
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(updateStepTracker)
         name:UIApplicationWillEnterForegroundNotification
         object:nil];
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////
    /// Pop up a uialert telling them about the step tracker if they have never seen it before ///
    //////////////////////////////////////////////////////////////////////////////////////////////
    
    if ([self.quantifier.type isEqualToString:@"AutoStepTrackingOn"]) {
        BOOL hasSeenTrackerAlert = [[NSUserDefaults standardUserDefaults]integerForKey:@"hasSeenStepTrackerAutoTrackingAlert"];
        if (!hasSeenTrackerAlert==1) {
            UIAlertController *autoStepTrackDescriberAlert = [UIAlertController alertControllerWithTitle:@"Step Tracker" message:@"This is your step tracker. It's updated automatically. Enjoy!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [autoStepTrackDescriberAlert addAction:cancel];
            
            [self presentViewController:autoStepTrackDescriberAlert animated:YES completion:nil];
            
            [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"hasSeenStepTrackerAutoTrackingAlert"];
        }
        
        
    }
    
    
    ////////////////////////////////////////////////////////
    /// Set up the uisegmented control ( if it's needed) ///
    ////////////////////////////////////////////////////////
    
    [self setUpSegmentedControlIfItsNeeded];
    
    
    /////////////////////////////////
    /// Set up the navigation bar ///
    /////////////////////////////////

    UIBarButtonItem *rightAddButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(trackNowButtonToggle:)];
    if (![quantifier.type isEqualToString:@"AutoStepTrackingOn"] && ![quantifier.type isEqualToString:@"AutoStepTrackingOff"]) {
        [self.navigationItem setRightBarButtonItem:rightAddButton];
    }
    
    
    
    UITextField *titleName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 22)];
    
    titleName.text = [quantifier quantifierName];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont fontWithName:[SZTheme fontString] size:19];
    
    titleName.textColor = [SZTheme tintColor];
    titleName.textAlignment = NSTextAlignmentCenter;
    [titleName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [titleName setDelegate:self];
    self.navigationItem.titleView = titleName;
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Vampire"] | [currentTheme isEqualToString:@"Glam"]) {
        UITextField *titleView = (UITextField *)self.navigationItem.titleView;
        titleView.keyboardAppearance=UIKeyboardAppearanceDark;
    }
    
    /////////////////////////////////
    /// Set up the toolbar        ///
    /////////////////////////////////
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    CGFloat tabBarHeight = 45;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, screenheight-tabBarHeight-44-statusBarHeight, [UIScreen mainScreen].bounds.size.width, tabBarHeight)];
    //[toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];

    UIColor *navBackgroundColor = [SZTheme backgroundColor];
    UIColor *tintColor = [SZTheme tintColor];

    [toolBar setTintColor:tintColor];
    [toolBar setBarTintColor:navBackgroundColor];
    [toolBar setTranslucent:YES];
        
    
    //Create a button for actionsheet.
    UIBarButtonItem *firstButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheetFromBarButtonItem:)];
    UIBarButtonItem *firstSpace  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:Nil];
    
    
    UIBarButtonItem *secondButton= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toggleicon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleHeaderViewStyle)];
    UIBarButtonItem *secondSpace  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:Nil];
    UIBarButtonItem *thirdButton = [[UIBarButtonItem alloc]initWithTitle:@"Goal" style:UIBarButtonItemStylePlain target:self action:@selector(tappedGoalButton)];
    
    UIBarButtonItem *spaceForWhenHeaderToggleIsNotVisible  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:Nil];
    [spaceForWhenHeaderToggleIsNotVisible setWidth:secondButton.width];
    
    NSMutableArray *toolbarItems=[[NSMutableArray alloc]init];
    
    // don't give access to the summary view if the stats arent there, that is, there isn't any data
    
    
    
    if ([quantifier.dataSet count]>1) {
        [toolbarItems addObjectsFromArray:@[firstButton, firstSpace, secondButton,secondSpace,thirdButton]];
    } else{
        [toolbarItems addObjectsFromArray:@[firstButton , firstSpace,thirdButton]];
    }

    self.UIBarButtonItemsArray = toolbarItems;
    [toolBar setItems:[NSArray arrayWithArray:toolbarItems]];
    
    // dirty hack instead of moving this shit to viewdidload, like a sane person would do
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if ([v isKindOfClass:[UIToolbar class]]){
            [v removeFromSuperview];
        }
    }
    
    [self.view addSubview:toolBar];
    
    /////////////////////////////////
    /// Select the selected row   ///
    /////////////////////////////////
    
//    if (!self.selectedRowIntegerValue) {
//        self.selectedRowIntegerValue = [NSNumber numberWithInt:0];
//    }
//    [dataSetTable reloadData];
//    if ([self.selectedRowIntegerValue integerValue]>-1) {
        selectedRowIntegerValue=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectedcell"];
        [dataSetTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[selectedRowIntegerValue integerValue] inSection:0];
        [dataSetTable selectRowAtIndexPath:indexPath animated:noErr scrollPosition:UITableViewScrollPositionNone];
//        
//    }
//
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFirstRow)name:@"addeddatapoint" object:nil];
    
    NSInteger inset;
    if (quantifier.hasSegmentedControlInDetailView) {
        inset=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton + 35;
    }else{
        inset=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton;
    }
    
    dataSetTable.scrollIndicatorInsets = UIEdgeInsetsMake(inset, 0, 0, 0);
   
    TableBasedDataPointViewController *tbdpvc = [TableBasedDataPointViewController new];
    [tbdpvc setDvc:self];
    [self setTableBasedDataPointViewControllerToBePushed:tbdpvc];

    ///////////////////////////////////////
    /// Update csv and sync if needed   ///
    ///////////////////////////////////////
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"needscsvupdateandsync"] isEqualToNumber:@1]) {
        [quantifier updateCsvContents];
        //[quantifier setPlot:nil];
        //[quantifier updatePlot];
        [dataSetTable reloadData];
        [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifier];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"needscsvupdateandsync"];
        NSLog(@"datapoint added to %@",[quantifier quantifierName]);
    }
    
    ///////////////////////////////////////
    /// Set date since                  ///
    ///////////////////////////////////////

    [self setDateSinceForPlot:[[NSDate alloc] init]];
}

- (void)showActionSheetFromBarButtonItem:(UIBarButtonItem *)sender
{
    UIAlertController *myActionSheet = [UIAlertController alertControllerWithTitle:@"What would you like to do with a CSV file generated from this Quantifier?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *emailaction = [UIAlertAction actionWithTitle:@"Email CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        //        NSLog(@"Document Dir: %@", documentsDirectory);
        
        NSString *fileName =[NSString stringWithFormat:@"%@.csv", [[quantifier quantifierName]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        NSData *csvFile = [self.quantifier.csvContents dataUsingEncoding:NSUTF8StringEncoding];
        [csvFile writeToFile:fullPath atomically:YES];
        NSData *csvData = [NSData dataWithContentsOfFile:fullPath];
        
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:[NSString stringWithFormat:@"Quantifier: %@", self.quantifier.quantifierName]];
        [mailController addAttachmentData:csvData mimeType:@"text/csv" fileName:[[self.quantifier.quantifierName stringByAppendingString:@".csv"]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        
        UIColor *tintColor = [SZTheme tintColor];
        
        mailController.view.tintColor=tintColor;
        if ([MFMailComposeViewController canSendMail]) {
            [self presentViewController:mailController animated:YES completion:nil];
        }else {
            NSLog(@"No mail account set up.");
        }
    }];

    
    UIAlertAction *textaction = [UIAlertAction actionWithTitle:@"Text Message CSV" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        //        NSLog(@"Document Dir: %@", documentsDirectory);
        
        NSString *fileName =[NSString stringWithFormat:@"%@.csv", [[quantifier quantifierName]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        NSData *csvFile = [self.quantifier.csvContents dataUsingEncoding:NSUTF8StringEncoding];
        [csvFile writeToFile:fullPath atomically:YES];
        NSData *csvData = [NSData dataWithContentsOfFile:fullPath];
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        
        UIColor *tintColor = [SZTheme tintColor];
        messageController.view.tintColor=tintColor;
        if ([MFMessageComposeViewController canSendText]) {
            messageController.messageComposeDelegate = self;
            [messageController addAttachmentData:csvData typeIdentifier:@"text/csv" filename:[[self.quantifier.quantifierName stringByAppendingString:@".csv"]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [self presentViewController:messageController animated:YES completion:nil];
        } else{
            
            NSLog(@"No messaging account set up.");
        }
    }];
    
    UIAlertAction *openinaction = [UIAlertAction actionWithTitle:@"Open CSV in..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showDocumentInteractionController:self.UIBarButtonItemsArray.firstObject];
    }];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [myActionSheet addAction:emailaction];
    [myActionSheet addAction:textaction];
    [myActionSheet addAction:openinaction];
    [myActionSheet addAction:cancelaction];
    
    
    
    
    
    
    [self presentViewController:myActionSheet animated:YES completion:nil];
    
    
    
//    UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:@"What would you like to do with a CSV file generated from this Quantifier?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email CSV", @"Text Message CSV",@"Open CSV in...", nil];
//    myActionSheet.tag=1;
//    
//    
//    UIColor *tintColor = [SZTheme tintColor];
//    
//    for (id actionSheetSubview in myActionSheet.subviews) {
//        if ([actionSheetSubview isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)actionSheetSubview;
//            [button setTitleColor:tintColor forState:UIControlStateNormal];
//            [button setTitleColor:tintColor forState:UIControlStateSelected];
//            [button setTitleColor:tintColor forState:UIControlStateHighlighted];
//        }
//    }
//    [myActionSheet showFromBarButtonItem:self.UIBarButtonItemsArray.firstObject animated:YES];
    
}

-(void)tappedGoalButton
{
    NSString *cancelString;
    if (quantifier.goal) {
        cancelString=@"Remove Goal";
    }else{
        cancelString=@"Cancel";
    }
    
    UIAlertController *goalalert =[UIAlertController alertControllerWithTitle:@"What is your goal value?" message:@"A horizontal line will be put on the plot to represent your goal." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        quantifier.goal=nil;
        [dataSetTable reloadData];
    }];
    
    __weak UIAlertController *wgoalalert = goalalert;
    
    [goalalert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     
     {
         textField.placeholder = @"What you are tracking.";
         textField.keyboardType = UIKeyboardTypeDecimalPad;
         if (self.quantifier.goal) {
             [[[wgoalalert textFields] objectAtIndex:0] setText:[self.quantifier.goal stringValue]];
         }
     }];
    
    UIAlertAction *setgoalaction = [UIAlertAction actionWithTitle:@"Set Goal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *goalString=[[goalalert textFields] objectAtIndex:0].text;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:goalString];
        if (myNumber) {
            quantifier.goal = myNumber;
            [dataSetTable reloadData];
        } else{
            UIAlertController *nanalert = [UIAlertController alertControllerWithTitle:@"Um..." message:@"That's not a number. Try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
            
            [nanalert addAction: cancelaction];
            
            [self presentViewController:nanalert animated:YES completion:nil];
            
            
            return;
        }
    }];
    
    [goalalert addAction:cancelaction];
    [goalalert addAction:setgoalaction];
    
    [self presentViewController:goalalert animated:YES completion:nil];
    
    //UIAlertView *goalAlert = [[UIAlertView alloc]initWithTitle:@"What is your goal value?" message:@"A horizontal line will be put on the plot to represent your goal." delegate:self cancelButtonTitle:cancelString otherButtonTitles:@"Set Goal", nil];
    //goalAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //[[goalAlert textFieldAtIndex:0]setKeyboardType:UIKeyboardTypeDecimalPad];
    //goalAlert.tag=10;
    
    //if (self.quantifier.goal) {
    //    [[goalAlert textFieldAtIndex:0]setText:[self.quantifier.goal stringValue]];
    //}
    
    //[goalAlert show];
    
}


- (void)toggleHeaderViewStyle
{
    if (self.headerStyle==0) {
        self.headerStyle=1;
    } else {
        self.headerStyle=0;
    }

    [dataSetTable reloadData];
//    if ([self.selectedRowIntegerValue integerValue]>-1) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectedRowIntegerValue integerValue] inSection:0];
//        [dataSetTable selectRowAtIndexPath:indexPath animated:noErr scrollPosition:UITableViewScrollPositionNone];
//        
//    }

}

- (void)toggleFitCurve
{
    return;
}

- (void)showDocumentInteractionController:(UIBarButtonItem *)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //        NSLog(@"Document Dir: %@", documentsDirectory);
    
    NSString *fileName =[NSString stringWithFormat:@"%@.csv", [[quantifier quantifierName]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSData *csvFile = [self.quantifier.csvContents dataUsingEncoding:NSUTF8StringEncoding];
    [csvFile writeToFile:fullPath atomically:YES];
    
    
    
    UIDocumentInteractionController *interactionController = [[UIDocumentInteractionController alloc]init];
    self.myDocumentInteractionController = interactionController;
    NSURL *mynewurl = [NSURL fileURLWithPath:fullPath];
    [interactionController setURL:mynewurl];
    [interactionController setUTI:@"text/csv"];
    [interactionController presentOpenInMenuFromBarButtonItem:self.UIBarButtonItemsArray.firstObject  animated:YES];
}



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectFirstRow
{
    self.selectedRowIntegerValue = @0;
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITextView *newQuantifierTextField = (UITextView *)self.navigationItem.titleView;
    NSString *newQuantifierTitle = newQuantifierTextField.text;
    SZQuantifier *currentQuantifier = self.quantifier;
    NSString *currentQuantifierType=self.quantifier.type;
    
    
    // "Save" changes to the item. Name only changes if it's not left blank and if it's valid.
    if (![newQuantifierTitle isEqualToString:self.quantifier.quantifierName]) {
        
        NSCharacterSet *invalidFsChars = [NSCharacterSet characterSetWithCharactersInString:@"_/\\?%*|\"<>"];
        NSString *scrubbed = [newQuantifierTitle stringByTrimmingCharactersInSet:invalidFsChars];
        if ( ![newQuantifierTitle isEqualToString:scrubbed]) {
            UIAlertController *badfilenamealert = [UIAlertController alertControllerWithTitle:@"Bad name." message:@"That name contains invalid file name characters. Please try again." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"Ok, I'm sorry." style:UIAlertActionStyleCancel handler:nil];
            
            [badfilenamealert addAction:cancelaction];
            
            [self presentViewController:badfilenamealert animated:YES completion:nil];
            
            
            
            [textField setText:[currentQuantifier quantifierName]];
        }else{
            SZQuantifier *quantifierWithNewName = [[SZQuantifierStore sharedStore] createQuantifierWithName:newQuantifierTitle withDataSet:self.quantifier.dataSet];
            //[[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifierWithNewName];
            [quantifierWithNewName setType:currentQuantifierType];
            [quantifierWithNewName setGoal:currentQuantifier.goal];
            [self setQuantifier:quantifierWithNewName];
            
            [[SZQuantifierStore sharedStore] removeQuantifier:currentQuantifier];
        }
        
        
        
    }
}


- (IBAction)trackNowButtonToggle:(id)sender {
//    SZDataPoint *newDataPoint = [[SZDataPoint alloc]initWithDataPointValue:0 ];
//
//    DataPointViewController *dpvc = [[DataPointViewController alloc] init];
//    
//    [dpvc setDatapoint:newDataPoint];
//    [dpvc setQuantifier:quantifier];
//    [dpvc setType:@"creating"];
//    
//    NSLog(@"Heading off to the new datapoint's view for %@", [quantifier quantifierName] );
//    
//    dpvc.transitioningDelegate = self;
//    dpvc.modalPresentationStyle = UIModalPresentationCustom;
//    
//    [[self navigationController] pushViewController:dpvc animated:YES];
//    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    
    SZDataPoint *newDataPoint = [[SZDataPoint alloc]initWithDataPointValue:0];
    TableBasedDataPointViewController *tbdpvc = [[TableBasedDataPointViewController alloc]init];
    
    [tbdpvc setDatapoint:newDataPoint];
    [tbdpvc setQuantifier:quantifier];
    [tbdpvc setType:@"creating"];
    
    tbdpvc.transitioningDelegate=self;
    tbdpvc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController pushViewController:tbdpvc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfCells=0;
    if (quantifier.dateSinceForPlot==nil) {
        numberOfCells = [quantifier.dataSet count];
    } else{
        numberOfCells = [[quantifier dataSetSinceDate:quantifier.dateSinceForPlot]  count];
    }

    // NSLog(@"DetailViewController's numberOfRowsInSection replied: %d cell(s).", numberOfCells);
    if (numberOfCells>0) {
        return numberOfCells;
    }else {
        // This returns 1 so the "no data... add data above" cell can be added.
        return 1;
    }
    ;
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (self.headerStyle==0) {
        //[self.quantifier setPlot:nil];
        [self.quantifier updatePlot];
        
        if ([[self selectedRowIntegerValue] integerValue]>-1) {
            
            NSInteger intSelectedRowIntegerValue = [selectedRowIntegerValue integerValue];
            NSInteger numOfDataPoints = [[quantifier dataSet] count];
            UIGraphicsBeginImageContextWithOptions([self.quantifier.plot.image size], NO, 0.0f);
            
            
            int circleSize = 4;
            
            int height = self.quantifier.plot.image.size.height;
            UIBezierPath *circlePath = [[UIBezierPath alloc]init];

            NSInteger dataSetAndItsSubsetOffset = [self.quantifier.dataSet count]-[self.quantifier.plotXLocations count];
            
            [circlePath moveToPoint:CGPointMake([(self.quantifier.plotXLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue]+circleSize,
                                                height-[(self.quantifier.plotYLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue])];
            
            [circlePath addLineToPoint:CGPointMake([(self.quantifier.plotXLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue],
                                                   height-[(self.quantifier.plotYLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue]+circleSize)];
            
            [circlePath addLineToPoint:CGPointMake([(self.quantifier.plotXLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue]-circleSize,
                                                   height-[(self.quantifier.plotYLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue])];
            
            [circlePath addLineToPoint:CGPointMake([(self.quantifier.plotXLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue],
                                                   height-[(self.quantifier.plotYLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue]-circleSize)];
            
            [circlePath addLineToPoint:CGPointMake([(self.quantifier.plotXLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue]+circleSize,
                                                   height-[(self.quantifier.plotYLocations)[numOfDataPoints-intSelectedRowIntegerValue-1-dataSetAndItsSubsetOffset] floatValue])];
            
            
            
            UIColor *pointHighlightColor = [SZTheme pointHighlightColor];
            [pointHighlightColor setStroke];
            [pointHighlightColor setFill];
            
            [circlePath stroke];
            [circlePath fill];
            UIImage *imageWithSelectedPoint =UIGraphicsGetImageFromCurrentImageContext();
            UIImageView *imageViewWithSelectedPoint = [[UIImageView alloc] initWithImage:imageWithSelectedPoint];
            
            //CGContextRelease(contexter);
            
            if ([self.quantifier.plot.subviews count]>0) {
                [(self.quantifier.plot.subviews)[0] removeFromSuperview];
            }
            
            [self.quantifier.plot addSubview:imageViewWithSelectedPoint];
            [self.quantifier.plot addSubview:self.dateRangeSegmentedControl];
            [self.dateRangeSegmentedControl setSelectedSegmentIndex:selectedSegmentInUISegmentedControl];
            [self.dateRangeSegmentedControl addTarget:self action:@selector(dateRangeSelected:) forControlEvents:UIControlEventValueChanged];
            
            ////////////////////////////////////////
            /// This is implemented again below ////
            ////////////////////////////////////////
            
            NSInteger yLoc;
            
            if (quantifier.hasSegmentedControlInDetailView) {
                yLoc=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton+35;
            }else
            {
                yLoc=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton;
            }
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, yLoc, [UIScreen mainScreen].bounds.size.width, 0.5)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [self.quantifier.plot addSubview:lineView];
            
            ////////////////////////////////////////
            ////////////////////////////////////////
            ////////////////////////////////////////
            
            
            
            [self setHeaderView:self.quantifier.plot];
            self.headerView.userInteractionEnabled=YES;
            return self.quantifier.plot;
        } else{
            [self setHeaderView:self.quantifier.plot];
            self.headerView.userInteractionEnabled=YES;
            return self.quantifier.plot ;
        }

    }
    
    if (self.headerStyle==1) {
        StatsHeaderViewController *statsHeader = [[StatsHeaderViewController alloc]init];
        
        [statsHeader setQuantifier:quantifier];
        
        
        UIColor *backgroundColor = [SZTheme backgroundColor];
        statsHeader.view.backgroundColor=backgroundColor;
        if (quantifier.hasSegmentedControlInDetailView) {
            [statsHeader.view addSubview:dateRangeSegmentedControl];
            [self.dateRangeSegmentedControl setSelectedSegmentIndex:selectedSegmentInUISegmentedControl];
        }
        
        ////////////////////////////////////////
        /// This is implemented again below ////
        ////////////////////////////////////////
        
        NSInteger yLoc;
        
        if (quantifier.hasSegmentedControlInDetailView) {
            yLoc=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton + 35;
        }else
        {
            yLoc=self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton;
        }
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, yLoc, [UIScreen mainScreen].bounds.size.width, 0.5)];
        lineView.backgroundColor=[UIColor lightGrayColor];
        [statsHeader.view addSubview:lineView];
        
        ////////////////////////////////////////
        ////////////////////////////////////////
        ////////////////////////////////////////
        statsHeader.view.userInteractionEnabled=YES;

        return statsHeader.view;
    }
    
    
    
    
    return self.quantifier.plot ;
}

- (UIView *)addSeparatorLineAtBottom:(UIView *)view
{
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[quantifier dataSet] count]>1) {
        if (quantifier.hasSegmentedControlInDetailView) {
            return self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton + 35;
        }
        return self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton;
    } else {
        return 0;
    };
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 88;
    }
    else {
        return 44;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numOfDataPoints = [[quantifier dataSet] count];
    
    if (numOfDataPoints>0) {
        
        NSString *dataPointValueString = [[quantifier dataSet][numOfDataPoints-[indexPath row]-1]  dataPointValueString ];
        
        
        NSArray *componentsBeforeAndAfterDecimalInDataPointValueString = [dataPointValueString componentsSeparatedByString:@"."];
        NSInteger numberOfDecimalPointsInLastDataPoint;
        
        if (componentsBeforeAndAfterDecimalInDataPointValueString.count>1 ) {
            numberOfDecimalPointsInLastDataPoint=[(NSString *)componentsBeforeAndAfterDecimalInDataPointValueString[1] length];
        } else {
            numberOfDecimalPointsInLastDataPoint =0;
        }
        
        
        
       // NSNumber *dataPointValue = [[[quantifier dataSet]objectAtIndex:numOfDataPoints-indexPath.row-1] dataPointValue];
        
        
        
        
        //NSString *stringForCellWithComparisonToGoalValue;
        
        if (indexPath.row==0) {
            
            
            
            SJZFirstCell *firstCell = [SJZFirstCell new];
            [firstCell setGoal:quantifier.goal];
            SZDataPoint *dp = [quantifier dataSet][numOfDataPoints-indexPath.row-1];

            firstCell = [[NSBundle mainBundle] loadNibNamed:@"SJZFirstCell" owner:self options:nil][0];
            [firstCell setDatapoint:dp];
            [firstCell setGoal:quantifier.goal];
            [firstCell updateContents];
            
            
            
            UIColor *backgroundColor = [SZTheme backgroundColor];
            UIColor *selectedCellColor = [SZTheme selectedCellColor];
            
            firstCell.backgroundColor = backgroundColor;
            firstCell.selectedBackgroundView = [[UIView alloc] initWithFrame:firstCell.bounds];
            firstCell.selectedBackgroundView.backgroundColor= selectedCellColor;
            
            
            
            if ([indexPath row]==[self.selectedRowIntegerValue integerValue]) {
                firstCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                firstCell.backgroundColor=[SZTheme selectedCellColor];
                firstCell.selectionStyle = YES;
            }else{
                firstCell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleLongPress:)];
            lpgr.minimumPressDuration = 1.0; //seconds
            lpgr.delegate = self;
            [firstCell addGestureRecognizer:lpgr];
            
            
            return firstCell;
            
//            double dataPointDouble = [dataPointValue doubleValue];
//            double goalDouble =[quantifier.goal doubleValue];
//            double goalDiff = dataPointDouble-goalDouble;
//            double negGoalDiff = goalDiff*-1;
//            
//            NSString *formatString = [[@"%." stringByAppendingString:[NSString stringWithFormat:@"%d",(int)numberOfDecimalPointsInLastDataPoint]]stringByAppendingString:@"lf"];
//            
//            
//            NSString *goalDiffString = [NSString stringWithFormat:formatString,goalDiff];
//            NSString *negGoalDiffString = [NSString stringWithFormat:formatString,negGoalDiff];
//            
//            if (goalDiff <0) {
//                stringForCellWithComparisonToGoalValue = [[[dataPointValueString stringByAppendingString:@" (" ] stringByAppendingString:negGoalDiffString] stringByAppendingString:@" below goal)"];
//                
//            } else if (goalDiff>0){
//                stringForCellWithComparisonToGoalValue = [[[dataPointValueString stringByAppendingString:@" (" ] stringByAppendingString:goalDiffString] stringByAppendingString:@" above goal)"];
//            } else{
//                stringForCellWithComparisonToGoalValue = [dataPointValueString stringByAppendingString:@" (On the goal)"];
//
//            }
            
        }
        else{
            
            SZDataPoint *thisDataPoint = [quantifier dataSet][numOfDataPoints-[indexPath row]-1];
            UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"dataPointCell"];
            
            if (!cell) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dataPointCell"];
            }
            
            UIColor *backgroundColor = [SZTheme backgroundColor];
            UIColor *selectedCellColor = [SZTheme selectedCellColor];
            
            cell.backgroundColor = backgroundColor;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
            cell.selectedBackgroundView.backgroundColor= selectedCellColor;
            
            if ([indexPath row]==[self.selectedRowIntegerValue integerValue]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor=[SZTheme selectedCellColor];
                cell.selectionStyle = YES;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            UIColor *detailTextColor = [SZTheme detailTextColor];
            
            cell.detailTextLabel.textColor = detailTextColor;
            
            
            NSString *fontString = [SZTheme fontString];
            cell.textLabel.font = [UIFont fontWithName:fontString size:18];
            cell.detailTextLabel.font = [UIFont fontWithName:fontString size:13];
            
            
            
            NSDate *dataPointsTimeStamp = thisDataPoint.timeStamp;
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
            NSDate *today = [cal dateFromComponents:components];
            components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dataPointsTimeStamp];
            NSDate *justDayOfNewDateForThisDataPoint = [cal dateFromComponents:components];
            
            BOOL dateIsToday;
            
            if([today isEqualToDate:justDayOfNewDateForThisDataPoint]) {
                dateIsToday=YES;
            }else{
                dateIsToday=NO;
            }
            
            NSString *stringFromDate;
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            
            if (dateIsToday) {
                [formatter setDateFormat:@"h:mm a"];
            }else{
                [formatter setDateFormat:@"MMMM d, y 'at' h:mm a"];
            }
            
            stringFromDate = [formatter stringFromDate:dataPointsTimeStamp];
            
            
            
            
            [cell.detailTextLabel setText:[[self shortStringOfTimeSinceNowFromNSDate:thisDataPoint.timeStamp] stringByAppendingString:[NSString stringWithFormat:@" (%@)",stringFromDate]]];
            
            
           
            
            //[[cell detailTextLabel] setText:stringFromDate];
            [[cell textLabel] setText: dataPointValueString];
            
            
            UIColor *mainTextColor = [SZTheme mainTextColor];
            
            cell.textLabel.textColor = mainTextColor;
            
            
            UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(handleLongPress:)];
            lpgr.minimumPressDuration = 1.0; //seconds
            lpgr.delegate = self;
            [cell addGestureRecognizer:lpgr];
            
            
            
            
            
            
            
            return cell;
        }
        
        
//        if (stringForCellWithComparisonToGoalValue) {
//            [[cell textLabel] setText: stringForCellWithComparisonToGoalValue];
//        }else {
//            [[cell textLabel] setText: dataPointValueString];
//        }
        


        
        //    NSLog(@"Cell constructed by cellForRowAtIndexPath within DetailViewController.");
        
        
        
        
    } else { // If the
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell.textLabel setText:@"No data."];
        [cell.textLabel setTextColor:[SZTheme mainTextColor]];
        [cell.detailTextLabel setText:@""]   ;

        cell.userInteractionEnabled = false;
        [[cell textLabel] setTextColor:[UIColor grayColor]];

        UIColor *backgroundColor = [SZTheme backgroundColor];
        
        cell.backgroundColor = backgroundColor;
        
        
        NSString *fontString = [SZTheme fontString];
        cell.textLabel.font = [UIFont fontWithName:fontString size:18];
        cell.detailTextLabel.font = [UIFont fontWithName:fontString size:13];
        
        
        return  cell;
    };


}



- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
        
        self.cellBeingCopied = (UITableViewCell *)gestureRecognizer.view;
        //UIActionSheet *copyActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Copy value to clipboard", nil];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"What would like to do with this data point?" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSIndexPath *indexPath = [dataSetTable indexPathForCell:(UITableViewCell *)cellBeingCopied];
        NSInteger totalRow = [dataSetTable numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
        if(indexPath.row != totalRow-1){
            NSLog(@"this is not the last row");
            NSLog(@"row is %ld, section is %ld",(long)indexPath.row, (long)indexPath.section);
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:@"Copy delta from last value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSNumber *thisValue;
                
                if ([self.cellBeingCopied isKindOfClass:[SJZFirstCell class]])
                {
                    thisValue = [(SJZFirstCell *)self.cellBeingCopied datapoint].dataPointValue;
                    
                }else if ([self.cellBeingCopied isKindOfClass:[UITableViewCell class]])
                {
                    thisValue = [NSNumber numberWithFloat:[self.cellBeingCopied.textLabel.text componentsSeparatedByString:@" ("][0].floatValue];
                    
                }

                SZDataPoint *previousDatapoint = [quantifier.dataSet objectAtIndex:[quantifier.dataSet count]-indexPath.row-1-1];
                NSNumber *previousValue = previousDatapoint.dataPointValue;

                
                NSLog(@"%@, %@",thisValue,previousValue);
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string= [NSNumber numberWithFloat: thisValue.floatValue-previousValue.floatValue].stringValue;
                
                // OK button tapped.
                
            }]];
        }
        
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped.
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Copy value to clipboard" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                
                if ([self.cellBeingCopied isKindOfClass:[SJZFirstCell class]])
                {
                    pasteboard.string = [(SJZFirstCell *)self.cellBeingCopied datapoint].dataPointValueString;
                    NSLog(@"copying value");
                }else if ([self.cellBeingCopied isKindOfClass:[UITableViewCell class]])
                {
                    pasteboard.string = [self.cellBeingCopied.textLabel.text componentsSeparatedByString:@" ("][0];
                    NSLog(@"copying value");
                }
                
            
        }]];
        

        
        
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
        
        //copyActionSheet.tag=2;
        //[copyActionSheet showFromRect:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45) inView:self.view animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger numOfDataPoints = [[quantifier dataSet] count];
        SZDataPoint *p= [quantifier dataSet][numOfDataPoints-[indexPath row]-1];
        [quantifier removeDataPoint:p];
        NSInteger newNumOfDataPoints = [[quantifier dataSet] count];
        [self setUpSegmentedControlIfItsNeeded];
        
        if (newNumOfDataPoints == 0) {
            //remove the only data point row
            [CATransaction begin];
            [tableView beginUpdates];
            [CATransaction setCompletionBlock:^{
                selectedRowIntegerValue = @0;
                [dataSetTable reloadData];
                [quantifier updateCsvContents];
             //   [quantifier updatePlot];
                [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifier];
            }];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
            //add the empty one
            

            [dataSetTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // reload
            [CATransaction commit];
            [tableView endUpdates];
        }
        
        if (newNumOfDataPoints==1) {
            
            selectedRowIntegerValue = @0;
            //[quantifier updatePlot];
            [dataSetTable reloadData];
            [quantifier updateCsvContents];
            [self viewWillAppear:YES];
            [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifier];
            
        }
        
        if (newNumOfDataPoints>1) {
            //removethedatapoint, with animation
            [CATransaction begin];
            [tableView beginUpdates];
            [CATransaction setCompletionBlock:^{
                selectedRowIntegerValue = @0;
                
                [quantifier updateCsvContents];
               // [quantifier updatePlot];
                [dataSetTable reloadData];
                [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifier];
             
            }];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationLeft];
            //reload
            [CATransaction commit];
            [tableView endUpdates];
            [self performSelector:@selector(updateBlurredScreenshot) withObject:nil afterDelay:0.1];
        }



    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
    // Clear first responder
    
    
    [[self view] endEditing:YES];
    

    
}




- (void)updateTableView:(NSNotification *)notification {
    [dataSetTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [self setNumberOfDPVCsPushedSincePushingThisDVC:@([self.numberOfDPVCsPushedSincePushingThisDVC integerValue]+1)];

    
    NSLog(@"This DVC has been pushed %@ times\n", self.numberOfDPVCsPushedSincePushingThisDVC);
    
    
    if ([self.numberOfDPVCsPushedSincePushingThisDVC integerValue]<6) {
        [self performSelectorInBackground:@selector(updateBlurredScreenshot) withObject:Nil];
    }

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger detailViewCount;
    detailViewCount = [userDefaults integerForKey:@"detailViewCount"]+1;
    [userDefaults setInteger:detailViewCount forKey:@"detailViewCount"];
    [userDefaults synchronize];
    
    if (detailViewCount==1) {
        
        if ([[SZQuantifierStore sharedStore]numberOfQuantifiers]<3 &&![quantifier.type isEqualToString:@"AutoStepTrackingOn"] ) {
            UIAlertController *welcome = [UIAlertController alertControllerWithTitle:@"Let's start collecting data!" message:@"Tap the \"+\" button at the top right of the screen to create a new \n data point in this Quantifier.\n\n Add enough data, and I'll show \n you a snazzy plot." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK, let's try it." style:UIAlertActionStyleCancel handler:nil];
            
            [welcome addAction:cancel];
            
            [self presentViewController:welcome animated:YES completion:nil];
            
        } else if ([[SZQuantifierStore sharedStore]numberOfQuantifiers]<2 &&[quantifier.type isEqualToString:@"AutoStepTrackingOn"]){
            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"detailViewCount"];
        }
        
        
        //detailViewCount = [userDefaults integerForKey:@"detailViewCount"]+1;
    }
    


    
    
  
}

-(void)refreshStepTracker
{
    [self.quantifier updateAutoStepTracker];
    [refresher endRefreshing];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    
    if (!self.tableBasedDataPointViewControllerToBePushed) {
        [self setTableBasedDataPointViewControllerToBePushed:[[TableBasedDataPointViewController alloc]init]];
        
    }
    NSInteger numOfDataPoints = [[quantifier dataSet] count];
    SZDataPoint *datapointToBePushed = [quantifier dataSet][numOfDataPoints-[indexPath row]-1];

    
    [self.tableBasedDataPointViewControllerToBePushed setDatapoint:datapointToBePushed];
    [self.tableBasedDataPointViewControllerToBePushed setQuantifier:quantifier];
    [self.tableBasedDataPointViewControllerToBePushed setType:@"editing"];

   // NSIndexPath *test = [tableView indexPathForSelectedRow];
    
    if ([self.selectedRowIntegerValue integerValue]==[indexPath row]) {
        
        if (TRUE) { //![quantifier.type isEqualToString:@"AutoStepTrackingOn"] <-- this can be used instead of TRUE to not allow editing step tracker data points
            NSLog(@"Heading off to the datapoint view for %@, datapoint %ld", [quantifier quantifierName], (long)[indexPath row]    );
            
            [[self navigationController] pushViewController:tableBasedDataPointViewControllerToBePushed animated:YES];
            
            [self setTableBasedDataPointViewControllerToBePushed:nil];
        }
        
    } else{
        NSInteger intvalueforselectedrow = [indexPath row]  ;
        [self setSelectedRowIntegerValue:@(intvalueforselectedrow)];
        [tableView reloadData];
        [tableView selectRowAtIndexPath:indexPath animated:noErr scrollPosition:UITableViewScrollPositionNone];
 
    }

    
}

-(void)updateBlurredScreenshot{
    
    UIImage *snapshotImage;
    if (quantifier.hasSegmentedControlInDetailView) {
        snapshotImage = quantifier.plot.image;
    }else {
        
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        [dataSetTable drawViewHierarchyInRect:dataSetTable.bounds afterScreenUpdates:NO];
        
        
        [headerView drawViewHierarchyInRect:headerView.frame afterScreenUpdates:NO];
        
        snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    

    if ([currentTheme isEqualToString:@"Vampire"] | [currentTheme isEqualToString:@"Glam"]) {
        UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
        [self.quantifier setBlurredScreenShot:blurredSnapshotImage];
    }else
    {
        if ([[quantifier dataSet]count] > 50) {
            UIImage *blurredSnapshotImage = [snapshotImage applyLightererEffect];
            [self.quantifier setBlurredScreenShot:blurredSnapshotImage];
        } else {
            UIImage *blurredSnapshotImage = [snapshotImage applyLighterEffect];
            [self.quantifier setBlurredScreenShot:blurredSnapshotImage];
        }
        
        
    }
    
    
    UIGraphicsEndImageContext();
    
}

-(void)updateStepTracker
{
    
    if  ([self.quantifier.type isEqualToString:@"AutoStepTrackingOn"])
    {
        [self.quantifier updateAutoStepTracker];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataTable) name:@"doneUpdatingStepTracker" object:nil];
        
        NSLog(@"refreshed tracker from detailviewcontroller");
    }

}

-(void)dateRangeSelected:(id)sender
{
    UISegmentedControl *segmentedControl =(UISegmentedControl *)sender;
    self.selectedSegmentInUISegmentedControl = segmentedControl.selectedSegmentIndex;
    
    NSString *buttonText = [sender titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
    
    NSLog(@"Requested date range be changed to %@",buttonText);
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *dayStart = [calendar dateFromComponents:components];
    
    NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:dayStart toDate:now options:0];
    NSInteger numberOfSecondsSinceMidnight = [diff second];
    
    if ([buttonText isEqualToString:@"All time"]) {
        [[self quantifier]setDateSinceForPlot:nil];
        self.quantifier.statisticsTitle=@"Statistics (All Time)";
    }
    if ([buttonText isEqualToString:@"7 days"]) {
        [[self quantifier]setDateSinceForPlot:[[NSDate alloc] initWithTimeIntervalSinceNow:-6*24*60*60-numberOfSecondsSinceMidnight]];
        self.quantifier.statisticsTitle=@"Statistics (Last 7 Days)";
    }
    if ([buttonText isEqualToString:@"30 days"]) {
        [[self quantifier]setDateSinceForPlot:[[NSDate alloc] initWithTimeIntervalSinceNow:-30*24*60*60]];
        self.quantifier.statisticsTitle=@"Statistics (Last 30 Days)";
    }
    if ([buttonText isEqualToString:@"6 mos."]) {
        [[self quantifier]setDateSinceForPlot:[[NSDate alloc] initWithTimeIntervalSinceNow:-30.4*6*24*60*60]];
        self.quantifier.statisticsTitle=@"Statistics (Last 6 Months)";
    }
    if ([buttonText isEqualToString:@"1 year"]) {
        [[self quantifier]setDateSinceForPlot:[[NSDate alloc] initWithTimeIntervalSinceNow:-365.25*24*60*60]];
        self.quantifier.statisticsTitle=@"Statistics (Last 1 Year)";
    }
    
    selectedRowIntegerValue=0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSLog(@"Since date: %@",[formatter stringFromDate:self.quantifier.dateSinceForPlot]);
    
    
    [self.quantifier updateStats];
    [dataSetTable reloadData];
}

-(void)reloadDataTable
{
    [dataSetTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)setUpSegmentedControlIfItsNeeded
{
    UISegmentedControl *segmentedControl = [UISegmentedControl new];
    
    
    
    NSMutableArray *dataSetSinceLastWeek = [self.quantifier dataSetSinceDate:[[NSDate alloc]initWithTimeIntervalSinceNow:-60*60*24*7]];
    NSMutableArray *dataSetSince30Days = [self.quantifier dataSetSinceDate:[[NSDate alloc]initWithTimeIntervalSinceNow:-60*60*24*30]];
    NSMutableArray *dataSetSince6months = [self.quantifier dataSetSinceDate:[[NSDate alloc]initWithTimeIntervalSinceNow:-60*60*24*30*6]];
    NSMutableArray *dataSetSinceYear = [self.quantifier dataSetSinceDate:[[NSDate alloc]initWithTimeIntervalSinceNow:-60*60*24*365]];
    
    
    [segmentedControl insertSegmentWithTitle:@"All time" atIndex:1 animated:NO];
    
    if ([dataSetSinceYear count]>1 && [dataSetSinceYear count]!=[self.quantifier.dataSet count]) {
        [segmentedControl insertSegmentWithTitle:@"1 year" atIndex:[segmentedControl numberOfSegments] animated:NO];
    }
    if ([dataSetSince6months count]>1 && [dataSetSince6months count]!=[self.quantifier.dataSet count]) {
        [segmentedControl insertSegmentWithTitle:@"6 mos." atIndex:[segmentedControl numberOfSegments] animated:NO];
    }
    if ([dataSetSince30Days count]>1 && [dataSetSince30Days count]!=[self.quantifier.dataSet count]) {
        [segmentedControl insertSegmentWithTitle:@"30 days" atIndex:[segmentedControl numberOfSegments] animated:NO];
    }
    if ( [dataSetSinceLastWeek count]>1 && [dataSetSinceLastWeek count]!=[self.quantifier.dataSet count]) {
        [segmentedControl insertSegmentWithTitle:@"7 days" atIndex:[segmentedControl numberOfSegments] animated:NO];
    }
    
    
    
    NSInteger yLocationOfSegmentedControl =self.quantifier.heightForPlotHeaderViewWithoutSegmentedButton -1;
    
    
    segmentedControl.frame = CGRectMake(5, yLocationOfSegmentedControl, [UIScreen mainScreen].bounds.size.width-10,30);
    segmentedControl.tintColor= [SZTheme segmentedControlColor];
    segmentedControl.userInteractionEnabled=YES;
    
    if ([segmentedControl numberOfSegments]==1) {
        segmentedControl=nil;
        self.quantifier.hasSegmentedControlInDetailView=NO;
    }else{
        self.quantifier.hasSegmentedControlInDetailView=YES;
    }
    
    self.dateRangeSegmentedControl = segmentedControl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)shortStringOfTimeSinceNowFromNSDate:(NSDate *)date
{
    //// This is copied from SZQuantifier's shortstringsincenowfromnsdatemethod. update that too if changes need to be made here. This method is different in that it requires cases for plural stuff. Copied directly into QuantifierTableViewCell.m from SJZFirstCell.m
    
    NSDate *nowdate =[NSDate date];
    NSTimeInterval interval = [nowdate timeIntervalSinceDate:date];
    int intervalint = interval ;
    
    
    if (intervalint<5) {
        return [NSString stringWithFormat:@"Updated just now"];
    }
    if (intervalint<60) {
        return [NSString stringWithFormat:@"Less than 1 minute ago"];
    }
    if (intervalint<3600) {
        int minutes = (intervalint+60/2)/60;
        NSString *firstHalf;
        if (minutes==1) {
            firstHalf= @"%d minute ago";
        }else{
            firstHalf= @"%d minutes ago";
        }
        return [NSString stringWithFormat:firstHalf, minutes];
    }
    if (intervalint<86400) {
        int hours = (intervalint+60*60/2)/3600;
        NSString *firstHalf;
        if (hours==1) {
            firstHalf= @"%d hour ago";
        }else{
            firstHalf= @"%d hours ago";
        }
        return [NSString stringWithFormat:firstHalf, hours];
        
    }
    if (intervalint<2419200) {
        // this uses days until 24 days, then switches to weeks below -- this means that the non-plural case for weeks below isn't needed.
        int days = (intervalint+60*60*24/2)/86400;
        NSString *firstHalf;
        if (days==1) {
            firstHalf= @"%d day ago";
        }else{
            firstHalf= @"%d days ago";
        }
        return [NSString stringWithFormat:firstHalf, days];
        
    }
    
    return [NSString stringWithFormat:@"%d weeks ago", (intervalint+60*60*24*7/2)/604800];
    
}


@end
