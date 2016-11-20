//
//  TableBasedDataPointViewController.m
//  Quantifier
//
//  Created by Scott Zero on 3/17/14.
//  Copyright (c) 2014 Scott Zero. All rights reserved.
//

#import "TableBasedDataPointViewController.h"
#import "DataPointViewFirstCell.h"
#import "DataPointDateTableViewCell.h"
#import "SZTheme.h"
#import "IncrementingTableViewCell.h"


@interface TableBasedDataPointViewController () <UITextFieldDelegate>


@end

@implementation TableBasedDataPointViewController

@synthesize datapoint,quantifier,type,dvc,firstCellInTable, isEditingDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    UIBarButtonItem *
    rightDoneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDoneButton];
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDataPointAdd:)];
    [self.navigationItem setLeftBarButtonItem:leftCancelButton];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //UIColor *backgroundColor = [SZTheme backgroundColor];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:self.quantifier.blurredScreenShot];
    backgroundImageView.contentMode=UIViewContentModeTop;
    backgroundImageView.backgroundColor=[SZTheme backgroundColor];
    
    
    self.tableView.backgroundView=backgroundImageView;
//    if (![themeString isEqualToString:@"Vampire"]) {
//        self.tableView.backgroundView=backgroundImageView;
//    } else {
//        [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
//    }
    
    UITextField *titleName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 22)];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont fontWithName:[SZTheme fontString] size:19];
    titleName.textColor = [SZTheme tintColor];
    titleName.textAlignment = NSTextAlignmentCenter;
    if ([self.type isEqualToString:@"editing"]) {
        titleName.text =@"Edit Data Point" ;
        titleName.userInteractionEnabled = false;
    }else {
        titleName.text =@"Add Data Point" ;
        titleName.userInteractionEnabled = false;
        
    }
    self.navigationItem.titleView = titleName;
    
    /// load uidatepicker so it isn't so fucking slow to load later
    
    DatePickerTableViewCell *dateCell = [DatePickerTableViewCell new];
    dateCell = [[NSBundle mainBundle] loadNibNamed:@"DatePickerTableViewCell" owner:self options:nil][0];
    [dateCell.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    self.datePickerCell = dateCell;
    [self.datePickerCell.datePicker setDate:[datapoint timeStamp]];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfCells=2;
    if ([type isEqualToString:@"editing"]) {
        numberOfCells++;
    }
    if (isEditingDate){
        numberOfCells++;
    }
        
    
    return numberOfCells;
    
}

- (void)cancelDataPointAdd:(id)sender
{
    [firstCellInTable.valueLabel resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneButtonPress:(id)self];
    return NO;
}

