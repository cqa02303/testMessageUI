//
//  testMessageUIAppDelegate.h
//  testMessageUI
//
//  Created by 藤川 宏之 on 09/04/10.
//  Copyright Hiroyuki-Fujikawa. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class testMessageUIViewController;

@interface testMessageUIAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    testMessageUIViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet testMessageUIViewController *viewController;

@end

