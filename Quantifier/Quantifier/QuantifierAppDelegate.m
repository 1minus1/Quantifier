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
#import <Dropbox/Dropbox.h>
//#import <Crashlytics/Crashlytics.h>


@implementation QuantifierAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application launched with options, etc.");
    

    
    // Start up Crashlytics.
//    [Crashlytics startWithAPIKey:@"d95642637f31a78340c46281bfa5e127ee57d13b"];
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
    
    
    

    
    // If this is the first run, unlink the dropbox account to prevent islinked from return YES after a reinstall
    
    
    
    // Similarly, the approach in the Sync API is to set up an account manager
    
    DBAccountManager *accountMgr = [[DBAccountManager alloc] initWithAppKey:@"u5c14zafwxswezc" secret:@"0xeirarxsmgang4"];
    [DBAccountManager setSharedManager:accountMgr];

    
    
    
    // Log the currently set theme and font
    
    NSInteger quantifierCount = 0;
    NSInteger dataPointCount = 0;
    
    for (SZQuantifier *quant in [[SZQuantifierStore sharedStore]allQuantifiers]) {
        quantifierCount=quantifierCount+1;
        dataPointCount=dataPointCount+[[quant dataSet]count];
    }
    

    NSInteger hasDropboxAccountLinked = 0;
    
    DBAccount *account = [accountMgr linkedAccount];
    if (account) {
        hasDropboxAccountLinked = 1;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
    // This is some code to test the startup.
    
};

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    
    if ([source isEqualToString:@"com.getdropbox.Dropbox"]) {
        DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
        if (account) {
            NSLog(@"App linked successfully!");
            
            UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            topWindow.rootViewController = [UIViewController new];
            topWindow.windowLevel = UIWindowLevelAlert + 1;
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Great!"
                                                  message:@"Dropbox account linked."
                                                  preferredStyle:UIAlertControllerStyleAlert];
        
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //NSLog(@"Cancel action");
                                           }];
            [alertController addAction:cancelAction];
            
            topWindow.hidden = YES;
        
        
            [topWindow makeKeyAndVisible];
            [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dropboxLinked" object:nil];
            
            return YES;
        } else {
            //UIAlertView *confirmation = [[UIAlertView alloc]initWithTitle:@"Hmm." message:@"Dropbox linking cancelled." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[confirmation show];
            
            UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            topWindow.rootViewController = [UIViewController new];
            topWindow.windowLevel = UIWindowLevelAlert + 1;
            
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Hmm."
                                                  message:@"Dropbox linking cancelled."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //NSLog(@"Cancel action");
                                           }];
            [alertController addAction:cancelAction];
            
            topWindow.hidden = YES;
            
            
            [topWindow makeKeyAndVisible];
            [topWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewOnDropboxAdd" object:Nil];
            return NO;
        }
    }
    
    else{
        
        NSDictionary *dict = [self parseQueryString:[url query]];
        
        if (dict.count==0)
        {
            return TRUE;
        }
        NSString *value = [dict valueForKey:@"value"];
        NSString *quant = [[dict valueForKey:@"quantifier"]stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        
        SZQuantifier *quantifierForNewPoint;
        for (int i=0; i<[[SZQuantifierStore sharedStore]allQuantifiers].count; i++) {
            SZQuantifier *testQuant = [[SZQuantifierStore sharedStore] allQuantifiers][i];
            if ([quant isEqualToString:[testQuant quantifierName]]) {
                quantifierForNewPoint=testQuant;
            }
        }
        
        if (!quantifierForNewPoint) {
            
            
            
            NSString *messageForError = [@"There is no Quantifier with the name: " stringByAppendingString:quant];
            
            UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            topWindow.rootViewController = [UIViewController new];
            topWindow.windowLevel = UIWindowLevelAlert + 1;
            
            
            UIAlertController *noquantalert = [UIAlertController alertControllerWithTitle:@"Oops." message:messageForError preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                               //NSLog(@"Cancel action");
                                           }];
            [noquantalert addAction:cancelAction];
            
            
            [topWindow makeKeyAndVisible];
            [topWindow.rootViewController presentViewController:noquantalert animated:YES completion:nil];
            
            
            
        } else {
            NSDate *now=[[NSDate alloc]init];
            
            NSNumberFormatter *nf =[[NSNumberFormatter alloc] init];
            [nf setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSNumber *thisdatapointvalue = [nf numberFromString:value];
            
            SZDataPoint *thisdatapoint = [[SZDataPoint alloc]initWithDataPointValue:thisdatapointvalue date:now valueString:value];
            
            [quantifierForNewPoint addDataPoint:thisdatapoint];
            [quantifierForNewPoint sortDataSet];
            [quantifierForNewPoint updateStats];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addeddatapoint" object:nil];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil];
            
        }
        
    }
    return NO;
}

- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
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
