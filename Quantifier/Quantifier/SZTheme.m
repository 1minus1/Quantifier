//
//  SZTheme.m
//  Quantifier
//
//  Created by Scott Zero on 11/2/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "SZTheme.h"


@implementation SZTheme


+(void)setTheme:(NSString *)themeString
{
    [[NSUserDefaults standardUserDefaults]setObject:themeString forKey:@"currentlySetTheme"];
    

    
    if ([themeString isEqualToString:@"Neutral"]) {  // Cream, blueLikeJeans, orangishTan
        UIColor *backgroundFillColor = [UIColor colorWithRed:242.0f/255.0f green:240.0f/255.0f blue:225.0f/255.0f alpha:1];
        UIColor *tintColor =           [UIColor colorWithRed:0.0  /255.0f green:72.0f/255.0f  blue:102.0f/255.0f alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:206.0f/255.0f green:147.0f/255.0f blue:70.0f/255.0f  alpha:1];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor darkGrayColor];
        UIColor *selectedCellColor =   [UIColor darkGrayColor];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
        
    }
    
    if ([themeString isEqualToString:@"Neutral_"]) {  // Cream, blueLikeJeans, orangishTan
        UIColor *backgroundFillColor = [UIColor colorWithRed:255.0f/255.0f green:253.0f/255.0f blue:238.0f/255.0f alpha:1];
        UIColor *tintColor =           [UIColor colorWithRed:0.0  /255.0f green:72.0f/255.0f  blue:102.0f/255.0f alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:206.0f/255.0f green:147.0f/255.0f blue:70.0f/255.0f  alpha:1];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor darkGrayColor];
        UIColor *selectedCellColor =   [UIColor darkGrayColor];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"Denim"]) {  // veryLightGray, blueLikeJeans, brightOrange
        
        
        UIColor *backgroundFillColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
        UIColor *tintColor =           [UIColor colorWithRed:231.0f/255.0f green:150.0f/255.0f blue:60.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:20.0f/255.0f green:92.0f/255.0f blue:122.0f/255.0f  alpha:0.9];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor darkGrayColor];
        UIColor *navBackgroundColor=   [UIColor colorWithRed:0.0  /255.0f green:72.0f/255.0f  blue:102.0f/255.0f alpha:1];
        UIColor *selectedCellColor =   [UIColor colorWithWhite:0.89 alpha:1];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=navBackgroundColor;
        
