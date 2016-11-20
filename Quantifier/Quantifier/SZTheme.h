//
//  SZTheme.h
//  Quantifier
//
//  Created by Scott Zero on 11/2/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZTheme : NSObject


+(void)setTheme:(NSString *)themeString;
+(void)setFont:(NSString *)fontString;
+(UIColor *)backgroundColor;
+(UIColor *)tintColor;
+(UIColor *)pointHighlightColor;
+(UIColor *)mainTextColor;
+(UIColor *)detailTextColor;
+(UIColor *)navBackgroundColor;
+(UIColor *)selectedCellColor;
+(UIColor *)segmentedControlColor;
+(UIColor *)goalLineColor;

+(NSString *)fontString;
+(NSString *)thinFontString;
+(NSString *)lightFontString;
+(NSString *)boldFontString;



@end
