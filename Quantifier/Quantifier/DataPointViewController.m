//
//  DataPointViewController.m
//  Quantifier
//
//  Created by Scott Zero on 7/27/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "DataPointViewController.h"
#import "SZTheme.h"
#import "Flurry.h"

@interface DataPointViewController ()

@end

@implementation DataPointViewController
@synthesize datapoint,quantifier,type,dvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.extendedLayoutIncludesOpaqueBars=NO;
    
    [valueLabel setText:[datapoint dataPointValueString] ];
    [datePicker setDate:[datapoint timeStamp]];
    [datePicker setTintColor:[SZTheme tintColor]];
    [datePicker setMaximumDate:[[NSDate alloc]init]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM d, y 'at' h:mma"];
    
    NSString *stringFromDate = [formatter stringFromDate:[datapoint timeStamp]];
    [dateField setText:stringFromDate];
    
    UIColor *backgroundColor = [SZTheme backgroundColor];
    
    NSString *themeString = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    
    [backgroundimageview setBackgroundColor:backgroundColor];
    [backgroundimageview setImage:self.quantifier.blurredScreenShot];
    
//    if (![themeString isEqualToString:@"Vampire"]) {
//        [backgroundimageview setBackgroundColor:backgroundColor];
//        [backgroundimageview setImage:self.quantifier.blurredScreenShot];
//    } else {
//        [backgroundimageview setBackgroundColor:[UIColor darkGrayColor]];
//    }
    
    
    
    
    UITextField *titleName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 22)];
    
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont fontWithName:[SZTheme fontString] size:19];

    UIColor *tintColor = [SZTheme tintColor];
    
    
    titleName.textColor = [SZTheme tintColor];
    titleName.textAlignment = NSTextAlignmentCenter;
    
    [dateField setFont:[UIFont fontWithName:[SZTheme fontString] size:16]];
    [dateField setTextColor:[SZTheme mainTextColor]];
    [valueLabel setFont:[UIFont fontWithName:[SZTheme fontString] size:50]];
    [valueLabel setTextColor:tintColor];
    [valueLabel setTintColor:tintColor];
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    
    if ([currentTheme isEqualToString:@"Vampire"] | [currentTheme isEqualToString:@"Glam"]) {
        valueLabel.keyboardAppearance=UIKeyboardAppearanceDark;
    }
    [plusMinusButton setTintColor:tintColor];
    
    if ([self.type isEqualToString:@"editing"]) {
        titleName.text =@"Edit Data Point" ;
        titleName.userInteractionEnabled = false;
    }else {
        titleName.text =@"Add Data Point" ;
        titleName.userInteractionEnabled = false;
        
    }
    self.navigationItem.titleView = titleName;

    
    [valueLabel becomeFirstResponder];
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *rightDoneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDoneButton];
    [self.navigationItem setHidesBackButton:YES];
    
    UIBarButtonItem *leftCancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDataPointAdd:)];
    [self.navigationItem setLeftBarButtonItem:leftCancelButton];
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [Flurry logEvent:@"recievedAMemoryWarning"];
}




- (IBAction)togglePosNeg:(id)sender {

    NSString *currentContent = [valueLabel text];
    NSString *justMinusSign = @"-";

    if ([currentContent length]==0) {
        NSString *str = @"-";
        [valueLabel setText:str];
    }else if ([currentContent isEqualToString:justMinusSign]){
        NSString *str = @"";
        [valueLabel setText:str];
    }else{
        NSNumber *num = @(-[[valueLabel text] doubleValue]);
        NSString *str = [num stringValue];
        [valueLabel setText:str];
    }
    [Flurry logEvent:@"toggledPositiveNegative"];
    
}

- (void)cancelDataPointAdd:(id)sender
{
    [valueLabel resignFirstResponder];
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
    if ([[valueLabel text] length]>0) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *valueString = [valueLabel text];
        NSNumber * myNumber = [f numberFromString:[valueLabel text]];
        NSDate *myDate = [datePicker date];
        
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
                    [Flurry logEvent:@"DataPointEdited"];
                }else{
                    // If the model doesn't contain this datapoint (because we are in creation mode and not editing mode, we need to add the data point to the model, and update the file in dropbox and in the local csv files.
                    [quantifier addDataPoint:datapoint];
                    [quantifier sortDataSet];
                    [quantifier updateStats];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"addeddatapoint" object:nil];
                    [Flurry logEvent:@"DataPointAdded"];
                    
                    
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
            UIAlertView *notANumberAlert = [[UIAlertView alloc]initWithTitle:@"Um..." message:@"That's not even a number." delegate:self cancelButtonTitle:@"I'm embarassed." otherButtonTitles: nil];
            [notANumberAlert show];
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

@end
