//
//  ThemesTableViewController.m
//  Quantifier
//
//  Created by Scott Zero on 11/2/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "ThemesTableViewController.h"
#import "SZTheme.h"

@interface ThemesTableViewController ()

@end

@implementation ThemesTableViewController

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    if (section==1) {
        return 2;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsViewUITableViewCell"];
    //[themeCell setSelected:NO];
    
    NSData *detailTextColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailTextColor"];
    UIColor *detailTextColor = [NSKeyedUnarchiver unarchiveObjectWithData:detailTextColorData];
    NSData *backgroundColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    UIColor *backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];
    NSData *mainTextColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"mainTextColor"];
    UIColor *mainTextColor = [NSKeyedUnarchiver unarchiveObjectWithData:mainTextColorData];
    NSString *fontString = [SZTheme fontString];
    NSData *tintColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"tintColor"];
    UIColor *tintColor = [NSKeyedUnarchiver unarchiveObjectWithData:tintColorData];
    NSData *selectedCellColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCellColor"];
    UIColor *selectedCellColor = [NSKeyedUnarchiver unarchiveObjectWithData:selectedCellColorData];
    
    cell.detailTextLabel.textColor = detailTextColor;
    cell.textLabel.font = [UIFont fontWithName:fontString size:18];
    cell.textLabel.textColor = mainTextColor;
    cell.detailTextLabel.font = [UIFont fontWithName:fontString size:13];
    cell.backgroundColor = backgroundColor;
    cell.tintColor = tintColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor= selectedCellColor;
    
    NSString *currentTheme = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"];
    NSString *currentFont  = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetFont"];
    
    // Themes section
    if ([indexPath section]==0) {
        if ([indexPath row]==0)
        {
            [[cell textLabel]setText:@"Denim (Default)"];
            if ([currentTheme isEqualToString:@"Denim"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }else if ([indexPath row]==1)
        {
            [[cell textLabel]setText:@"Vampire"];
            if ([currentTheme isEqualToString:@"Vampire"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }else if ([indexPath row]==2)
        {
            [[cell textLabel]setText:@"iOS"];
            if ([currentTheme isEqualToString:@"iOS7"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
        else if ([indexPath row]==3)
        {
            [[cell textLabel]setText:@"Subtle"];
            if ([currentTheme isEqualToString:@"Subtle"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }  else if ([indexPath row]==4)
        {
            [[cell textLabel]setText:@"Version 1.0 Default"];
            if ([currentTheme isEqualToString:@"v1.0 Default"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

            }
        }
    }
    
    // Text section
    if ([indexPath section]==1) {
        if ([indexPath row]==0)
        {
            [[cell textLabel]setText:@"Light (Default)"];
            if ([currentFont isEqualToString:@"HevNeueLight"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        } else if ([indexPath row]==1)
        {
            [[cell textLabel]setText:@"Heavy"];
            if ([currentFont isEqualToString:@"HevNeue"]) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
        }
    }
    
    
    
    

    [cell setSelected:UITableViewCellSelectionStyleNone];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Themes"];
        return header;
    }
    if (section==1) {
        UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"HeaderView"];
        [[header textLabel]setText:@"Text"];
        return header;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([indexPath section]==0)
    {
        if ([indexPath row]==0)
        {
            [SZTheme setTheme:@"Denim"];

            self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
        }else if ([indexPath row]==1)
        {
            [SZTheme setTheme:@"Vampire"];

            self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
        }
        
        else if ([indexPath row]==2)
        {
            [SZTheme setTheme:@"iOS7"];

            self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
        }
        else if ([indexPath row]==3)
        {
            [SZTheme setTheme:@"Subtle"];
            
            self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
        }else if ([indexPath row]==4)
        {
            [SZTheme setTheme:@"v1.0 Default"];
            self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
        }
    }
    
    if ([indexPath section]==1) {
        if ([indexPath row]==0) {
            [SZTheme setFont:@"HevNeueLight"];
        }
        if ([indexPath row]==1) {
            [SZTheme setFont:@"HevNeue"];
        }
    }


    
    self.navigationController.navigationBar.barTintColor = [SZTheme navBackgroundColor];
    self.navigationController.navigationBar.tintColor = [SZTheme tintColor];
    

    
    themesTable.backgroundColor = [SZTheme backgroundColor];
    UITextField *titleView = (UITextField *)self.navigationItem.titleView;
    titleView.font = [UIFont fontWithName:[SZTheme fontString] size:19];
    //[self viewWillAppear:YES];
    UITextField *title = (UITextField *)self.navigationItem.titleView;
    NSLog(title.text);
    [title setTextColor:[SZTheme tintColor]];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    [themesTable reloadData];
    

    
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated
{
    UITextField *titleName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 22)];
    
    titleName.text = @"Themes & Text";
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont fontWithName:[SZTheme fontString] size:19];
    

  
    [themesTable setBackgroundColor:[SZTheme backgroundColor]];
    titleName.textColor = [SZTheme tintColor];
    titleName.textAlignment = NSTextAlignmentCenter;
    [titleName setUserInteractionEnabled:NO];
    [titleName setDelegate:self];
    self.navigationItem.titleView = titleName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