//        UIColor *backgroundFillColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
//        UIColor *tintColor =           [UIColor colorWithRed:0.0  /255.0f green:72.0f/255.0f  blue:102.0f/255.0f alpha:1];
//        UIColor *pointHighlightColor = [UIColor colorWithRed:231.0f/255.0f green:150.0f/255.0f blue:60.0f/255.0f  alpha:1];
//        UIColor *mainTextColor =       [UIColor blackColor];
//        UIColor *detailTextColor =     [UIColor darkGrayColor];
//        UIColor *navBackgroundColor=   [UIColor lightGrayColor];
//        UIColor *selectedCellColor =   [UIColor colorWithWhite:0.88 alpha:1];
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"iOS7"]) { // White, blueTheSameAsSystemBlue, Orange
        UIColor *backgroundFillColor = [UIColor whiteColor];
        UIColor *tintColor =           [UIColor colorWithRed:0.0  /255.0f green:122.0f/255.0f  blue:255.0f/255.0f alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor colorWithWhite:0.97 alpha:1];
        UIColor *selectedCellColor =   [UIColor colorWithWhite:0.97 alpha:1];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"v1.0 Default"]) { // White, blueTheSameAsSystemBlue, Orange
        UIColor *backgroundFillColor = [UIColor whiteColor];
        UIColor *tintColor =           [UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor colorWithWhite:0.97 alpha:1];
        UIColor *selectedCellColor =   [UIColor colorWithWhite:0.97 alpha:1];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"Subtle"]) { // White, blueTheSameAsSystemBlue, Orange
        UIColor *backgroundFillColor = [UIColor whiteColor];
        UIColor *tintColor =           [UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
        UIColor *mainTextColor =       [UIColor blackColor];
        UIColor *detailTextColor =     [UIColor darkGrayColor];
        UIColor *navBackgroundColor=   [UIColor darkGrayColor];
        UIColor *selectedCellColor =   [UIColor colorWithWhite:0.95 alpha:1];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"Vampire"]) { // White, blueTheSameAsSystemBlue, Orange
//        UIColor *backgroundFillColor = [UIColor blackColor];
//        UIColor *tintColor =           [UIColor colorWithRed:255.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1];//204;50;153]//[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
//        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
//        UIColor *mainTextColor =       [UIColor lightGrayColor];
//        UIColor *detailTextColor =     [UIColor colorWithWhite:.5 alpha:1];
//        UIColor *navBackgroundColor=   [UIColor colorWithWhite:0.1 alpha:1];
//        UIColor *selectedCellColor =   [UIColor colorWithRed:255.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:0.35];
//        
//        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
//        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
//        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
//        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
//        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
//        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
//        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
//        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        
        UIColor *backgroundFillColor = [UIColor colorWithWhite:0.0 alpha:1];
        UIColor *tintColor =           [UIColor colorWithRed:255.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1];//204;50;153]//[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
        UIColor *mainTextColor =       [UIColor lightGrayColor];
        UIColor *detailTextColor =     [UIColor colorWithWhite:.5 alpha:1];
        UIColor *navBackgroundColor=   [UIColor colorWithWhite:0.1 alpha:1];
        UIColor *selectedCellColor=    [UIColor colorWithWhite:0.1 alpha:1];
        UIColor *goalLineColor     =   [UIColor colorWithRed:102.0f  /255.0f green:0.0f  /255.0f blue:0.0f  /255.0f alpha:1];
        UIColor *segmentedControlColor=tintColor;
        // UIColor *selectedCellColor =   [UIColor colorWithRed:255.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:0.35];
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
        
    }
    
    if ([themeString isEqualToString:@"darkAndYellow"]) { // White, blueTheSameAsSystemBlue, Orange
        UIColor *backgroundFillColor = [UIColor blackColor];
        UIColor *tintColor =           [UIColor colorWithRed:238.0f/255.0f green:173.0f/255.0f blue:14.0f/255.0f alpha:1];//204;50;153]//[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
        UIColor *mainTextColor =       [UIColor whiteColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor darkGrayColor];
        UIColor *selectedCellColor =   [UIColor darkGrayColor];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }
    
    if ([themeString isEqualToString:@"Glam"]) { // White, blueTheSameAsSystemBlue, Orange
        UIColor *backgroundFillColor = [UIColor colorWithWhite:0.1 alpha:1];
        UIColor *tintColor =           [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:153.0f/255.0f alpha:1];//204;50;153]//[UIColor colorWithRed:255.0f/255.0f green:153.0f/255.0f blue:51.0f/255.0f  alpha:1];
        UIColor *pointHighlightColor = [UIColor colorWithRed:255.0f  /255.0f green:217.0f/255.0f  blue:38.0f/255.0f alpha:1];
        UIColor *mainTextColor =       [UIColor whiteColor];
        UIColor *detailTextColor =     [UIColor lightGrayColor];
        UIColor *navBackgroundColor=   [UIColor colorWithWhite:0.2 alpha:1];
        UIColor *selectedCellColor =   [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:153.0f/255.0f alpha:0.5];
        UIColor *goalLineColor     =   [UIColor lightGrayColor];
        UIColor *segmentedControlColor=tintColor;
        
        NSData *backgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundFillColor];
        NSData *tintColorData = [NSKeyedArchiver archivedDataWithRootObject:tintColor];
        NSData *pointHighlightColorData = [NSKeyedArchiver archivedDataWithRootObject:pointHighlightColor];
        NSData *mainTextColorData = [NSKeyedArchiver archivedDataWithRootObject:mainTextColor];
        NSData *detailTextColorData = [NSKeyedArchiver archivedDataWithRootObject:detailTextColor];
        NSData *navBackgroundColorData = [NSKeyedArchiver archivedDataWithRootObject:navBackgroundColor];
        NSData *selectedCellColorData = [NSKeyedArchiver archivedDataWithRootObject:selectedCellColor];
        NSData *goalLineColorData =     [NSKeyedArchiver archivedDataWithRootObject:goalLineColor];
        NSData *segmentedControlColorData=[NSKeyedArchiver archivedDataWithRootObject:segmentedControlColor];
        
        [[NSUserDefaults standardUserDefaults] setObject:backgroundColorData forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:tintColorData forKey:@"tintColor"];
        [[NSUserDefaults standardUserDefaults] setObject:pointHighlightColorData forKey:@"pointHighlightColor"];
        [[NSUserDefaults standardUserDefaults] setObject:mainTextColorData forKey:@"mainTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:detailTextColorData forKey:@"detailTextColor"];
        [[NSUserDefaults standardUserDefaults] setObject:navBackgroundColorData forKey:@"navBackgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:selectedCellColorData forKey:@"selectedCellColor"];
        [[NSUserDefaults standardUserDefaults] setObject:goalLineColorData forKey:@"goalLineColor"];
        [[NSUserDefaults standardUserDefaults] setObject:segmentedControlColorData forKey:@"segmentedControlColor"];
    }

    
    
    // Getters for later


}