- (IBAction)doneButtonPress:(id)sender
{
    // [valueLabel resignFirstResponder];
    
    [self doStuffOnDoneButtonPress];
    
    
    
    
    
}
-(void)doStuffOnDoneButtonPress {
    if ([[firstCellInTable.valueLabel text] length]>0) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *valueString = [firstCellInTable.valueLabel text];
        NSNumber * myNumber = [f numberFromString:[firstCellInTable.valueLabel text]];
        
        
        NSDate *myDate;
        if (self.datePickerCell.datePicker.date != datapoint.timeStamp) {
            myDate= [self.datePickerCell.datePicker date];
        }else{
            myDate = [datapoint timeStamp];
        }
        
        
        if (myNumber) {
            if (myNumber) {
                [datapoint setDataPointValue:myNumber];
                [datapoint setDataPointValueString:valueString];
                [datapoint setTimeStamp:myDate];
                
                
                // If the datapointviewcontroller is editing a previously created point, then the above command edited the datapoint within the model, and the csv contents and dropbox are ready to be updated. If we are creating a new data point, we have simply edited the instance variable that is not yet a part of the model (which belongs to the detailviewcontroller).
                
                if ([[self type] isEqualToString:@"editing"]) {
                    [quantifier sortDataSet];
                    [quantifier updateStats];
                    NSLog(@"datapoint edited within %@", [quantifier quantifierName]);
                }else{
                    // If the model doesn't contain this datapoint (because we are in creation mode and not editing mode, we need to add the data point to the model, and update the file in dropbox and in the local csv files.
                    [quantifier addDataPoint:datapoint];
                    [quantifier sortDataSet];
                    [quantifier updateStats];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addeddatapoint" object:nil];
                    
                    
                }
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"needscsvupdateandsync"];
                NSInteger selectedCellInteger = [quantifier.dataSet count]-[quantifier.dataSet indexOfObject:datapoint]-1;
                [[NSUserDefaults standardUserDefaults]setInteger:selectedCellInteger forKey:@"selectedcell"];
                
                
            }
            //                else if([myNumber floatValue]<0){
            //                UIAlertView *negativeNumberAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Negative numbers are not supported at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //                [negativeNumberAlert show];
            //                return;
            //            }
            
        }else {
            
            UIAlertController *nanalert = [UIAlertController alertControllerWithTitle:@"Um..." message:@"That's not even a number." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [nanalert addAction:cancelaction];
            
            [self presentViewController:nanalert animated:YES completion:nil];
            
            return;
        };
        
        
        
        
        //        if (myNumber) {
        //            [datapoint setDataPointValue:myNumber];
        //            [datapoint setDataPointValueString:valueString];
        //            [datapoint setTimeStamp:myDate];
        //            [quantifier sortDataSet];
        //            NSInteger selectedCellInteger = [quantifier.dataSet count]-[quantifier.dataSet indexOfObject:datapoint]-1;
        //            [[NSUserDefaults standardUserDefaults]setInteger:selectedCellInteger forKey:@"selectedcell"];
        //
        //            // If the datapointviewcontroller is editing a previously created point, then the above command edited the datapoint within the model, and the csv contents and dropbox are ready to be updated. If we are creating a new data point, we have simply edited the instance variable that is not yet a part of the model (which belongs to the detailviewcontroller).
        //
        //            if ([[self type] isEqualToString:@"editing"]) {
        //                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"needscsvupdateandsync"];
        //            };
        //            NSLog(@"datapoint edited within %@", [quantifier quantifierName]);
        //
        //        } else {
        //            UIAlertView *notANumberAlert = [[UIAlertView alloc]initWithTitle:@"Um..." message:@"That's not even a number." delegate:self cancelButtonTitle:@"I'm embarassed." otherButtonTitles: nil];
        //            [notANumberAlert show];
        //            return;
        //        }
        //
        //
        //        if ([[quantifier dataSet]containsObject:datapoint]) {
        //            // If this data point exists in the data set already, don't do anything. This condition is true if the datapointviewcontroller is editing a previously made point.
        //
        //        } else
        //        {
        //            // If the model doesn't contain this datapoint (because we are in creation mode and not editing mode, we need to add the data point to the model, and update the file in dropbox and in the local csv files.
        //            [quantifier addDataPoint:datapoint];
        //            [quantifier sortDataSet];
        //            [quantifier.dataSet indexOfObject:datapoint];
        //
        //            [[NSNotificationCenter defaultCenter] postNotificationName:@"addeddatapoint" object:nil];
        //            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"needscsvupdateandsync"];
        //            [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"selectedcell"];
        //            
        //        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)togglePosNeg:(id)sender {
    
    NSString *currentContent = [firstCellInTable.valueLabel text];
    NSString *justMinusSign = @"-";
    
    if ([currentContent length]==0) {
        NSString *str = @"-";
        [firstCellInTable.valueLabel setText:str];
    }else if ([currentContent isEqualToString:justMinusSign]){
        NSString *str = @"";
        [firstCellInTable.valueLabel setText:str];
    }else{
        NSNumber *num = @(-[[firstCellInTable.valueLabel text] doubleValue]);
        NSString *str = [num stringValue];
        [firstCellInTable.valueLabel setText:str];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat dataPointValueCellHeight=92;
    CGFloat incrementerCellHeight=58;
    CGFloat dateCellHeight=44;
    CGFloat datePickerCellHeight=200;
    
    if (indexPath.row==0) {
        return dataPointValueCellHeight;
    }
    
    if (indexPath.row==1) {
        if ([self.type isEqualToString:@"editing"]) {
            return incrementerCellHeight;
        }else{
            return dateCellHeight;
        }
    }
    
    if (indexPath.row==2){
        if ([self.type isEqualToString:@"editing"]) {
            return dateCellHeight;
        }else{
            return datePickerCellHeight;
        }
    }
    
    if (indexPath.row==3) {
        return datePickerCellHeight;
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSInteger numberOfRealCells=2;
    
    if ([self.type isEqualToString:@"editing"]) {
        numberOfRealCells++;
    };
    
    if (isEditingDate) {
        numberOfRealCells++;
    }
    
    NSInteger maxIndexForRealCell = numberOfRealCells-1;
    
    
    
    if (indexPath.row<=maxIndexForRealCell) {
        if (indexPath.row==0) {
            return [self getDataPointValueCell];
        }
        
        if (indexPath.row==1) {
            if ([self.type isEqualToString:@"editing"]) {
                return [self getIncrementerCell];
            }else{
                return [self getDateCell];
            }
            
        }
        
        if (indexPath.row==2){
            if ([self.type isEqualToString:@"editing"]) {
                return [self getDateCell];
            }else{
                return [self getDatePickerCell];
            }
        }
        
        if (indexPath.row==3) {
            return [self getDatePickerCell];
        }
    }else{
        UITableViewCell *blankCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [blankCell setBackgroundColor:[UIColor clearColor]];
        return blankCell;
    }
    
    
    
    
    return [UITableViewCell new];
    
}

- (DataPointViewFirstCell *)getDataPointValueCell
{
    DataPointViewFirstCell *firstCell = [DataPointViewFirstCell new];
    firstCell = [[NSBundle mainBundle] loadNibNamed:@"DataPointViewFirstCell" owner:self options:nil][0];
    self.firstCellInTable=firstCell;
    
    //self.extendedLayoutIncludesOpaqueBars=NO;
    UIColor *tintColor = [SZTheme tintColor];
    [firstCell.valueLabel setText:[datapoint dataPointValueString] ];
    [firstCell.valueLabel setFont:[UIFont fontWithName:[SZTheme fontString] size:50]];
    [firstCell.valueLabel setTextColor:tintColor];
    [firstCell.valueLabel setTintColor:tintColor];
    
    [firstCell.pluMinusButton setTintColor:[SZTheme tintColor]];
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Vampire"] | [currentTheme isEqualToString:@"Glam"]) {
        firstCell.valueLabel.keyboardAppearance=UIKeyboardAppearanceDark;
    }
    [firstCell.pluMinusButton setTintColor:tintColor];
    [firstCell.valueLabel becomeFirstResponder];
    firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
    firstCell.backgroundColor=[UIColor clearColor];
    return firstCell;
};
- (DataPointDateTableViewCell *)getDateCell
{
    DataPointDateTableViewCell *secondCell = [DataPointDateTableViewCell new];
    secondCell = [[NSBundle mainBundle] loadNibNamed:@"DataPointDateTableViewCell" owner:self options:nil][0];
    
    [secondCell.dateField setFont:[UIFont fontWithName:[SZTheme fontString] size:18]];
    
    UIColor *textColor;
    if (isEditingDate) {
        textColor = [SZTheme tintColor];
    }else{
        textColor = [SZTheme mainTextColor];
    }
    
    [secondCell.dateField setTextColor:textColor];
    
    NSDate *newDateForDataPoint = self.datePickerCell.datePicker.date;
    
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:newDateForDataPoint];
    NSDate *justDayOfNewDateForNewDataPoint = [cal dateFromComponents:components];
    
    BOOL dateIsToday;
    
    if([today isEqualToDate:justDayOfNewDateForNewDataPoint]) {
        dateIsToday=YES;
    }else{
        dateIsToday=NO;
    }
    
    NSString *stringFromDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    if (dateIsToday) {
        [formatter setDateFormat:@"'Today at' h:mm a"];
    }else{
        [formatter setDateFormat:@"MMMM d, y 'at' h:mm a"];
    }
    
    stringFromDate = [formatter stringFromDate:newDateForDataPoint];
    
    
    [secondCell.dateField setText:stringFromDate];
    
    
    secondCell.selectedBackgroundView = [[UIView alloc] initWithFrame:secondCell.bounds];
    secondCell.selectedBackgroundView.backgroundColor= [SZTheme selectedCellColor];
    
    
    secondCell.backgroundColor=[UIColor clearColor];
    
    return secondCell;
};
- (DatePickerTableViewCell *)getDatePickerCell
{
    
    [self.datePickerCell.datePicker setTintColor:[SZTheme tintColor]];
    [self.datePickerCell.datePicker setMaximumDate:[[NSDate alloc]init]];
    [self.view endEditing:YES];
    [self.datePickerCell.datePicker becomeFirstResponder];
    self.datePickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Vampire"]) {
        self.datePickerCell.backgroundColor=[UIColor colorWithWhite:0.25 alpha:1];
    }
    else {
        self.datePickerCell.backgroundColor=[UIColor clearColor];
    }
    return self.datePickerCell;
};
- (IncrementingTableViewCell *)getIncrementerCell
{
    IncrementingTableViewCell *incrementingCell = [IncrementingTableViewCell new];
    incrementingCell = [[NSBundle mainBundle] loadNibNamed:@"IncrementingTableViewCell" owner:self options:nil][0];
    incrementingCell.dataPointViewFirstCell =firstCellInTable;
    incrementingCell.tbdpvc=self;
    UIColor *alphadBackgroundColor = [[SZTheme backgroundColor] colorWithAlphaComponent:0.7] ;
    
    incrementingCell.incrementAmountField.backgroundColor = alphadBackgroundColor;
    incrementingCell.incrementAmountField.textColor = [SZTheme tintColor];
    incrementingCell.incrementAmountField.tintColor = [SZTheme tintColor];
    incrementingCell.plusButton.tintColor=[SZTheme tintColor];
    incrementingCell.minusButton.tintColor= [SZTheme tintColor];
    
    if (quantifier.incrementAmountString == nil) {
        quantifier.incrementAmountString=@"1";
    }
    [incrementingCell.incrementAmountField setText:quantifier.incrementAmountString];
    incrementingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Vampire"] | [currentTheme isEqualToString:@"Glam"]) {
        incrementingCell.incrementAmountField.keyboardAppearance=UIKeyboardAppearanceDark;
    }
    incrementingCell.backgroundColor=[UIColor clearColor];
    return incrementingCell;
};

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowTapped = indexPath.row;
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[DataPointDateTableViewCell class]]) {
        if (isEditingDate) {
            isEditingDate=NO;
            //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowTapped inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowTapped+1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:rowTapped inSection:0] animated:YES];
            
            [firstCellInTable.valueLabel becomeFirstResponder];
        }else
        {
            isEditingDate=YES;
            
            
            //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowTapped inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowTapped+1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //[self.tableView reloadData];
    }
}



-(void)dateChanged
{
    NSInteger rowToReload=1;
    if ([self.type isEqualToString:@"editing"]) {
        rowToReload++;
    }
    //[datapoint setTimeStamp:[self.datePickerCell.datePicker date]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToReload inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==2 && isEditingDate) {
        isEditingDate=NO;
        
        NSInteger rowToDelete=2;
        NSInteger rowToDeselect=1;
        
        if ([self.type isEqualToString:@"editing"]) {
            rowToDelete++;
            rowToDeselect++;
        }
        //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToDeselect inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:rowToDeselect inSection:0] animated:YES];
        //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToDelete inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowToDelete inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
    
    if (textField.tag==4) {
        quantifier.incrementAmountString=textField.text;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
