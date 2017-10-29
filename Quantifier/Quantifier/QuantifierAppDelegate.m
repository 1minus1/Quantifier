//
//  QuantifierAppDelegate.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//


#import "QuantifierAppDelegate.h"
#import "QuantifiersViewController.h"
#import "SZQuantifierStore.h"
#import "SZTheme.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

//#import <Crashlytics/Crashlytics.h>


@implementation QuantifierAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application launched with options, etc.");
    

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];



    
    // Set up default colors.
    
    NSUserDefaults *userDefaults;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    

    
    // this is where SZTheme will do it's work. Checks for a set theme, otherwise sets Denim
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"]) {
        [SZTheme setTheme:[[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetTheme"]];
    } else{
        [SZTheme setTheme:@"Denim"];
    }
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetFont"]) {
        [SZTheme setFont:[[NSUserDefaults standardUserDefaults]objectForKey:@"currentlySetFont"]];
    } else{
        [SZTheme setFont:@"HevNeueLight"];
    }
    
    
    
    // Set the app's global tintColor
    
    UIColor *tintColor = [SZTheme tintColor];
    self.window.tintColor = tintColor;
    
    
    
    
    
    // Set up the navigation view controller with the QuantifiersViewContoller as the root, setting the background color for the NVC.
    
    QuantifiersViewController *qvc = [[QuantifiersViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:qvc];

    
    
    [nc setNavigationBarHidden:YES];
    [self.window setRootViewController:nc];
    
    

    // This initialized the dropbox client.
    
    [DBClientsManager setupWithAppKey:@"u5c14zafwxswezc"];
    
    
    // Log the currently set theme and font
    
    NSInteger quantifierCount = 0;
    NSInteger dataPointCount = 0;
    
    for (SZQuantifier *quant in [[SZQuantifierStore sharedStore]allQuantifiers]) {
        quantifierCount=quantifierCount+1;
        dataPointCount=dataPointCount+[[quant dataSet]count];
    }
    

    
    

    
    [self.window makeKeyAndVisible];
    
    return YES;
    // This is some code to test the startup.
    
};


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    DBOAuthResult *authResult = [DBClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[SZQuantifierStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all Quantifiers.");
    } else {
        NSLog(@"Could not save any of the Quantifiers.");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