+(void)setFont:(NSString *)fontString
{
    [[NSUserDefaults standardUserDefaults]setObject:fontString forKey:@"currentlySetFont"];
    
    NSUserDefaults *userDefaults;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([fontString isEqualToString:@"HevNeueLight"]) {
        [userDefaults setValue:@"HelveticaNeue-UltraLight" forKey:@"lightFont" ];
        [userDefaults setValue:@"HelveticaNeue-Thin" forKey:@"thinFont"];
        [userDefaults setValue:@"HelveticaNeue-Light"      forKey:@"font"];
        [userDefaults setValue:@"HelveticaNeue"      forKey:@"boldFont"];
        
    }
    
    if ([fontString isEqualToString:@"HevNeue"]) {
        [userDefaults setValue:@"HelveticaNeue-Light"       forKey:@"lightFont" ];
        [userDefaults setValue:@"HelveticaNeue-Light" forKey:@"thinFont"];
        [userDefaults setValue:@"HelveticaNeue"             forKey:@"font"];
        [userDefaults setValue:@"HelveticaNeue-Bold"        forKey:@"boldFont"];
        
    }
    
    if ([fontString isEqualToString:@"open"]) {
        [userDefaults setValue:@"Open Sans Light"       forKey:@"lightFont" ];
        [userDefaults setValue:@"Open Sans Light"       forKey:@"thinFont" ];
        [userDefaults setValue:@"Open Sans"             forKey:@"font"];
        [userDefaults setValue:@"Open Sans Semibold"        forKey:@"boldFont"];
        
    }
    
}






+(UIColor *)backgroundColor
{
    NSData *backgroundColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];
}
+(UIColor *)tintColor
{
    NSData *tintColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"tintColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tintColorData];
}
+(UIColor *)pointHighlightColor
{
    NSData *pointHighlightColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pointHighlightColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:pointHighlightColorData];
}
+(UIColor *)mainTextColor
{
    NSData *mainTextColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"mainTextColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:mainTextColorData];
}
+(UIColor *)detailTextColor
{
    NSData *detailTextColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"detailTextColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:detailTextColorData];
}
+(UIColor *)navBackgroundColor
{
    NSData *navBackgroundColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"navBackgroundColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:navBackgroundColorData];
}
+(UIColor *)selectedCellColor
{
    NSData *selectedCellColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedCellColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:selectedCellColorData];
}

+(UIColor *)goalLineColor
{
    NSData *goalLineColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"goalLineColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:goalLineColorData];
}

+(UIColor *)segmentedControlColor
{
    NSData *segmentedControlColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"segmentedControlColor"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:segmentedControlColorData];
}

+(NSString *)fontString
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"font"];
}
+(NSString *)thinFontString
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"thinFont"];
}
+(NSString *)lightFontString
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"lightFont"];
}
+(NSString *)boldFontString
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"boldFont"];
}






@end
