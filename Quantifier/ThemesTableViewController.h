//
//  ThemesTableViewController.h
//  Quantifier
//
//  Created by Scott Zero on 11/2/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemesTableViewController : UIViewController <UITableViewDataSource,UITextFieldDelegate>

{
    __weak IBOutlet UITableView *themesTable;
    
}
@end
