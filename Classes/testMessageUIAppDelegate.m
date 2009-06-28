//
//  testMessageUIAppDelegate.m
//  testMessageUI
//
//  Created by 藤川 宏之 on 09/04/10.
//  Copyright Hiroyuki-Fujikawa. 2009. All rights reserved.
//

#import "testMessageUIAppDelegate.h"
#import "testMessageUIViewController.h"

@implementation testMessageUIAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
