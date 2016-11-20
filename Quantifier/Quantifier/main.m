//
//  main.m
//  Quantifier
//
//  Created by Scott Zero on 6/29/13.
//  Copyright (c) 2013 Scott Zero. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QuantifierAppDelegate.h"


typedef int (*PYStdWriter)(void *, const char *, int);

static PYStdWriter _oldStdWrite;

int __pyStderrWrite(void *inFD, const char *buffer, int size)
{
    if ( strncmp(buffer, "AssertMacros: queueEntry", 24) == 0 ) {
        return 0;
    }
    return _oldStdWrite(inFD, buffer, size);
}

void __iOS7B5CleanConsoleOutput(void)
{
    _oldStdWrite = stderr->_write;
    stderr->_write = __pyStderrWrite;
}

int main(int argc, char *argv[])
{
    @autoreleasepool {
        __iOS7B5CleanConsoleOutput();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QuantifierAppDelegate class]));
    }
}


