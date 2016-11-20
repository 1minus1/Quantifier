//
//  SZQuantifierStore.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import "SZQuantifierStore.h"
#import "SZQuantifier.h"
#import <Dropbox/Dropbox.h>

@implementation SZQuantifierStore


+ (SZQuantifierStore *)sharedStore
{
    static SZQuantifierStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        NSString *path = [self itemArchivePath];
        
        allQuantifiers = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new one.
        
        if (!allQuantifiers) {
            allQuantifiers = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
    
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(NSMutableArray *)allQuantifiers
{
    return allQuantifiers;
}

-(NSInteger)numberOfQuantifiers
{
    NSInteger n =[allQuantifiers count];
    return n;
}

-(SZQuantifier  *)createQuantifierWithName:(NSString *)newQuantifierName withType:(NSString *)newQuantifierType
{

    
//    SZQuantifier *q = [SZQuantifier randomQuantifier];
//    [allQuantifiers addObject:q];
    
    SZQuantifier *newQuantifier = [[SZQuantifier alloc]initWithQuantifierName:newQuantifierName type:newQuantifierType dataSetOrNil:nil];
    [allQuantifiers insertObject:newQuantifier atIndex:0];
    [[SZQuantifierStore sharedStore] writeThisQuantifiersCSVToLocalAndDropboxDirectory:newQuantifier];
    
    if (!newQuantifierType) {
        [newQuantifier setType:newQuantifierType];
    }
    
    NSNumber *counter = @([allQuantifiers count]);
    BOOL success = [[SZQuantifierStore sharedStore] saveChanges];
    
    NSLog(@"Quantifiers updated? %s", success ? "true" : "false");
    NSLog(@"sharedStore updated: %@ quantifier(s) in the sharedStore", counter);
    return newQuantifier;
}

-(SZQuantifier  *)createQuantifierWithName:(NSString *)newQuantifierName withDataSet:(NSMutableArray *)dataSet
{
    
    
    //    SZQuantifier *q = [SZQuantifier randomQuantifier];
    //    [allQuantifiers addObject:q];
    
    SZQuantifier *newQuantifier = [[SZQuantifier alloc]initWithQuantifierName:newQuantifierName type:@"type1" dataSetOrNil:dataSet];
    [allQuantifiers insertObject:newQuantifier atIndex:0];
    [[SZQuantifierStore sharedStore] writeThisQuantifiersCSVToLocalAndDropboxDirectory:newQuantifier];
    
    NSNumber *counter = @([allQuantifiers count]);
    BOOL success = [[SZQuantifierStore sharedStore] saveChanges];
    
    NSLog(@"Quantifiers updated? %s", success ? "true" : "false");
    NSLog(@"sharedStore updated: %@ quantifier(s) in the sharedStore", counter);
    return newQuantifier;
}

-(void)createQuantifierFromCSVFileContents:(NSString *)csvFile name:(NSString *)name
{
    NSString *fileContents = csvFile;
    
    NSArray *rows =[fileContents componentsSeparatedByString:@"\n"];
    NSMutableArray *rows2 = [[NSMutableArray alloc] initWithArray:rows];
    // [rows2 removeObjectAtIndex:[rows2 count]-1];
    NSString *thisQuantifiersName = name;
    NSMutableArray *dataset = [[NSMutableArray alloc ]init];
    
    if ([rows2 count]>0) {
        [rows2 removeObjectAtIndex:0];
        
        for (NSString *row in rows2){
            if (![row isEqualToString:@""]) { // this check takes care of any newlines \n in the file
                NSArray *pointInfo = [row componentsSeparatedByString:@","];
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *thisdate = [df dateFromString:pointInfo[0]];
                
                NSNumberFormatter *nf =[[NSNumberFormatter alloc] init];
                [nf setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
                [nf setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *valueString= [pointInfo[1]stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                NSNumber *thisdatapointvalue = [nf numberFromString:valueString];
                
                NSNumberFormatter *nf2 =[[NSNumberFormatter alloc] init];
                [nf2 setNumberStyle:NSNumberFormatterDecimalStyle];
                [nf2 setUsesGroupingSeparator:NO];
                valueString=[nf2 stringFromNumber:thisdatapointvalue];
                
                
                SZDataPoint *thisDataPoint = [[SZDataPoint alloc]initWithDataPointValue:thisdatapointvalue date:thisdate valueString:valueString];
                [dataset addObject:thisDataPoint];
            }else{
                NSLog(@"newline saved from crashing!");
            }
            
            
        }

    }
    
    
    
    SZQuantifier *newQuantifier = [[SZQuantifier alloc]initWithQuantifierName:thisQuantifiersName type:@"importTest" dataSetOrNil:dataset];
    
    
    BOOL addThisOne= YES;
    
    for (SZQuantifier *quantifier in [[SZQuantifierStore sharedStore]allQuantifiers]) {
        if ([thisQuantifiersName isEqualToString:quantifier.quantifierName] ) {
            addThisOne=NO;
            NSLog(@"It's a duplicate: %@ not added to sharedStore.", newQuantifier.quantifierName);
        }
    }
    
    if ([newQuantifier.quantifierName isEqualToString:@""]) {
        addThisOne=NO;
        NSLog(@"Skipping an empty Quantifier.");
    }
    
    
    
    if (addThisOne) {
        
        if ([newQuantifier.quantifierName isEqualToString:@"Steps"]) {
            NSInteger isCurrentlyTrackingSteps = [[NSUserDefaults standardUserDefaults]integerForKey:@"isCurrentlyTrackingSteps"];
            if (isCurrentlyTrackingSteps) {
                newQuantifier.type=@"AutoStepTrackingOn";
            } else{
                newQuantifier.type=@"AutoStepTrackingOff";
            }
            
        }
        
        [allQuantifiers insertObject:newQuantifier atIndex:0];
        [newQuantifier updateCsvContents];
        [[SZQuantifierStore sharedStore]writeThisQuantifiersCSVToLocalAndDropboxDirectory:newQuantifier];
        NSNumber *counter = @([allQuantifiers count]);
        NSLog(@"It's new!: %@ added to sharedStore.", newQuantifier.quantifierName);
        NSLog(@"Current count: %@ Quantifier(s) in the sharedStore", counter);
        [self performSelectorOnMainThread:@selector(postNotificationForDropboxViewUpload) withObject:nil waitUntilDone:NO];
        
    }
    
    
    
    
    
}

-(void)postNotificationForDropboxViewUpload
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewOnDropboxAdd" object:Nil];
}

- (void)removeQuantifier:(SZQuantifier *)p
{
    [allQuantifiers removeObjectIdenticalTo:p];
    NSNumber *counter = @([allQuantifiers count]);
    NSString *fileName = [[[p quantifierName] stringByAppendingString:@".csv"]stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
    
    if (account){
        DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];

        
        BOOL success = [filesystem deletePath:[[DBPath root] childPath:fileName]  error:nil];
        if (success) {
            NSLog(@"File deleted");
        } else {
            NSLog(@"File not deleted.");
        }
        //[[self restClient]deletePath:[[@"/" stringByAppendingString:[p quantifierName]] stringByAppendingString:@".csv"]];
    }
 
    
    BOOL success = [[SZQuantifierStore sharedStore] saveChanges];

    NSLog(@"Quantifiers updated? %s", success ? "true" : "false");
    NSLog(@"sharedStore updated?: %@ quantifier(s) in the sharedStore", counter);
}


- (void)moveQuantifierAtIndex:(NSInteger)from
                      toIndex:(NSInteger)to;
{
    if (from==to) {
        return;
    }
    
    SZQuantifier *p = allQuantifiers[from];
    [allQuantifiers removeObjectAtIndex:from];
    [allQuantifiers insertObject:p atIndex:to];
    BOOL success = [[SZQuantifierStore sharedStore] saveChanges];
    
    NSLog(@"Quantifiers updated? %s", success ? "true" : "false");
    
}

-(NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // Get one and only one document directory from that list
    
    NSString *documentDirectory = documentDirectories[0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (void)writeThisQuantifiersCSVToLocalAndDropboxDirectory:(SZQuantifier *)quantifierToSave
{
    NSLog(@"writeThisQuantifiersCSVToLocalAndDropboxDirectory has been called.");
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];

    
    NSString *fileName =[NSString stringWithFormat:@"%@.csv", [[quantifierToSave quantifierName]stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:fullPath contents:[[quantifierToSave csvContents]dataUsingEncoding:NSUTF8StringEncoding] attributes:Nil];
    
    
    // Write it to Dropbox, too!
    // Get the linked dropboc account if it exists.
    DBAccount *account = [[DBAccountManager sharedManager]linkedAccount];
    if (account) {
        //[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        if (![DBFilesystem sharedFilesystem]) {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
        }
        
        DBFilesystem *myFilesystem = [DBFilesystem sharedFilesystem];
        DBPath *filePath = [[DBPath root] childPath:fileName];
        DBFile *fileToUpdate = [myFilesystem openFile:filePath error:nil];
        
        if (fileToUpdate) {
            
            BOOL fileWriteSucess = [fileToUpdate writeString:[quantifierToSave csvContents] error:nil];
            
            if (fileWriteSucess) {
                NSLog(@"File %@ written to Dropbox filesystem successully.", [quantifierToSave quantifierName]);
                
            }
        }else{
            DBFile *file = [myFilesystem createFile:filePath error:nil];
            [file writeString:[quantifierToSave csvContents] error:nil];
        }
        //[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

    }
    
}




-(void)writeAllQuantifiersCsvFilesToLocalAndDropBoxDirectory
{
    for (SZQuantifier *quantifier in [SZQuantifierStore sharedStore].allQuantifiers) {
        [[SZQuantifierStore sharedStore] writeThisQuantifiersCSVToLocalAndDropboxDirectory:quantifier];
    }
}

-(BOOL)saveChanges
{


    
    //returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allQuantifiers toFile:path];
}

@end
