//
//  SZQuantifierStore.h
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZQuantifier.h"
//#import <Dropbox/Dropbox.h>

@class SZQuantifier;

@interface SZQuantifierStore : NSObject
{
    NSMutableArray *allQuantifiers;
}


+ (SZQuantifierStore *)sharedStore;

- (NSMutableArray *)allQuantifiers;

- (NSInteger)numberOfQuantifiers;
- (SZQuantifier *)createQuantifierWithName:(NSString *)newQuantifierName withType:(NSString *)newQuantifierType;
- (SZQuantifier  *)createQuantifierWithName:(NSString *)newQuantifierName withDataSet:(NSMutableArray *)dataSet;
- (void)createQuantifierFromCSVFileContents:(NSString *)csvFile name:(NSString *)name;
- (void)removeQuantifier:(SZQuantifier *)p;
- (void)moveQuantifierAtIndex:(NSInteger)from
                      toIndex:(NSInteger)to;
- (NSString *)itemArchivePath;
- (void)writeAllQuantifiersCsvFilesToLocalAndDropBoxDirectory;
- (void)writeThisQuantifiersCSVToLocalAndDropboxDirectory:(SZQuantifier *)quantifierToSave;
- (BOOL)saveChanges;
- (void)postNotificationForDropboxViewUpload;
//- (NSDictionary *)parseQueryString:(NSString *)query;
@end
